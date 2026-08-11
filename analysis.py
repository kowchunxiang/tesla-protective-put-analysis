import math
from scipy.stats import norm

def calculate_put_option_price():
  """
    Calculate Black-Scholes Put Option Price.
    """
print("=== Black-Scholes Model Calculator ===")

try:
  S = float(input("Enter Stock Price (S): "))
K = float(input("Enter Strike Price (K): "))
r = float(input("Enter Risk-free Rate (r): "))
T = float(input("Enter Time to Maturity (T): "))
sigma = float(input("Enter Volatility (sigma): "))

if T <= 0 or sigma <= 0 or S <= 0 or K <= 0:
  print("Error: All inputs must be positive.")
return

d1 = (math.log(S / K) + (r + (sigma ** 2) / 2) * T) / (sigma * math.sqrt(T))
d2 = d1 - sigma * math.sqrt(T)

N_minus_d1 = norm.cdf(-d1)
N_minus_d2 = norm.cdf(-d2)

P = K * math.exp(-r * T) * N_minus_d2 - S * N_minus_d1

print("Put Option Price (P) =", round(P, 4))

except ValueError:
  print("Error: Please enter valid numbers.")
except Exception as e:
  print("An error occurred:", e)

if __name__ == "__main__":
  calculate_put_option_price()