# singapore-safe-haven-analysis
A quantitative analysis of Singapore as a geopolitical 'safe haven', using R

# Project overview
This project tests whether Singapore acts as a regional ‘safe haven’ during geopolitical crisis, using R to analyse market reactions to these three geopolitical events in 2022.

# Key findings

## 1) Singapore Only Works for US-China Tension
| Event | Singapore | Emerging Markets | Outperformance |
|-------|-----------|------------------|----------------|
| Pelosi Taiwan Visit | +4.90% | +2.61% | **+2.29%** |
| North Korea Missile | -2.57% | -1.13% | -1.44% |
| Ukraine Invasion | -7.81% | -4.02% | -3.79% |

**Findings:** Singapore only acted as a safe haven during US-China tension.

## 2) Ranked #2 Out of 10 Asian Markets
During the Pelosi event:
1. Thailand: +4.98%
2. **Singapore: +4.90%**
3. Taiwan: +4.01%
10. China: -0.77%

## 3) Equity-Currency Divergence
| Asset | Performance |
|-------|-------------|
| Singapore Stocks | **+4.90%** |
| Singapore Dollar | **-1.08%** |

**Findings:** The safe haven effect was concentrated in stocks, not currency.

# Proposed trade strategy
Based on the findings:
- **Long:** Singapore (EWS) and Thailand (THD) ETFs
- **Short:** China (FXI) ETF
- **Reasoning:** Capture capital flight out of China into Southeast Asia during US-China tension

## Files in the repository
- `Singapore_safe_haven.R` - the main analysis script
- `Singapore_chart.png` - the visualisation of results

