cls
clear
* DATA CHARACTERISTICS
*tech firms :google(GOOG),facebook(META), microsoft(MSFT)
*non-tech firms: johnson & johnson(JNJ), MC Donalds(MCD), shell plc(SHEL)
*Treatment Group tech firms affected by AI dominance(chatgpt etc)
*Control Group non-tech firms 	
*Shock Year	2022 — the year the exogenous CHATGPT was launced
*Outcome	Return — Daily return level for each firm
*Structure	Panel data: 6 firms × 4 years (daily returns) (2021–2024) = 6,018 observations
*Format	Long format: One row per firm-year observation

* Load the dataset
import excel "C:\Users\Acer\Downloads\stock_data_longitudinal.xlsx", sheet("stock_data_longitudinal") firstrow

* Describe the data
describe
summarize


label var treated "affected by AI = 1"
label var post "Equals 1 after nov 30, 2022, 0 before nov30, 2022"

* Run the Difference-in-Differences regression
regress Daily_Return i.treated##i.post, robust

* Fixed effects model (Year Fixed Effects)
regress Daily_Return i.treated##i.post c.Date, robust


* Fixed effects with firm and year FE using xtreg
xtset ticker_id Date
xtreg Daily_Return i.post##i.treated c.Date, fe robust



gen shock_date = mdy(11, 30, 2022)
gen pre_treatment = Date < shock_date
keep if pre_treatment



* Collapse data to average return by date and group (pre-treatment only)
collapse (mean) Daily_Return, by(Date treated)

* Plot average return over time for treated vs control before the shock
twoway ///
    (line Daily_Return Date if treated == 1, lpattern(dash) lcolor(blue) ///
     legend(label(1 "Treated (Tech)"))) ///
    (line Daily_Return Date if treated == 0, lpattern(solid) lcolor(red) ///
     legend(label(2 "Control (Non-Tech)"))), ///
    title("Pre-Treatment Daily Returns: Treated vs Control") ///
    xtitle("Date") ytitle("Avg Daily Return") ///
    graphregion(color(white)) bgcolor(white) ///
    legend(order(1 "Treated (Tech)" 2 "Control (Non-Tech)"))


	
