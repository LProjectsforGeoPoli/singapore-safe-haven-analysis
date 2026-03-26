# ============================================
# SINGAPORE SAFE HAVEN PROJECT
# Author: Your Name
# Date: March 2024
# Description: Quantitative analysis testing whether Singapore acts as a 
#              regional safe haven during geopolitical crises
# ============================================

# Load required libraries
library(quantmod)
library(ggplot2)
library(dplyr)
library(tidyr)

# ============================================
# PART 1: PELOSI TAIWAN EVENT - MAIN ANALYSIS
# ============================================

cat("\n==========================================\n")
cat("PART 1: PELOSI TAIWAN EVENT (August 2, 2022)\n")
cat("==========================================\n\n")

# Download Singapore and Emerging Markets data
cat("Downloading data...\n")
getSymbols("EWS", from = "2022-06-01", to = "2022-09-30")
getSymbols("EEM", from = "2022-06-01", to = "2022-09-30")

# Calculate daily returns
ews_returns <- dailyReturn(Cl(EWS))
eem_returns <- dailyReturn(Cl(EEM))

# Combine into one table
all_returns <- merge(ews_returns, eem_returns)
names(all_returns) <- c("Singapore", "EmergingMarkets")

# Day 1 results (first trading day after event)
cat("\n--- DAY 1 RESULTS (August 3, 2022) ---\n")
day1_results <- round(all_returns["2022-08-03"] * 100, 2)
print(day1_results)

# One-week cumulative results (August 3-10, 2022)
after_data <- as.data.frame(all_returns["2022-08-03/2022-08-10"])
after_data <- after_data[complete.cases(after_data), ]

sg_total <- (prod(1 + after_data$Singapore) - 1) * 100
em_total <- (prod(1 + after_data$EmergingMarkets) - 1) * 100

cat("\n--- ONE-WEEK CUMULATIVE RESULTS (Aug 3-10, 2022) ---\n")
cat(paste("Singapore:", round(sg_total, 2), "%\n"))
cat(paste("Emerging Markets:", round(em_total, 2), "%\n"))
cat(paste("SINGAPORE OUTPERFORMANCE:", round(sg_total - em_total, 2), "%\n"))

# ============================================
# PART 2: MULTI-EVENT ANALYSIS
# ============================================

cat("\n\n==========================================\n")
cat("PART 2: MULTI-EVENT ANALYSIS\n")
cat("==========================================\n\n")

# Function to analyze one event
analyze_event <- function(ticker, event_date) {
  start_date <- as.Date(event_date) - 60
  end_date <- as.Date(event_date) + 20
  getSymbols(ticker, from = start_date, to = end_date, auto.assign = TRUE)
  returns <- dailyReturn(Cl(get(ticker)))
  all_dates <- index(returns)
  post_dates <- all_dates[all_dates > as.Date(event_date)]
  first_trading_day <- post_dates[1]
  week_end <- first_trading_day + 7
  week_data <- returns[paste(first_trading_day, week_end, sep = "/")]
  week_data <- week_data[complete.cases(week_data)]
  cum_return <- (prod(1 + week_data) - 1) * 100
  return(cum_return)
}

# Define events
events <- list(
  list(name = "Pelosi Taiwan Visit", date = "2022-08-02"),
  list(name = "North Korea Missile", date = "2022-11-18"),
  list(name = "Russia Invades Ukraine", date = "2022-02-24")
)

# Run analysis for each event
multi_results <- data.frame()

for(e in events) {
  sg_return <- analyze_event("EWS", e$date)
  em_return <- analyze_event("EEM", e$date)
  
  multi_results <- rbind(multi_results, data.frame(
    Event = e$name,
    Singapore = round(sg_return, 2),
    EmergingMarkets = round(em_return, 2),
    Outperformance = round(sg_return - em_return, 2)
  ))
}

print(multi_results)
cat(paste("\nAverage Outperformance Across All Events:", 
          round(mean(multi_results$Outperformance), 2), "%\n"))

# ============================================
# PART 3: COUNTRY COMPARISON ANALYSIS
# ============================================

cat("\n\n==========================================\n")
cat("PART 3: COUNTRY COMPARISON (Pelosi Event)\n")
cat("==========================================\n\n")

# Define countries and their ETFs
countries <- list(
  Thailand = "THD",
  Singapore = "EWS",
  Taiwan = "EWT",
  Indonesia = "EIDO",
  South_Korea = "EWY",
  Vietnam = "VNM",
  Philippines = "EPHE",
  Japan = "EWJ",
  Malaysia = "EWM",
  China = "FXI"
)

country_results <- data.frame()

for(country in names(countries)) {
  ticker <- countries[[country]]
  cat(paste("Processing", country, "...\n"))
  
  getSymbols(ticker, from = "2022-06-01", to = "2022-09-30", auto.assign = TRUE)
  returns <- dailyReturn(Cl(get(ticker)))
  week_returns <- returns["2022-08-03/2022-08-10"]
  week_returns <- week_returns[complete.cases(week_returns)]
  
  if(length(week_returns) > 0) {
    cum_return <- (prod(1 + week_returns) - 1) * 100
  } else {
    cum_return <- NA
  }
  
  country_results <- rbind(country_results, data.frame(
    Country = country,
    One_Week_Return = round(cum_return, 2)
  ))
}

# Sort by performance
country_results <- country_results[order(-country_results$One_Week_Return), ]
country_results$Rank <- 1:nrow(country_results)

