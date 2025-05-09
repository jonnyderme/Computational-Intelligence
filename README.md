# 🤖 Computational Intelligence Project (Fuzzy Systems)

Assignments for the "Computational Intelligence" Course Faculty of Engineering, AUTh School of Electrical and Computer Engineering: Fuzzy Logic for Closed-Loop System Optimization, Autonomous Vehicle Path Tracking with FLC, Regression Modeling of Physical Systems, Real-World data classification using Supervised Learning

---

# 💻 Computational Intelligence

---

### Assignments for "Computational Intelligence" Coursework (2023)
Assignment for the "Computational Intelligence" Course  
Faculty of Engineering, AUTh  
School of Electrical and Computer Engineering  
Electronics and Computers Department

📚 *Course:* Computer Graphics                   
🏛️ *Faculty:* AUTh - School of Electrical and Computer Engineering  
📅 *Semester:* 8th Semester, 2023–2024

---

## 📖 Overview
This repository contains four distinct assignments completed as part of the Computational Intelligence course at Aristotle University of Thessaloniki. Each assignment applies different computational intelligence methods, demonstrating their capabilities and performance in control, modeling, classification, and regression tasks.

The assignments cover:
1. **Linear and Fuzzy Controllers**
2. **Fuzzy Logic Controller (FLC)**
3. **High-Dimensional Regression with TSK Models**
4. **High-Dimensional Classification with TSK Models**

---

# 🤖 Computational Intelligence – Assignment 1

### 📌 Title: Control of a Workbench Mechanism with Fuzzy Logic Controllers  
---

## 🧠 Objective

This assignment aims to design, simulate, and optimize a **speed control system** for a **workbench mechanism** using a combination of:
- A classical **Proportional-Integral (PI) controller**
- A **Fuzzy Logic Controller (FLC)**

The key objective is to track a desired reference signal with high accuracy while ensuring robustness against external disturbances. The study is conducted in **MATLAB** using **Simulink**, the **Fuzzy Logic Toolbox**, and the **Control System Toolbox**.

---

## 📚 Theoretical Foundations

### 🔧 Linear PI Controller
- Elimination of steady-state error
- Quick response with minimal rise time (< 0.6 sec)
- Suppression of overshoot (< 8%) and oscillations
- High disturbance rejection

Transfer function:
\[
G_{PI}(s) = K_p + \frac{K_i}{s}
\]

Controller tuning was performed using classical control theory and MATLAB’s ControlSystemDesigner. Two gain sets were evaluated:
- Set 1: \( K_p = 2.5, K_i = 0.25 \)
- Set 2 (tuned): \( K_p = 2.65, K_i = 0.125 \)

---

### 🌫️ Fuzzy PI Controller

- Inputs: Error \( e(k) \), Change in Error \( \Delta e(k) \)
- Output: \( \Delta u(k) \) (control law derivative)
- Membership functions: Triangular (trimf), range [-1, 1]
- Rule Base: 49 rules (7x7 matrix)
- Inference: Larsen product inference
- Defuzzification: Center of Sums (COS)

#### Initial Gains:
- \( K = 2.5 \)
- \( a = 0.1 \) ⇒ \( K_i = a \cdot K_p = 0.25 \)

#### Tuned Gains (After Tuning):
- \( K_e = 4 \)
- \( K_i = 1 \)
- \( a = 0.25 \)
- \( K = 12 \)

---

## ⚙️ Implementation in MATLAB/Simulink

- **Step 1**: PI controller designed and tested
- **Step 2**: FLC created via MATLAB FIS Editor
- **Step 3**: Combined PI-Fuzzy hybrid system simulated
- **Step 4**: Tuning via trial and error for optimal transient response
- **Step 5**: Analysis across different reference input profiles (step and ramp)

---

## 📈 Key Results

| Controller      | Rise Time (sec) | Overshoot (%) | Settling Time (sec) | Remarks                            |
|----------------|------------------|----------------|----------------------|------------------------------------|
| PI (Kp=2.5)     | ~0.55            | ~6.5           | ~2.5                 | Meets basic specs                  |
| FLC (Tuned)     | ~0.21            | ~6.52          | ~2.0                 | Faster, with minor oscillations    |
| FLC (Ke=40)     | ~0.15            | ↑↑             | ↑                    | Overshoot and instability observed |

- FLC provides more flexible adaptation, particularly beneficial for unpredictable environments.
- The COS defuzzification method contributes to smooth control output.
- Performance improved with ramp input profile (scenario 2), demonstrating robustness.

---

## 🔍 Comparative Analysis

