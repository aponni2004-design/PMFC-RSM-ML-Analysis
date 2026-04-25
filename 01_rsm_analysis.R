# ================================
# LOAD LIBRARIES
# ================================
library(rsm)
library(ggplot2)
library(plotly)
library(dplyr)

# ================================
# DATA
# ================================
rsm_data <- data.frame(
  reactor  = paste0("R", 1:11),
  salt     = c(120,120,60,60,60,60,120,60,0,0,0),
  distance = c(5,6,4,6,5,5,4,5,5,6,4),
  
  v_r1=c(83,56,9.5,67.5,12,86,32,6.6,14.6,0.2,17.8),
  i_r1=c(14,7.9,1.5,10.3,1.8,13,7.5,2.2,0.4,0,2.6),
  
  v_r2=c(53.6,70,5.4,68.7,10.7,112,35.6,12.5,11.5,0,14.5),
  i_r2=c(11.7,6.8,1.9,17.1,2.1,18.5,8.2,0.2,2,0,2.1),
  
  v_r3=c(75,54,10.5,68.2,5.1,106,40.4,6.8,9.2,0.1,8.4),
  i_r3=c(6.9,5.2,1.9,12,0.1,27,6.2,1.3,1.5,0,0.4),
  
  v_r4=c(54.4,65,11.6,74,12.2,86,5.3,6,2.6,0.2,12),
  i_r4=c(6.4,6.6,7.9,14.2,0.4,31,34.1,0.7,0.5,0,0.2),
  
  v_r5=c(50.9,49,1,54.7,54.5,68.2,43.2,15.4,0.5,0.9,7.9),
  i_r5=c(11.3,2.9,8.3,6.1,3.8,25.5,5.3,1.1,1.9,0,0.5),
  
  v_r6=c(41.4,49.4,8.3,56.9,42.4,63.7,43.2,25.6,0,0.7,7.9),
  i_r6=c(4.4,4.6,0.6,6.6,5.3,28.5,3.9,4.6,0,0,0.6),
  
  v_r7=c(11.3,28,2.2,41,30,66.4,35,20.8,0.9,6.5,10),
  i_r7=c(9.3,3.5,2.2,4.8,3.2,29,7.5,1.8,0.3,0,0.6),
  
  v_r8=c(12,45,0.5,38.3,44,93,43,17,0,0.2,0.6),
  i_r8=c(2.9,3.6,0.5,8.4,5,23,4.4,2.1,1.4,0,0.2),
  
  v_r9=c(18.8,44,2.4,38,20.4,74.8,33,18,3,0.2,0.6),
  i_r9=c(3.3,3.9,0.1,7.1,4.2,24,4.7,4.7,0,0,0.2)
)

# ================================
# ELECTRODE AREA
# ================================
electrode_area <- ifelse(rsm_data$distance==4,16,
                         ifelse(rsm_data$distance==5,25,36))

# ================================
# POWER DENSITY
# ================================
calc_pd <- function(v_mV, i_uA, area) {
  (v_mV/1000) * (i_uA/1e6) * 1e6 / area
}

pd_matrix <- mapply(calc_pd,
                    v_mV = rsm_data[, grep("^v_r", names(rsm_data))],
                    i_uA = rsm_data[, grep("^i_r", names(rsm_data))],
                    area = electrode_area)

rsm_data$power_density <- rowMeans(pd_matrix)

# ================================
# RSM MODEL
# ================================
rsm_df <- rsm_data[, c("salt","distance","power_density")]

rsm_coded <- coded.data(
  rsm_df,
  x1 ~ (salt - 60)/60,
  x2 ~ (distance - 5)/1
)

rsm_model <- rsm(power_density ~ SO(x1, x2), data = rsm_coded)

summary(rsm_model)

# ================================
# OPTIMUM
# ================================
canon <- canonical(rsm_model)

opt_salt     <- canon$xs["x1"] * 60 + 60
opt_distance <- canon$xs["x2"] * 1 + 5
opt_pd       <- canon$yhat

cat("\n===== OPTIMAL CONDITIONS =====\n")
cat("Salt:", opt_salt, "mM\n")
cat("Distance:", opt_distance, "cm\n")
cat("Max PD:", opt_pd, "uW/cm2\n")

# ================================
# GRID (IMPORTANT)
# ================================
grid_df <- expand.grid(
  salt = seq(0,120,length=50),
  distance = seq(4,6,length=50)
)

grid_df$x1 <- (grid_df$salt - 60)/60
grid_df$x2 <- (grid_df$distance - 5)/1
grid_df$pd <- predict(rsm_model, newdata=grid_df)

# ================================
# CONTOUR PLOT (FIXED)
# ================================
ggplot() +
  geom_contour_filled(
    data = grid_df,
    aes(x = salt, y = distance, z = pd),
    bins = 15
  ) +
  geom_contour(
    data = grid_df,
    aes(x = salt, y = distance, z = pd),
    color = "white",
    alpha = 0.4
  ) +
  geom_point(
    data = rsm_data,
    aes(x = salt, y = distance),
    color = "black",
    size = 3
  ) +
  geom_text(
    data = rsm_data,
    aes(x = salt, y = distance, label = reactor),
    size = 3,
    vjust = -1
  ) +
  geom_point(
    aes(x = opt_salt, y = opt_distance),
    color = "red",
    size = 5
  ) +
  labs(
    title="PMFC Contour Plot",
    x="Salt (mM)",
    y="Distance (cm)",
    fill="Power Density"
  )

# ================================
# 3D SURFACE PLOT
# ================================
z_mat <- matrix(grid_df$pd, nrow=50, ncol=50)

# --- YOUR 3D PLOT ---
plot_ly(
  x = unique(grid_df$salt),
  y = unique(grid_df$distance),
  z = z_mat
) %>%
  add_surface() %>%
  layout(
    title = "PMFC 3D Surface",
    scene = list(
      xaxis = list(title="Salt (mM)"),
      yaxis = list(title="Distance (cm)"),
      zaxis = list(title="Power Density")
    )
  )

# ================================
# 🔥 PASTE YOUR FINAL CODE HERE
# ================================

# Get stationary point
stationary <- canonical(rsm_model)$xs

# Convert coded → actual
opt_salt <- stationary[1]*60 + 60
opt_distance <- stationary[2]*1 + 5

# Convert back to coded
x1_opt <- (opt_salt - 60)/60
x2_opt <- (opt_distance - 5)/1

# Predict max PD
opt_pd <- predict(rsm_model, 
                  newdata = data.frame(x1 = x1_opt, x2 = x2_opt))

# Convert to mW/m²
opt_pd_mW_m2 <- opt_pd * 10

# Print results
cat("===== FINAL OPTIMAL VALUES =====\n")
cat("Optimal Salt:", round(opt_salt, 2), "mM\n")
cat("Optimal Distance:", round(opt_distance, 2), "cm\n")
cat("Max Power Density:", round(opt_pd, 4), "µW/cm²\n")
cat("Max Power Density:", round(opt_pd_mW_m2, 4), "mW/m²\n")
write.csv(rsm_data, "pmfc_raw_data.csv", row.names = FALSE)
