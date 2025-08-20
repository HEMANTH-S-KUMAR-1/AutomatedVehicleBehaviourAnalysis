# 🚗 Automated Vehicle Behaviour Analysis

This project analyzes vehicle behavior in traffic videos using MATLAB.  
It detects vehicles, assigns IDs, overlays timestamps, and identifies risky behaviors such as **lane changes** and **tailgating**.  
The system generates annotated videos, logs, and charts for further analysis.

---

## 📂 Project Structure

```
CarDetectionProject/
│── input/
│   └── traffic_video.mp4       # ✅ Input video (you provide this)
│
│── output/                     # ✅ Automatically generated
│   ├── annotated_output.avi    # Annotated video
│   ├── risk_behavior_log.csv   # Risk log (CSV)
│   ├── risk_behavior_log.xlsx  # Risk log (Excel)
│   ├── risk_behavior_frequency.png   # Chart: Frequency of risky behaviors
│   └── risk_behavior_per_frame.png   # Chart: Risky behaviors per frame
│
│── scripts/
│   └── vehicle_behavior_analysis.m   # Main MATLAB script
│
│── docs/
│   ├── README.md               # Project overview
│   └── report.pdf              # Final report (optional)
│
└── data/
    └── vehicle_tracking_data.mat   # Optional: saved tracking data
```

---

## ⚙️ Setup Instructions

1. Install **MATLAB** with:
   - Image Processing Toolbox  
   - Computer Vision Toolbox  
2. Place your input video in the `input/` folder as **`traffic_video.mp4`**.  
3. Open MATLAB and set the current folder to `CarDetectionProject`.  
4. Run the script:  

```matlab
run('scripts/vehicle_behavior_analysis.m')
```

---

## 🚀 Usage Guide

- The script **automatically**:
  - Detects vehicles  
  - Assigns IDs  
  - Overlays timestamps  
  - Identifies risky behaviors  

- All results are saved in the **`output/`** folder.  
- No manual configuration is needed beyond placing the input video.  

---

## ✨ Features

- GUI-based video selection  
- Vehicle detection and tracking  
- Vehicle ID assignment  
- Timestamp overlays  
- Risky behavior detection (**lane change, tailgating**)  
- Export to **CSV and Excel**  
- Annotated video output  
- Progress bar during processing  
- Charts and graphs from log data  

---

## 📦 Output Files

- **`annotated_output.avi`** → Video with visual annotations  
- **`risk_behavior_log.csv`** → Risk log in CSV format  
- **`risk_behavior_log.xlsx`** → Risk log in Excel format  
- **`risk_behavior_frequency.png`** → Chart showing frequency of risky behaviors  
- **`risk_behavior_per_frame.png`** → Chart showing risky behaviors per frame  

---

## 🔭 Future Enhancements

- Deep learning-based vehicle detection (**YOLO, Faster R-CNN**)  
- Real-time video stream analysis  
- Integration with GPS/sensor data  
- GUI dashboard for interactive visualization  

---

## 👨‍💻 Author

Developed by **Hemanth S Kumar**  
as part of a **MATLAB-based traffic analysis project**.
