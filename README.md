# Fraud Detection Clean Dataset 🛡️

A clean, production-ready tabular dataset designed for building, testing, and benchmarking **Machine Learning models for Fraud Detection**. Containing 50,000 transaction records with balanced feature sets, this dataset is ideal for classification tasks, anomaly detection pipelines, and exploratory data analysis (EDA).

---

## 📊 Dataset Overview

* **Total Records:** 50,000 transactions
* **Features:** 12 columns (mix of numerical and categorical variables)
* **Target Variable:** `Fraudulent` (Binary: `0` for Legitimate, `1` for Fraudulent)
* **Class Distribution:** ~95.08% Legitimate / ~4.92% Fraudulent (realistic class imbalance)
* **File Format:** CSV (`Fraud_Detection_Clean_Dataset.csv`)

---

## 🗂️ Data Schema & Features

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `Transaction_ID` | `object` | Unique identifier for each transaction (e.g., T1, T2) |
| `User_ID` | `int` | Unique identifier for the user making the transaction |
| `Transaction_Amount` | `float` | Monetary value of the transaction |
| `Transaction_Type` | `object` | Method/type of transaction (e.g., ATM Withdrawal, etc.) |
| `Time_of_Transaction` | `float` | Hour of the day the transaction occurred (0.0 – 23.0) |
| `Device_Used` | `object` | Device type utilized (e.g., Mobile, Tablet, etc.) |
| `Location` | `object` | Geographical location of the transaction |
| `Previous_Fraudulent_Transactions` | `int` | Count of prior fraudulent flags linked to the user/profile |
| `Account_Age` | `int` | Age of the user account (in days/months relative to scale) |
| `Number_of_Transactions_Last_24H` | `int` | Velocity metric: transaction count in the past 24 hours |
| `Payment_Method` | `object` | Payment instrument used (e.g., Credit Card, Debit Card) |
| `Fraudulent` | `int` | Target label (`1` = Fraud, `0` = Not Fraud) |

---
