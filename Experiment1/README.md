# Experiment 1 — Abrupt Offset

This folder contains the scripts for Experiment 1, in which emotional visual stimuli 
(positive, negative, neutral) disappeared abruptly at three durations (125, 250, 500 ms).

## Contents

### stimulation/
Stimulation scripts written in MATLAB (Psychtoolbox). These scripts run the CDTD task.

### analysis/
Analysis scripts written in MATLAB (FieldTrip):
- **preprocessing/**: EEG preprocessing pipeline (filtering, ICA, epoching, artifact rejection, channel interpolation)
- **MUA/**: Mass Univariate Analysis scripts for ERP statistical analysis

## Requirements
- MATLAB R2020b or later
- Psychtoolbox 3 (stimulation)
- FieldTrip and EEGlab (analysis)
