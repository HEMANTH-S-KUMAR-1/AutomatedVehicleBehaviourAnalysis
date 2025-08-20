clc;
clear;
close all;

%% Set Paths
projectRoot = 'C:\Users\heman\OneDrive\Documents\MATLAB\CarDetectionProject';
inputPath = fullfile(projectRoot, 'input', 'traffic_video.mp4');
outputPath = fullfile(projectRoot, 'output');

if ~isfolder(outputPath)
    mkdir(outputPath);
end

%% Load Video
videoReader = VideoReader(inputPath);

%% Initialize Detectors
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, 'NumTrainingFrames', 50);
blobAnalyzer = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', true, ...
    'MinimumBlobArea', 400);

%% Initialize Variables
frameCount = 0;
vehiclePositions = {};
vehicleIDs_prev = [];
nextID = 1;
riskFlags = [];
riskLog = {};

% Prepare video writer
outputVideo = VideoWriter(fullfile(outputPath, 'annotated_output.avi'));
outputVideo.FrameRate = videoReader.FrameRate;
open(outputVideo);

% Progress bar
h = waitbar(0, 'Processing video...');

%% Main Loop
while hasFrame(videoReader)
    frame = readFrame(videoReader);
    grayFrame = rgb2gray(frame);
    foreground = step(foregroundDetector, grayFrame);

    cleaned = imopen(foreground, strel('rectangle', [3,3]));
    cleaned = imclose(cleaned, strel('rectangle', [15,15]));
    cleaned = imfill(cleaned, 'holes');

    [centroids, bboxes] = step(blobAnalyzer, cleaned);
    annotatedFrame = frame;

    % Assign IDs
    vehicleIDs = zeros(size(centroids, 1), 1);
    for i = 1:size(centroids, 1)
        matched = false;
        if frameCount > 1
            prevCentroids = vehiclePositions{frameCount};
            for j = 1:size(prevCentroids, 1)
                dist = norm(centroids(i,:) - prevCentroids(j,:));
                if dist < 30
                    vehicleIDs(i) = vehicleIDs_prev(j);
                    matched = true;
                    break;
                end
            end
        end
        if ~matched
            vehicleIDs(i) = nextID;
            nextID = nextID + 1;
        end
    end
    vehicleIDs_prev = vehicleIDs;
    vehiclePositions{frameCount + 1} = centroids;

    % Timestamp
    timestamp = frameCount / videoReader.FrameRate;
    annotatedFrame = insertText(annotatedFrame, [10, 10], sprintf('Time: %.2f sec', timestamp), 'FontSize', 14, 'BoxColor', 'black', 'TextColor', 'cyan');

    % Annotate IDs
    for i = 1:size(bboxes, 1)
        annotatedFrame = insertText(annotatedFrame, bboxes(i,1:2), ['ID: ', num2str(vehicleIDs(i))], 'TextColor', 'white', 'BoxColor', 'blue');
    end

    % Behavior Detection
    riskFlag = false;
    riskTypes = {};

    if frameCount > 1
        prevCentroids = vehiclePositions{frameCount};
        for i = 1:size(centroids, 1)
            if i <= size(prevCentroids, 1)
                dx = abs(centroids(i,1) - prevCentroids(i,1));
                dy = abs(centroids(i,2) - prevCentroids(i,2));
                if dx > 20 && dy < 10
                    riskFlag = true;
                    riskTypes{end+1} = 'Lane Change';
                    annotatedFrame = insertObjectAnnotation(annotatedFrame, 'rectangle', bboxes(i,:), 'Lane Change', 'Color', 'red');
                end
            end
        end
    end

    for i = 1:size(centroids, 1)
        for j = i+1:size(centroids, 1)
            dist = norm(centroids(i,:) - centroids(j,:));
            if dist < 50
                riskFlag = true;
                riskTypes{end+1} = 'Tailgating';
                annotatedFrame = insertShape(annotatedFrame, 'Line', [centroids(i,:) centroids(j,:)], 'Color', 'yellow', 'LineWidth', 2);
                annotatedFrame = insertText(annotatedFrame, centroids(i,:), 'Tailgating', 'TextColor', 'yellow', 'BoxColor', 'black');
            end
        end
    end

    riskFlags(frameCount + 1) = riskFlag;

    if riskFlag
        for i = 1:size(centroids, 1)
            for k = 1:length(riskTypes)
                logEntry = {frameCount + 1, timestamp, vehicleIDs(i), riskTypes{k}, centroids(i,1), centroids(i,2)};
                riskLog = [riskLog; logEntry];
            end
        end
    end

    imshow(annotatedFrame);
    title(['Frame: ', num2str(frameCount + 1), ' | Risk: ', num2str(riskFlag)]);
    pause(0.01);

    writeVideo(outputVideo, annotatedFrame);
    waitbar(frameCount / videoReader.NumFrames, h);
    frameCount = frameCount + 1;
end

%% Close Resources
close(outputVideo);
close(h);

%% Export Logs
if ~isempty(riskLog)
    riskTable = cell2table(riskLog, 'VariableNames', {'Frame', 'Timestamp', 'VehicleID', 'RiskType', 'X', 'Y'});
    writetable(riskTable, fullfile(outputPath, 'risk_behavior_log.csv'));
    writetable(riskTable, fullfile(outputPath, 'risk_behavior_log.xlsx'));
    disp('✅ Logs exported.');
else
    disp('✅ No risky behavior detected.');
end

%% Summary
riskFrames = sum(riskFlags);
disp(['📊 Risky Frames: ', num2str(riskFrames)]);
disp(['📈 Accuracy Estimate: ', num2str((riskFrames/frameCount)*100), '%']);
disp(['🎥 Annotated video saved to: ', fullfile(outputPath, 'annotated_output.avi')]);