cat("\n--- COUNTRY RANKINGS (One-Week Return) ---\n")
print(country_results)

# ============================================
# PART 4: CURRENCY ANALYSIS
# ============================================

cat("\n\n==========================================\n")
cat("PART 4: CURRENCY ANALYSIS (Pelosi Event)\n")
cat("==========================================\n\n")

# Download currency data
cat("Downloading currency data...\n")
getSymbols("SGD=X", from = "2022-06-01", to = "2022-09-30")
getSymbols("THB=X", from = "2022-06-01", to = "2022-09-30")
getSymbols("MYR=X", from = "2022-06-01", to = "2022-09-30")
getSymbols("CNY=X", from = "2022-06-01", to = "2022-09-30")

# Calculate returns
sgd_returns <- dailyReturn(Cl(`SGD=X`))
thb_returns <- dailyReturn(Cl(`THB=X`))
myr_returns <- dailyReturn(Cl(`MYR=X`))
cny_returns <- dailyReturn(Cl(`CNY=X`))

# One-week period
sgd_week <- sgd_returns["2022-08-03/2022-08-10"]
thb_week <- thb_returns["2022-08-03/2022-08-10"]
myr_week <- myr_returns["2022-08-03/2022-08-10"]
cny_week <- cny_returns["2022-08-03/2022-08-10"]

# Remove NA values
sgd_week <- sgd_week[complete.cases(sgd_week)]
thb_week <- thb_week[complete.cases(thb_week)]
myr_week <- myr_week[complete.cases(myr_week)]
cny_week <- cny_week[complete.cases(cny_week)]

# Calculate cumulative returns
sgd_cum <- (prod(1 + sgd_week) - 1) * 100
thb_cum <- (prod(1 + thb_week) - 1) * 100
myr_cum <- (prod(1 + myr_week) - 1) * 100
cny_cum <- (prod(1 + cny_week) - 1) * 100

cat("\n--- CURRENCY MOVEMENTS (Aug 3-10, 2022) ---\n")
cat(paste("Singapore Dollar (SGD):", round(sgd_cum, 2), "%\n"))
cat(paste("Thai Baht (THB):", round(thb_cum, 2), "%\n"))
cat(paste("Malaysian Ringgit (MYR):", round(myr_cum, 2), "%\n"))
cat(paste("Chinese Yuan (CNY):", round(cny_cum, 2), "%\n"))
cat("\nNote: Positive = currency strengthened against USD\n")

# ============================================
# PART 5: VISUALIZATION
# ============================================

cat("\n\n==========================================\n")
cat("PART 5: CREATING VISUALIZATION\n")
cat("==========================================\n\n")

# Prepare data for chart
chart_data <- as.data.frame(all_returns["2022-07-15/2022-08-20"])
chart_data$Date <- as.Date(rownames(chart_data))
chart_data <- chart_data[complete.cases(chart_data), ]

# Create chart
p <- ggplot(chart_data, aes(x = Date)) +
  geom_line(aes(y = Singapore * 100, color = "Singapore"), size = 1) +
  geom_line(aes(y = EmergingMarkets * 100, color = "Emerging Markets"), size = 1) +
  geom_vline(xintercept = as.Date("2022-08-02"), 
             linetype = "dashed", 
             color = "red", 
             size = 1) +
  labs(title = "Singapore vs Emerging Markets Around Pelosi Taiwan Visit",
       subtitle = "Red line = August 2, 2022 (Pelosi visits Taiwan)",
       y = "Daily Return (%)",
       x = "Date",
       color = "Market") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Display and save chart
print(p)
ggsave("Singapore_Safe_Haven_Chart.png", width = 10, height = 6)
cat("\nChart saved as 'Singapore_Safe_Haven_Chart.png'\n")

# ============================================
# PART 6: SUMMARY OF KEY FINDINGS
# ============================================

cat("\n\n==========================================\n")
cat("PART 6: SUMMARY OF KEY FINDINGS\n")
cat("==========================================\n\n")

cat("--- PELOSI TAIWAN EVENT (August 2, 2022) ---\n")
cat(paste("Singapore One-Week Return:", round(sg_total, 2), "%\n"))
cat(paste("Emerging Markets One-Week Return:", round(em_total, 2), "%\n"))
cat(paste("Singapore Outperformance:", round(sg_total - em_total, 2), "%\n\n"))

cat("--- MULTI-EVENT AVERAGE ---\n")
cat(paste("Average Outperformance:", round(mean(multi_results$Outperformance), 2), "%\n\n"))

cat("--- COUNTRY RANKING ---\n")
cat(paste("Singapore Rank:", which(country_results$Country == "Singapore"), 
          "out of", nrow(country_results), "\n"))
cat(paste("Best Performer:", country_results$Country[1], 
          "with", country_results$One_Week_Return[1], "%\n"))
cat(paste("Worst Performer:", country_results$Country[nrow(country_results)], 
          "with", country_results$One_Week_Return[nrow(country_results)], "%\n\n"))

cat("--- CURRENCY INSIGHT ---\n")
cat(paste("Singapore Stocks: +", round(sg_total, 2), "%\n"))
cat(paste("Singapore Dollar: ", round(sgd_cum, 2), "%\n"))
cat("Finding: Equity and currency diverged - safe haven effect was in stocks only.\n")

cat("\n==========================================\n")
cat("PROJECT COMPLETE\n")
cat("==========================================\n")
