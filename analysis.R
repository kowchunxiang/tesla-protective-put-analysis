data <- read.table(
  "dataset.txt",
  header = TRUE
)
data

set.seed(4)
train_indices <- sample(nrow(data), nrow(data) * 0.7)
data_e <- data[train_indices, ]
data_p <- data[-train_indices, ]

plot(data_e$X, data_e$Y1, 
     xlab="Tesla Stock Price (USD)", 
     ylab="Unhedged profit (USD)",
) 

plot(data_e$X, data_e$Y2, 
     xlab="Tesla Stock Price (USD)", 
     ylab="Hedged profit (USD)",
) 

model_k1 <- lm(Y2 ~ X, data = data_e)
summary(model_k1) 

model_k2 <- lm(Y2 ~ X + I(X^2), data = data_e)
summary(model_k2)

model_k3 <- lm(Y2 ~ X + I(X^2) + I(X^3), data = data_e)
summary(model_k3)

library(car)
data_e$X2 <- data_e$X^2 

plot(
  data_e$X, data_e$X2,
  main = "Scatterplot: X vs X^2",
  xlab = "X",
  ylab = "X^2",
)

cor(data_e$X, data_e$X^2)

X_mean_e <- mean(data_e$X)
data_e$X_c <- data_e$X - X_mean_e
data_p$X_c <- data_p$X - X_mean_e 

model_c1 <- lm(Y2 ~ X_c, data = data_e)
summary(model_c1)

model_c2 <- lm(Y2 ~ X_c + I(X_c^2), data = data_e)
summary(model_c2)

model_c3 <- lm(Y2 ~ X_c + I(X_c^2) + I(X_c^3), data = data_e)
summary(model_c3)

data_e$X2_c <- data_e$X_c^2    
plot(data_e$X_c, data_e$X2_c,
     main = "Scatterplot: Centered X vs Centered X^2",
     xlab = "Centered X (X_c)",
     ylab = "Centered X^2 (X2_c)",
)

cor(data_e$X_c, data_e$X_c^2) 

t <- rstudent(model_c2)
qqnorm(t)
qqline(t, col = "red")

yhat <- model_c2$fit
plot(yhat, t)
abline(h = 0, col = "red")

ts.plot(t)
abline(h = 0, col = "red")

pred_fitted_c2 <- predict(model_c2, newdata = data_p)
plot(data_p$Y2, pred_fitted_c2,
     xlab = "Actual Profit (Y2)",
     ylab = "Predicted Profit (Y2-hat)",
)
abline(a = 0, b = 1, col = "blue")

model_slr <- lm(Y2 ~ X, data = data_e)

X_seq <- seq(min(data$X), max(data$X)) 
X_seq_c <- X_seq - X_mean_e 
preds_poly <- predict(model_c2, newdata = data.frame(X_c = X_seq_c))
preds_slr <- predict(model_slr, newdata = data.frame(X = X_seq))

plot(data$X, data$Y2,
     xlab = "Tesla Stock Price (USD)",
     ylab = "Hedged Profit (USD)",
     pch = 19, col = "gray70", 
     ylim = c(0, max(data$Y2) + 5))

lines(X_seq, preds_poly, col = "red", lwd = 2)        
lines(X_seq, preds_slr, col = "blue", lwd = 2) 

legend("topleft",
       legend = c("Polynomial (k=2)", "Straight Line"),
       col = c("red", "blue"),
       lwd = 2)

summary(model_slr)
summary(model_c2)

mean(data_e$X)

library(car)
vif(model_k2)
vif(model_c2)


min(data_e$Y1)
min(data_e$Y2)

max(data_e$Y1)
max(data_e$Y2)

sd(data_e$Y1)
sd(data_e$Y2)

Xc_seq <- seq(min(data_e$X_c), max(data_e$X_c), length.out = 200)

marginal_unhedged <- rep(1, length(Xc_seq))
marginal_hedged <- 0.3577 + 0.0042 * Xc_seq

plot(Xc_seq, marginal_hedged,
     type = "l", lwd = 2, col = "red",
     xlab = "Centered Stock Price (X_c)",
     ylab = "Marginal Profit",
     ylim = c(0, max(marginal_unhedged, marginal_hedged)))

abline(h = 1, col = "blue", lwd = 2)

legend("topleft",
       legend = c("Hedged Strategy", "Unhedged Strategy"),
       col = c("blue", "red"),
       lwd = 2)

X2 <- data_e$X^2

Xc2 <- data_e$X_c^2

par(mfrow = c(1, 2)) 

