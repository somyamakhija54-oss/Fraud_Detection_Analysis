# 🔍 Financial Fraud Detection Analysis

A comprehensive exploratory data analysis and risk profiling project using a clean dataset of 50,000 financial transactions to identify fraudulent patterns, device risks, and transaction velocity triggers.

---

## 📌 Executive Summary
Financial fraud poses a major threat to digital payment ecosystems. This analysis evaluates **50,000 transaction records** to uncover behavioral trends, high-risk merchant/device categories, and velocity-based triggers. With an overall fraud rate of **~4.92%**, the study isolates critical risk indicators that can help optimize rule-based engines and machine learning classification pipelines.

---


## 📊 Key Data Insights & Findings

1. **Class Imbalance:** Out of 50,000 total records, exactly **2,460 transactions (~4.92%)** were flagged as fraudulent, representing a typical real-world imbalanced distribution.
2. **Transaction Amounts:** Transaction values range widely from **~5.03 to ~49,997.80**, with higher volumes showing distinct risk concentration tiers.
3. **User Velocity & History:** Users with a higher frequency of transactions in the last 24 hours and multiple `Previous_Fraudulent_Transactions` exhibit exponentially higher fraud probability.
4. **Temporal Patterns:** Transactions distributed across the 24-hour cycle (`Time_of_Transaction`) highlight specific peak hours vulnerable to malicious activities.

---
