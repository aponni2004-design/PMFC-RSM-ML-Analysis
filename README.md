# 🌱⚡ PMFC Optimization using RSM & Machine Learning

**Integrated Modelling and Optimization of *Trigonella foenum-graecum*-based Plant Microbial Fuel Cells using Response Surface Methodology and Machine Learning**

> B.Tech Final Year Project — Department of Biotechnology, University College of Engineering, Anna University – BIT Campus, Tiruchirappalli

---

## 📌 Project Overview

This project investigates the optimization of bioelectricity generation from a **Plant Microbial Fuel Cell (PMFC)** system using fenugreek (*Trigonella foenum-graecum*) as the plant species.

Two key operating variables were studied:
- **Soil salinity** (NaCl concentration: 0–120 mM)
- **Electrode distance / anode surface area** (4 cm, 5 cm, 6 cm side length)

The project combines **experimental data collection**, **statistical optimization (RSM)**, and **machine learning evaluation** to identify the conditions that maximize power density output.

---

## 🔬 Key Findings

| Metric | Value |
|--------|-------|
| Best Reactor | R5 (5 cm electrode, 60 mM NaCl) |
| Max Power Density | **2.94 nW/cm²** |
| RSM Optimal Salt | 60.5 mM |
| RSM Optimal Distance | 4.78 cm |
| RSM Model R² | 0.317 |
| ML Model R² | 0.007 |

> **Key Insight:** Physical parameters (salinity, electrode size) alone could not reliably predict power density. Temporal microbial community dynamics were identified as the dominant drivers of PMFC performance — a finding that highlights the need for microbiome characterization in future studies.

---

## 📁 Repository Structure

```
PMFC-RSM-ML-Analysis/
│
├── README.md
├── .gitignore
│
├── data/
│   ├── pmfc_raw_data.csv          # Daily voltage & current from 11 reactors (21 days)
│   └── pmfc_rsm_design.csv        # FCCD experimental design table
│
├── analysis/
│   ├── 01_rsm_analysis.R          # RSM model: coded data, polynomial fit, canonical analysis
│   ├── 02_ml_model.R              # Linear regression ML model & performance evaluation
│   └── 03_visualizations.R        # Contour plot, 3D surface, time-series charts
│
└── outputs/
    ├── contour_plot.png            # 2D RSM contour with optimal point
    ├── surface_3d.html             # Interactive Plotly 3D surface
    └── rsm_summary.txt            # Full model output, ANOVA table, eigenanalysis
```

---

## 🛠️ Methods & Tools

### Statistical Analysis
- **Response Surface Methodology (RSM)** — Face-Centred Central Composite Design (FCCD)
- **Second-order polynomial regression** — coded variable model
- **ANOVA** — significance testing of linear, interaction, and quadratic terms
- **Pearson correlation** — variable association analysis
- **Canonical / Eigenvalue analysis** — stationary point identification

### Machine Learning
- **Linear Regression** — baseline predictive model
- **Model evaluation** — R², adjusted R², F-statistic, predictor p-values

### R Packages
```r
library(rsm)      # Response surface designs and models
library(ggplot2)  # Contour and 2D visualization
library(plotly)   # Interactive 3D surface plot
library(dplyr)    # Data manipulation
```

---

## ▶️ How to Run

1. **Clone the repository**
```bash
git clone https://github.com/your-username/PMFC-RSM-ML-Analysis.git
cd PMFC-RSM-ML-Analysis
```

2. **Install required R packages**
```r
install.packages(c("rsm", "ggplot2", "plotly", "dplyr"))
```

3. **Run the analysis scripts in order**
```r
source("analysis/01_rsm_analysis.R")   # RSM model & optimal conditions
source("analysis/02_ml_model.R")       # ML model evaluation
source("analysis/03_visualizations.R") # Generate all plots
```

---

## 📊 Sample Output

The RSM canonical analysis identified the **predicted optimum** at:
- Salt concentration: **60.5 mM**
- Electrode distance: **4.78 cm**

Both eigenvalues of the Hessian matrix were negative (λ₁ = −1.60, λ₂ = −0.24), confirming a **true local maximum** within the experimental domain.

The ML linear model (R² = 0.007, p = 0.979) confirmed that physical parameters alone are insufficient predictors — biological noise dominates, pointing to unmeasured microbiome variables as the key factor.

---

## 👩‍🔬 Author

**Ponni A**
B.Tech Biotechnology (IV Year)
University College of Engineering, BIT Campus, Anna University, Tiruchirappalli

- 🔗 [LinkedIn](https://linkedin.com/in/your-profile)
- 📧 your.email@example.com

**External Guide:** Dr. S. Saravanan, Professor, Dept. of Chemical Engineering, NIT Tiruchirappalli  
**Internal Guide:** Mr. A. Sivakumar Ponnambalam, Dept. of Biotechnology, UCE BIT Campus

---

## 📚 References

Key references include Logan (2006), Strik et al. (2008, 2011), Rabaey & Rozendal (2010), and Hamelers et al. (2012). Full reference list available in the project report.

---

*This project was submitted as part of BT3811 – Project Work/Internship, Anna University.*

