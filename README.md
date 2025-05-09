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

## 📚 Table of Contents

- [📖 Overview](#-overview)
- [🤖 Assignment 1: Workbench Control with Fuzzy Logic](#-assignment-1-workbench-control-with-fuzzy-logic)
- [🤖 Assignment 2: Intelligent Vehicle Steering with Fuzzy Logic](#-assignment-2-intelligent-vehicle-steering-with-fuzzy-logic)
- [🤖 Assignment 3: High-Dimensional Regression with TSK Models](#-assignment-3-high-dimensional-regression-with-tsk-models)
- [🤖 Assignment 4: Classification Using TSK Models](#-assignment-4-classification-using-tsk-models)
- [📂 Repository Structure](#-repository-structure)

## 📚 Table of Contents

### 🤖 Assignment 1: Control of a Workbench Mechanism
- [🎯 Objective](#-objective)
- [🧠 Theoretical Foundations](#-theoretical-foundations)
  - [🔧 Linear PI Controller](#-linear-pi-controller)
  - [🌫️ Fuzzy PI Controller](#-fuzzy-pi-controller)
- [⚙️ Implementation in MATLAB/Simulink](#-implementation-in-matlabsimulink)
- [📈 Key Results](#-key-results)
- [📘 Insights](#-insights)

### 🤖 Assignment 2: Intelligent Steering System
- [🎯 Objective](#-objective-1)
- [📝 Problem Description](#-problem-description)
- [🧠 Fuzzy System Design](#-fuzzy-system-design)
- [🛠️ System Setup](#-system-setup)
- [📈 Fine-Tuning](#-fine-tuning)
- [📊 Results](#-results)
- [📘 Observations](#-observations)

### 🤖 Assignment 3: High-Dimensional Regression with TSK Models
- [🎯 Objective](#-objective-2)
- [🧠 Theoretical Background](#-theoretical-background)
- [🛠️ Implementation](#-implementation)
  - [Airfoil Self-Noise Dataset](#-airfoil-self-noise-dataset)
  - [Superconductivity Dataset](#-superconductivity-dataset)
- [📊 Key Results](#-key-results-1)
- [📘 Observations](#-observations-1)
- [📂 Files](#-files)

### 🤖 Assignment 4: Classification Using TSK Models
- [🎯 Objective](#-objective-3)
- [🧠 Theoretical Foundations](#-theoretical-foundations-1)
- [🖥️ Part 1: Haberman Dataset](#️-part-1-haberman-dataset)
- [🖥️ Part 2: Epileptic Seizure Dataset](#️-part-2-epileptic-seizure-dataset)
- [📈 Conclusions](#-conclusions)
- [📂 Files](#-files-1)

---

## 📖 Overview
This repository contains four distinct assignments completed as part of the Computational Intelligence course at Aristotle University of Thessaloniki. Each assignment applies different computational intelligence methods, demonstrating their capabilities and performance in control, modeling, classification, and regression tasks.

The assignments cover:
1. **Linear and Fuzzy Controllers**
2. **Fuzzy Logic Controller (FLC)**
3. **High-Dimensional Regression with TSK Models**
4. **High-Dimensional Classification with TSK Models**

---

# 🤖 Assignment 1: Linear and Fuzzy Controllers

### 📌 Title: Control of a Workbench Mechanism with Fuzzy Logic Controllers  
---

## 🧠 Objective

This assignment aims to design, simulate, and optimize a **speed control system** for a **workbench mechanism** using a combination of:
- A classical **Proportional-Integral (PI) controller**
- A **Fuzzy Logic Controller (FLC)**

The key objective is to track a desired reference signal with high accuracy while ensuring robustness against external disturbances. The study is conducted in **MATLAB** using **Simulink**, the **Fuzzy Logic Toolbox**, and the **Control System Toolbox**.



## 📚 Theoretical Foundations

### 🔧 Linear PI Controller
- Elimination of steady-state error
- Quick response with minimal rise time (< 0.6 sec)
- Suppression of overshoot (< 8%) and oscillations
- High disturbance rejection

Transfer function: G_PI(s) = Kp + (Ki / s)



Controller tuning was performed using classical control theory and MATLAB’s ControlSystemDesigner. Two gain sets were evaluated:
- Set 1: \( K_p = 2.5, K_i = 0.25 \)
- Set 2 (tuned): \( K_p = 2.65, K_i = 0.125 \)



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



## ⚙️ Implementation in MATLAB/Simulink

- **Step 1**: PI controller designed and tested
- **Step 2**: FLC created via MATLAB FIS Editor
- **Step 3**: Combined PI-Fuzzy hybrid system simulated
- **Step 4**: Tuning via trial and error for optimal transient response
- **Step 5**: Analysis across different reference input profiles (step and ramp)



## 📈 Key Results

| Controller      | Rise Time (sec) | Overshoot (%) | Settling Time (sec) | Remarks                            |
|----------------|------------------|----------------|----------------------|------------------------------------|
| PI (Kp=2.5)     | ~0.55            | ~6.5           | ~2.5                 | Meets basic specs                  |
| FLC (Tuned)     | ~0.21            | ~6.52          | ~2.0                 | Faster, with minor oscillations    |
| FLC (Ke=40)     | ~0.15            | ↑↑             | ↑                    | Overshoot and instability observed |

- FLC provides more flexible adaptation, particularly beneficial for unpredictable environments.
- The COS defuzzification method contributes to smooth control output.
- Performance improved with ramp input profile (scenario 2), demonstrating robustness.


## 🔍 Comparative Analysis

| Feature                 | PI Controller     | Fuzzy Logic Controller     |
|------------------------|-------------------|----------------------------|
| Steady-state error     | Eliminated        | Eliminated                 |
| Rise Time              | Moderate          | Shorter (improved tracking)|
| Overshoot              | Moderate          | Lower                      |
| Adaptability           | Limited           | High                       |
| Complexity             | Low               | Higher (rules, fuzzification) |


## 📘 Observations

The **Fuzzy PI Controller** demonstrates superior adaptability and comparable response characteristics compared to the classical PI controller. With careful gain tuning, the fuzzy approach can yield:
- Lower overshoot
- Faster rise time
- Enhanced robustness to disturbances and input profile variability

FLC is particularly advantageous in scenarios where system modeling is imprecise or operating conditions are non-linear.

---





# 🤖 Assignment 2: Fuzzy Logic Controller (FLC)  
### 📌 Title: Intelligent Steering System for Obstacle Avoidance using Fuzzy Logic  



## 🎯 Objective

Develop a fuzzy logic controller that governs a vehicle’s **steering angle (Δθ)** based on proximity sensor input, allowing it to navigate autonomously from a start point to a goal while avoiding static obstacles.

The system is simulated in **MATLAB Simulink**, where both the fuzzy inference system (FIS) and the motion dynamics of the vehicle are modeled in a closed-loop control architecture.



## 📘 Problem Description

- The car starts from a fixed point `(4, 0.4)` with varying initial angles: `0°`, `-45°`, and `-90°`.
- The goal is to reach `(10, 3.2)` while avoiding contact with walls and obstacles.
- The car is equipped with sensors measuring:
  - **Horizontal distance** to obstacles (`dH`)
  - **Vertical distance** to obstacles (`dV`)
  - **Orientation angle** (`θ`) relative to horizontal axis

These inputs are processed by a **fuzzy controller** to determine the steering change `Δθ`.



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



## 📈 Tuning Process

To improve accuracy:
- `Small` distance fuzzy set for `dV` redefined to peak at **0.2m** instead of 0.25m
- Trapezoidal function for `Very Large` extended to 1.0m
- This tuning enhances control near walls and ensures the car reaches the exact goal



## 📊 Simulation Results

| Initial Angle | Final Distance to Target | Behavior Summary                          |
|---------------|--------------------------|-------------------------------------------|
| `θ = 0°`      | ~2.5 cm                  | Smooth approach, avoids corners           |
| `θ = -45°`    | ~3.2 cm                  | Aggressive turn followed by smooth merge  |
| `θ = -90°`    | ~4.1 cm                  | Sideward correction, converges gradually  |

- Paths are smooth and obstacle-free.
- Car adjusts steering in response to both lateral and frontal sensor data.
- Zoomed-in plots verify **collision-free motion at corners**.



## 📘 Observations

- Fuzzy controller is **generalizable across initial conditions**.
- The system exhibits **resilience to heading variations**.
- Lack of diagonal sensor data slightly impacts accuracy at step corners.
- After tuning, deviation from the goal is negligible.

---

# 🤖 Assignment 3: High-Dimensional Regression with TSK Models

### 📈 Title: High-Dimensional Regression with TSK Models



## 🎯 Objective

The goal of this assignment is to **solve regression problems using Takagi–Sugeno–Kang (TSK) fuzzy models**. The task is divided into two parts:

1. **Low-Dimensional Dataset:**  
   Application of TSK models on the Airfoil Self-Noise dataset to understand training and evaluation processes.

2. **High-Dimensional Dataset:**  
   Application on the Superconductivity dataset using **feature selection** and **subtractive clustering** to reduce model complexity.



## 🧠 Theoretical Background

The models are evaluated with these metrics:

- **MSE (Mean Squared Error):** MSE = (1/n) * Σ (y_true - y_pred)^2

- **RMSE (Root Mean Squared Error):** RMSE = sqrt(MSE)

- **R² (Coefficient of Determination):** R² = 1 - (Σ (y_true - y_pred)^2) / (Σ (y_true - mean(y_true))^2)

- **NMSE (Normalized MSE):** NMSE = MSE / Var(y_true)

- **NDEI (Normalized Deviation Index):** NDEI = sqrt(NMSE)


## 🛠️ Implementation

### Part 1: Airfoil Self-Noise Dataset

- **Dataset:** 1503 samples, 5 input features, 1 output.
- **Model Variants:**
    - 2 Membership Functions (MFs) per input + Constant output
    - 3 MFs per input + Constant output
    - 2 MFs per input + Linear output
    - 3 MFs per input + Linear output

- **Training & Validation Split:**  
  60% training / 20% validation / 20% test

- **Tools:**  
  MATLAB ANFIS, grid partitioning, and evaluation via metrics above.


### Part 2: Superconductivity Dataset

- **Dataset:** 21,263 samples, 81 input features.
- **Approach:**
    - **Feature Selection:** Using ReliefF
    - **Fuzzy Modeling:** Subtractive Clustering to generate fuzzy rules dynamically
    - **Grid Search:** To optimize:
        - Number of features: `[5, 8, 10, 12, 15]`
        - Cluster radius: `[0.2, 0.4, 0.6, 0.8, 1.0]`
    - **Cross-Validation:** 5-fold CV to validate each grid point

- **Objective:** Find the **optimal grid point** (best combo of features & cluster radius) to minimize RMSE.


## 📊 Key Results

| Model                                | MSE    | RMSE   | NMSE   | NDEI   | R²      |
|--------------------------------------|--------|--------|--------|--------|---------|
| Model 1 (2 MF, Constant Output)      | 13.81  | 3.63   | 0.299  | 0.547  | 0.700   |
| Model 2 (3 MF, Constant Output)      | 10.89  | 3.30   | 0.247  | 0.497  | 0.752   |
| Model 3 (2 MF, Linear Output)        | 6.43   | 2.54   | 0.146  | 0.382  | 0.854   |
| Model 4 (3 MF, Linear Output)        | 5.05   | 2.25   | 0.115  | 0.339  | 0.885   |

- **Best performance:** Model 4 with 3 MFs and Linear output.

For the **Superconductivity dataset:**

- **Optimal Configuration:**  
  - 15 features  
  - Cluster radius: 0.4  
  - Achieved **R² ~ 0.80** with RMSE ~15.3



## 📘 Observations

- Increasing the **number of MFs** and using **linear outputs** boosts model accuracy.
- **Feature reduction** helps lower complexity but might sacrifice accuracy.
- **Subtractive clustering** is key to manage high-dimensional data effectively.
- Trade-off between **accuracy and overfitting:** Very small cluster radii may overfit.



---

# 🤖 Assignment 4: High-Dimensional Classification with TSK Models

### 🗂️ Title: Classification Using TSK Models (Takagi-Sugeno-Kang)

## 🎯 Objective

This assignment focuses on solving **classification problems** using **TSK fuzzy inference models**. Two datasets were explored:

1. **Simple Dataset:** Haberman's Survival Dataset (306 samples, 3 features)
2. **High-Dimensional Dataset:** Epileptic Seizure Recognition Dataset (11,500 samples, 179 features)

The goal was to train TSK models using **Subtractive Clustering** and optimize them via **grid search** to balance model complexity with classification accuracy.


## 🧠 Theoretical Foundations

### 📊 TSK Model Structure

- **Fuzzy Partitioning:**  
  - *Class-Independent*: Clustering on the entire dataset.  
  - *Class-Dependent*: Clustering separately per class.

- **Cluster Radius:**  
  Defines the influence range of each fuzzy cluster.  
  - Small radius → more clusters (higher complexity)  
  - Large radius → fewer clusters (simpler model)

- **TSK Output:**  
  Singleton output functions, linear in inputs.

### 🛠 Training Process

- **Membership Functions (MFs):** Gaussian, generated from clusters.
- **Optimization:**  
  - MF parameters: tuned via Backpropagation  
  - Rule outputs: optimized via Least Squares
- **Evaluation Metrics:**  
  - Confusion Matrix  
  - Overall Accuracy (OA)  
  - User’s Accuracy (UA)  
  - Producer’s Accuracy (PA)  
  - Kappa Coefficient (K̂)

#### 📐 Key Equations:

**Overall Accuracy:**
\[
OA = \frac{\sum_{i=1}^{k} x_{ii}}{N}
\]
Where:
- \( x_{ii} \): Correct predictions for class \( C_i \)
- \( N \): Total samples

**Producer’s Accuracy (for class \( j \)):**
\[
PA_j = \frac{x_{jj}}{\sum_{c=1}^{k} x_{jc}}
\]

**User’s Accuracy (for class \( i \)):**
\[
UA_i = \frac{x_{ii}}{\sum_{r=1}^{k} x_{ir}}
\]

**Kappa Coefficient:**
\[
K̂ = \frac{OA - E}{1 - E}
\]
Where \( E \) is the expected accuracy by chance.


## 🖥️ Part 1: Haberman Dataset

- **Data Split:** 60% training, 20% validation, 20% testing.
- **Models Trained:**
  - TSK_Model_1: Class-Independent, Small Radius (0.1)
  - TSK_Model_2: Class-Independent, Large Radius (0.9)
  - TSK_Model_3: Class-Dependent, Small Radius (0.1)
  - TSK_Model_4: Class-Dependent, Large Radius (0.9)

### 🔎 Key Findings:

| Model               | OA      | Kappa  | PA (Class 1/2)      | UA (Class 1/2)    |
|---------------------|---------|--------|---------------------|-------------------|
| TSK_Model_1         | 54.10%  | 0.19   | 82.86% / 15.38%     | 56.86% / 40.00%   |
| TSK_Model_2         | 72.13%  | 0.23   | 84.00% / 18.18%     | 82.35% / 20.00%   |
| TSK_Model_3         | 68.85%  | 0.92   | 82.00% / 9.09%      | 80.39% / 10.00%   |
| TSK_Model_4         | 77.05%  | 1.63   | 86.27% / 30.00%     | 86.27% / 30.00%   |

**Insights:**
- Higher radius → simpler model, often better OA.
- Class-Dependent clustering improved performance for minority classes.


## 🖥️ Part 2: Epileptic Seizure Dataset

- **Challenge:** High-dimensionality (179 features)
- **Approach:**
  - Feature selection with **ReliefF**
  - Dimensionality reduction + **Subtractive Clustering**
  - **Grid Search:**  
    - Cluster Radius: [0.2, 0.4, 0.6, 0.8, 1]  
    - Number of Features: [5, 8, 10, 12, 15]

### 🔎 Best Result:

- **Optimal Settings:** 15 features, radius 0.4
- **Overall Accuracy (OA):** ~40%
- **Kappa:** ~0.26

**Challenges:**
- Class 5 showed persistently low UA (<1%), indicating class imbalance and feature overlap.
- High OA achieved mainly via strong performance in dominant classes.



## 📈 Conclusions

- TSK models are **flexible** but sensitive to cluster radius and feature count.
- Class-Dependent clustering is **beneficial** in imbalanced datasets.
- For high-dimensional data, **dimensionality reduction** and careful tuning are essential.


---

## 🤝 Contributors
- [Ioannis Deirmentzoglou](https://github.com/jonnyderme)

---

