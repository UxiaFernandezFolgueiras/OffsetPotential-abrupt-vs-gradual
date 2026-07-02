# Experiment 2 — Gradual Fade-out

This folder contains the scripts for Experiment 2, in which emotional visual stimuli 
(positive, negative, neutral) disappeared gradually via a fade-out procedure (250 ms).

## Contents

### stimulation/
Stimulation scripts written in MATLAB (Psychtoolbox). These scripts run the CDTD task 
with a gradual fade-out offset.

### analysis/
Analysis scripts written in MATLAB (FieldTrip):
- **preprocessing/**: EEG preprocessing pipeline (filtering, ICA, epoching, artifact rejection, channel interpolation)
- **MUA/**: Mass Univariate Analysis scripts for ERP statistical analysis

## Requirements
- MATLAB R2020b or later
- Psychtoolbox 3 (stimulation)
- FieldTrip and EEGlab (analysis)