| Feature                 | PI Controller     | Fuzzy Logic Controller     |
|------------------------|-------------------|----------------------------|
| Steady-state error     | Eliminated        | Eliminated                 |
| Rise Time              | Moderate          | Shorter (improved tracking)|
| Overshoot              | Moderate          | Lower                      |
| Adaptability           | Limited           | High                       |
| Complexity             | Low               | Higher (rules, fuzzification) |

---

## 📘 Observations

The **Fuzzy PI Controller** demonstrates superior adaptability and comparable response characteristics compared to the classical PI controller. With careful gain tuning, the fuzzy approach can yield:
- Lower overshoot
- Faster rise time
- Enhanced robustness to disturbances and input profile variability

FLC is particularly advantageous in scenarios where system modeling is imprecise or operating conditions are non-linear.

---

# 🤖 Computational Intelligence – Assignment 2  
### 🚘 Intelligent Steering System for Obstacle Avoidance using Fuzzy Logic  

📅 Semester: Spring 2023–2024  
🏛️ Institution: AUTh – School of Electrical and Computer Engineering  
📚 Course: Computational Intelligence  
👨‍💻 Student: Ioannis Deirmentzoglou (AEM: 10015)  

---

## 🎯 Objective

Develop a fuzzy logic controller that governs a vehicle’s **steering angle (Δθ)** based on proximity sensor input, allowing it to navigate autonomously from a start point to a goal while avoiding static obstacles.

The system is simulated in **MATLAB Simulink**, where both the fuzzy inference system (FIS) and the motion dynamics of the vehicle are modeled in a closed-loop control architecture.

---

## 📘 Problem Description

- The car starts from a fixed point `(4, 0.4)` with varying initial angles: `0°`, `-45°`, and `-90°`.
- The goal is to reach `(10, 3.2)` while avoiding contact with walls and obstacles.
- The car is equipped with sensors measuring:
  - **Horizontal distance** to obstacles (`dH`)
  - **Vertical distance** to obstacles (`dV`)
  - **Orientation angle** (`θ`) relative to horizontal axis

These inputs are processed by a **fuzzy controller** to determine the steering change `Δθ`.

---

## 🧠 Theoretical Background

### 🌫️ Fuzzy Logic Principles

A fuzzy system is ideal for real-world control where crisp thresholds are limiting. This implementation uses:

- **Input variables** (`dH`, `dV`, `θ`) fuzzified into 5 linguistic terms each (e.g., Very Small, Medium, etc.)
- **Output variable** (`Δθ`) also mapped to 5 fuzzy sets
- A **Fuzzy Rule Base** of 30 rules drives decision-making

### 🧾 Rule Formation Strategy

- `dH` governs directional control to avoid frontal collisions.
- `dV` ensures lateral spacing from walls.
- Combined with `θ`, rules drive orientation correction when necessary.

> Example:  
> `If dH is Very Small and θ is ZE then Δθ is PL`  
> → The car is approaching a wall head-on → turn strongly right.

---

## 🛠️ System Implementation

### 🧩 Modules

- **FIS Design:** Implemented using MATLAB's *FIS Editor* and saved as `.fis` file.
- **Vehicle Model:** Simulink model that integrates the fuzzy controller with car motion logic.
- **Control Function (`car_control_model`)**:
  - Updates state: position `(x, y)`, orientation `θ`, and distances `dV`, `dH`
  - Handles angular transformations and normalization

### ⚙️ Control Architecture

- Normalized input range: `[-1, 1]`
- Final steering angle range: `[-130°, +130°]`
- Time step: `0.1s` with delay for realistic motion feedback

---

## 📈 Tuning Process

To improve accuracy:
- `Small` distance fuzzy set for `dV` redefined to peak at **0.2m** instead of 0.25m
- Trapezoidal function for `Very Large` extended to 1.0m
- This tuning enhances control near walls and ensures the car reaches the exact goal

---

## 📊 Simulation Results

| Initial Angle | Final Distance to Target | Behavior Summary                          |
|---------------|--------------------------|-------------------------------------------|
| `θ = 0°`      | ~2.5 cm                  | Smooth approach, avoids corners           |
| `θ = -45°`    | ~3.2 cm                  | Aggressive turn followed by smooth merge  |
| `θ = -90°`    | ~4.1 cm                  | Sideward correction, converges gradually  |

- Paths are smooth and obstacle-free.
- Car adjusts steering in response to both lateral and frontal sensor data.
- Zoomed-in plots verify **collision-free motion at corners**.

---

## 📘 Observations

- Fuzzy controller is **generalizable across initial conditions**.
- The system exhibits **resilience to heading variations**.
- Lack of diagonal sensor data slightly impacts accuracy at step corners.
- After tuning, deviation from the goal is negligible.

---
