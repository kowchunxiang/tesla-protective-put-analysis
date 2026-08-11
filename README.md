# Tesla Protective Put Analysis

Analysis of a Tesla protective put strategy using Black-Scholes option pricing, polynomial regression, and risk-return evaluation in R and Python.

## Project Overview

This project analyzes the effectiveness of a protective put strategy using Tesla Inc. (TSLA) stock.

The strategy combines a long position in Tesla stock with a put option to reduce downside risk while maintaining potential upside gains.

## Dataset

The dataset contains 251 daily observations from December 2023 to December 2024.

Main variables:

- X: Tesla stock price
- Y1: Unhedged stock profit
- Y2: Hedged profit using a protective put
- Put_Premium: Black-Scholes put option value

## Methodology

The analysis includes:

- Black-Scholes put option pricing
- Protective put strategy
- Hedged vs. unhedged profit comparison
- Data visualization
- Polynomial regression
- Mean centering
- Variance Inflation Factor (VIF)
- Model selection
- Train-test validation
- Breakeven analysis
- Downside risk comparison

## Model Selection

Linear, quadratic, and cubic polynomial models were compared.

The quadratic model was selected because it provided a strong fit, while the cubic term did not provide significant additional explanatory power.

## Risk Analysis

Compared with the unhedged stock position, the protective put strategy:

- Reduces downside losses
- Reduces profit volatility
- Provides more stable outcomes
- Sacrifices some upside potential due to the option premium

## Technologies

- R
- Python
- Black-Scholes Model
- Regression Analysis
- Statistical Modeling
- Data Visualization

## Repository Files

- `analysis.R` — Statistical analysis, polynomial regression, visualization, and risk evaluation
- `analysis.py` — Black-Scholes put option pricing calculator
- `dataset.txt` — Tesla stock price, hedged and unhedged profit, and put premium data
- `report.pdf` — Full project report and financial analysis

## Conclusion

This project demonstrates how financial mathematics and statistical modeling can be used to evaluate the risk-return characteristics of a protective put strategy.
