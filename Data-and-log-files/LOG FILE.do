*New variables being generated
gen hrlywage = yrly_wagef/annualhrs
gen ln_hrlywagef = ln(hrlywage)
gen bachedu=0
replace bachedu=1 if aggbachelors_1stfield==9
gen fe_educ = female_f*bachedu
gen bachengin=0
replace bachengin=1 if aggbachelors_1stfield==13
gen fe_engin= female_f*bachengin
gen bachcomp = 0
replace bachcomp=1 if aggbachelors_1stfield==7
gen fe_comp= female_f*bachcomp
gen bachsci=0
replace bachsci=1 if aggbachelors_1stfield==16
gen fe_sci= female_f*bachsci
gen bachmed =0
replace bachmed=1 if aggbachelors_1stfield==26
gen fe_medical= female_f*bachmed
gen bachbusiness=0
replace bachbusiness=1 if aggbachelors_1stfield==22
gen fe_business=female_f*bachbusiness
gen nonbachelor = 0
replace nonbachelor=1 if schl <=12
gen bachphil=0
replace bachphil=1 if aggbachelors_1stfield==20
gen fe_phil=female_f*bachphil
gen bachart=0
replace bachart=1 if aggbachelors_1stfield==8
gen fe_art=bachart*female_f
gen bachsoc=0
replace bachsoc=1 if aggbachelors_1stfield==4
gen fe_soc=female_f*bachsoc
gen bachlib=0
replace bachlib=1 if aggbachelors_1stfield==15
gen fe_lib=female_f*bachlib
gen bachpsych=0
replace bachpsych=1 if aggbachelors_1stfield==21
gen fe_psych=bachpsych*female_f
*Results for presentation
reg hrlywage PhD masters_f profdeg_f female_f black_nonhisp nativeam_nonhisp asian_nonhisp pacific_nonhisp mixrac_nonhisp anyrace_hisp mar_df ib22.aggbachelors_1stfield
reg hrlywage PhD masters_f profdeg_f black_nonhisp nativeam_nonhisp asian_nonhisp pacific_nonhisp mixrac_nonhisp anyrace_hisp mar_df ib22.aggbachelors_1stfield if female_f==1
reg hrlywage PhD masters_f profdeg_f black_nonhisp nativeam_nonhisp asian_nonhisp pacific_nonhisp mixrac_nonhisp anyrace_hisp mar_df ib22.aggbachelors_1stfield if female_f==0
reg ln_hrlywage female_f fe_educ fe_engin fe_comp fe_sci fe_medical fe_business fe_psych fe_lib fe_soc fe_art fe_phil bachedu bachengin bachcomp bachsci bachmed bachbusiness bachphil bachpsych bachart bachlib bachsoc
test female_f fe_educ fe_engin fe_comp fe_sci fe_medical fe_business fe_psych fe_lib fe_soc fe_art fe_phil bachedu bachengin bachcomp bachsci bachmed bachbusiness bachphil bachpsych bachart bachlib bachsoc
*Main results and summary statistics
reg ln_hrlywagef age_f agesq PhD masters_f profdeg_f female_f black_nonhisp nativeam_nonhisp asian_nonhisp pacific_nonhisp mixrac_nonhisp anyrace_hisp mar_df ib22.aggbachelors_1stfield
reg ln_hrlywagef age_f agesq PhD masters_f profdeg_f black_nonhisp nativeam_nonhisp asian_nonhisp pacific_nonhisp mixrac_nonhisp anyrace_hisp mar_df ib22.aggbachelors_1stfield if female_f==1
reg ln_hrlywagef age_f agesq PhD masters_f profdeg_f black_nonhisp nativeam_nonhisp asian_nonhisp pacific_nonhisp mixrac_nonhisp anyrace_hisp mar_df ib22.aggbachelors_1stfield if female_f==0
tabulate aggbachelors_1stfield, summarize(female_f)
twoway (kdensity income_total if female_f==0 & aggbachelors_1stfield==22) (kdensity income_total if female_f==1 & aggbachelors_1stfield==22)
twoway (kdensity income_total if female_f==0 & aggbachelors_1stfield==9) (kdensity income_total if female_f==1 & aggbachelors_1stfield==9)
sum income_total hrlywage age_f schl annualhrs if income_total >= 0
tabulate aggbachelors_1stfield
tabulate aggbachelors_1stfield, summarize(hrlywage)
sum
tabulate aggbachelors_1stfield, summarize(income_total)
tabulate aggbachelors_1stfield if female_f==1, summarize(hrlywage)
tabulate aggbachelors_1stfield if female_f==0, summarize(hrlywage)
tabulate aggbachelors_1stfield if female_f==1, summarize(income_total)
tabulate aggbachelors_1stfield if female_f==0, summarize(income_total)
reg ln_hrlywagef age_f agesq PhD masters_f profdeg_f female_f black_nonhisp nativeam_nonhisp asian_nonhisp pacific_nonhisp mixrac_nonhisp anyrace hisp mar_df ib2.work_typef ib22.aggbachelors_1stfield
sort work_typef
gen eprofit=0
replace eprofit=1 if work_typef==1
gen busprofit=bachbusiness*eprofit
gen eeduprofit=0
drop eeduprofit
gen eeduprofit=bachedu*eprofit
gen enonprofit=0
replace enonprofit=1 if work_typef==2
gen busnonprofit=bachbusiness*enonprofit
gen edunonprofit=bachedu*enonprofit
gen localgov=0
replace localgov=1 if work_typef==3
gen buslocalgov=bachbusiness*localgov
gen edulocalgov=bachedu*localgov
gen stategov=0
replace stategov=1 if work_typef==4
gen busstategov=bachbusiness*stategov
gen edustategov=bachedu*stategov
gen fedgov=0
replace fedgov=1 if work_typef==5
gen edufed=fedgov*bachedu
gen busfed=fedgov*bachbusiness
gen senonincorp=0
replace senonincorp=1 if work_typef==6
gen edusenonincop=senonincorp*bachedu
gen bussenonincorp=bachbusiness*senonincorp
gen seincorp=0
replace seincorp=1 if work_typef==7
gen eduseincorp=bachedu*seincorp
gen busseincorp=bachbusiness*seincorp
gen wop=0
replace wop=1 if work_typef==8
gen eduwop=bachedu*wop
gen buswop=bachbusiness*wop
gen unemp=0
replace unemp=1 if work_typef==9
gen unempedu=bachedu*unemp
gen unempbus=bachbusiness*unemp
reg ln_hrlywage bachbusiness bachedu busprofit eeduprofit busnonprofit edunonprofit buslocalgov edulocalgov busstategov edustategov busfed edufed edusenonincop bussenonincorp eduseincorp busseincorp eduwop buswop unempedu unempbus eprofit enonprofit localgov stategov fedgov senonincorp seincorp wop unemp