plot(data_e$X, X2,
     xlab = "X",
     ylab = "X^2",
     main = "Before Mean Centering",
     pch = 19, col = "gray")

plot(data_e$X_c, Xc2,
     xlab = "Centered X (X_c)",
     ylab = "Centered X^2",
     main = "After Mean Centering",
     pch = 19, col = "gray")

par(mfrow = c(1, 1))

options(scipen = 999)

data <- read.table(
  "C:/Users/Kow Chun Xiang/Desktop/fm2.txt",
  header = TRUE
)

bs_put <- function(S, K, r, sigma, T) {
  d1 <- (log(S / K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T))
  d2 <- d1 - sigma * sqrt(T)
  K * exp(-r * T) * pnorm(-d2) - S * pnorm(-d1)
}

K <- 261.44
r <- 0.04
sigma <- 0.5

n <- nrow(data)

T_vec <- seq(n, 1, by = -1) / n

data$Put_Premium <- mapply(
  bs_put,
  S = data$X,
  T = T_vec,
  MoreArgs = list(K = K, r = r, sigma = sigma)
)

data$Put_Premium <- round(data$Put_Premium, 2)

print(data[, c("Seq", "Date", "X", "Put_Premium")])

data <- read.table(
  "C:/Users/Kow Chun Xiang/Desktop/fm 2.txt",  # <- change to your exact filename
  header = TRUE
)

data$Date <- as.Date(data$Date)  # format is YYYY-MM-DD, so this works

plot(data$Date, data$Put_Premium,
     type = "l",
     xlab = "Date",
     ylab = "Put Premium (USD)",
     main = "Put Premium Over Time")

points(data$Date, data$Put_Premium, pch = 16, cex = 0.4)
grid()

S0 <- 261.44
K  <- 261.44
P0 <- 45.63

ST <- seq(0, 650, by = 1)

payoff_stock <- ST
profit_stock <- ST - S0

payoff_put <- pmax(K - ST, 0)
profit_put <- payoff_put - P0

payoff_pp <- payoff_stock + payoff_put
profit_pp <- profit_stock + profit_put

plot(ST, payoff_stock, type = "l", col = "red", lwd = 2,
     xlab = "Stock Price at Maturity (S_T)", ylab = "Payoff",
     main = "Payoff at Maturity: Stock and Put",
     ylim = c(0, 400))
lines(ST, payoff_put, col = "blue", lwd = 2)
abline(v = K, lty = 3)

usr <- par("usr")
text(x = K, y = usr[3] + 0.03*(usr[4]-usr[3]),
     labels = paste0("K = ", K), pos = 4, offset = 0.5)

legend("topleft",
       legend = c("Stock payoff", "Put payoff"),
       col = c("red", "blue"), lwd = 2, bty = "o")

plot(ST, profit_stock, type = "l", col = "red", lwd = 2,
     xlab = "Stock Price at Maturity (S_T)", ylab = "Profit",
     main = "Profit at Maturity: Stock and Put")
lines(ST, profit_put, col = "blue", lwd = 2)

abline(h = 0,  lty = 3)
abline(v = K,  lty = 3)
abline(h = -P0, lty = 2)

text(x = max(ST) * 0.75, y = -P0,
     labels = paste0("-P0 = ", -1 * P0),
     pos = 3)

usr <- par("usr")
text(x = K, y = usr[3] + 0.03*(usr[4]-usr[3]),
     labels = paste0("K = ", K), pos = 4, offset = 0.5)

legend("topleft",
       legend = c("Stock profit", "Put profit"),
       col = c("red", "blue"),
       lwd = c(2, 2),
       lty = c(1, 1),
       bty = "o")

plot(ST, profit_pp, type="l", col="blue", lwd=2,
     xlab="Stock Price at Maturity (S_T)", ylab="Profit",
     main="Protective Put Profit (Stock + Put)",
     xlim=c(0, 650),
     ylim=c(-80, 120))

abline(h = 0, lty = 3)
abline(v = K, lty = 3)

usr <- par("usr")
text(x = K, y = usr[3] + 0.03*(usr[4]-usr[3]),
     labels = paste0("K = ", K), pos = 4, offset = 0.5)

points(0, -P0, pch = 19)
text(0, -P0, labels = paste0("(0, ", round(-P0, 2), ")"), pos = 4, offset = 1.2)

x0 <- K + P0
points(x0, 0, pch = 19)
text(x0, 0, labels = paste0("(", round(x0, 2), ", 0)"), pos = 4, offset = 1.2)

legend("topleft",
       legend = c("Protective put profit"),
       col = c("blue"),
       lwd = 2,
       bty = "o")



