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

## 📘 Conclusion

The **Fuzzy PI Controller** demonstrates superior adaptability and comparable response characteristics compared to the classical PI controller. With careful gain tuning, the fuzzy approach can yield:
- Lower overshoot
- Faster rise time
- Enhanced robustness to disturbances and input profile variability

FLC is particularly advantageous in scenarios where system modeling is imprecise or operating conditions are non-linear.

---
