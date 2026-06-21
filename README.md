# Comparative Study of Linear and Nonlinear System Identification Approaches for Electric Vehicle Battery Modeling

This repository contains MATLAB implementations for evaluating linear and nonlinear system identification techniques for electric vehicle (EV) battery modeling.

The study compares the performance of conventional linear models and advanced nonlinear models in capturing battery voltage dynamics under varying operating conditions.

## Overview

Accurate battery models are essential for Battery Management Systems (BMS), state estimation, and energy management in electric vehicles. Due to the nonlinear behavior of lithium-ion batteries, traditional linear identification methods may not fully capture battery dynamics.

This project investigates and compares:

- ARX (AutoRegressive with eXogenous Input)
- ARMAX (AutoRegressive Moving Average with eXogenous Input)
- OE (Output Error)
- Hammerstein-Wiener (HW)
- NLARX (Nonlinear AutoRegressive with eXogenous Input)

using a synthetic battery dataset generated from a second-order RC equivalent circuit model (2RC ECM).

---

## Battery Model

The dataset is generated using a second-order RC equivalent circuit model consisting of:

- Open Circuit Voltage (OCV)
- Ohmic Resistance (R0)
- First RC polarization branch (R1-C1)
- Second RC polarization branch (R2-C2)

Additional battery characteristics include:

- SOC-dependent OCV
- Temperature-dependent resistance
- Measurement noise
- Sensor bias
- EV-inspired current profile

---

## Repository Structure

```text
.
├── battery_data_generation.m
├── hw_battery.m
├── nlarx_battery.m
├── model_comparison.m
│
├── battery_identification_results.mat
├── battery_hw_results.mat
├── battery_nlarx_results.mat
│
└── README.md
```

### Files Description

| File | Description |
|--------|-------------|
| `battery_data_generation.m` | Battery dataset generation and linear model identification (ARX, ARMAX, OE) |
| `hw_battery.m` | Hammerstein-Wiener model identification |
| `nlarx_battery.m` | NLARX model identification |
| `model_comparison.m` | Comparison of identified models and residual analysis |
| `battery_identification_results.mat` | ARX, ARMAX, and OE results |
| `battery_hw_results.mat` | Hammerstein-Wiener results |
| `battery_nlarx_results.mat` | NLARX results |

---

## Inputs and Outputs

### Inputs

- Battery Current (A)
- State of Charge (SOC)
- Temperature (°C)

### Output

- Terminal Voltage (V)

---

## Methodology

1. Generate an EV-inspired battery current profile.
2. Simulate battery dynamics using a 2RC equivalent circuit model.
3. Generate SOC, temperature, and terminal voltage signals.
4. Split data into training and validation datasets.
5. Train linear and nonlinear identification models.
6. Evaluate model performance using validation fit percentage.
7. Compare prediction accuracy and residual errors.

---

## Validation Results

| Model | Validation Fit (%) |
|---------|---------|
| ARX | 40.57 |
| ARMAX | 75.69 |
| OE | 82.87 |
| Hammerstein-Wiener | 87.55 |
| NLARX | 90.03 |

The NLARX model achieved the highest validation accuracy and demonstrated the best capability to capture the nonlinear dynamics of the battery system.

---

## Requirements

- MATLAB R2024a or newer
- System Identification Toolbox

Required functions:

- arx()
- armax()
- oe()
- nlhw()
- nlarx()
- compare()

---

## Running the Project

### Step 1

Generate the dataset and identify linear models:

```matlab
battery_data_generation
```

### Step 2

Train the Hammerstein-Wiener model:

```matlab
hw_battery
```

### Step 3

Train the NLARX model:

```matlab
nlarx_battery
```

### Step 4

Generate comparison plots:

```matlab
model_comparison
```

---

## Results

The project demonstrates that nonlinear identification methods significantly outperform conventional linear approaches for EV battery modeling.

Among all investigated models, NLARX achieved the highest prediction accuracy and provided the closest agreement with measured battery voltage responses.

---

## License

This project is intended for educational and research purposes.
