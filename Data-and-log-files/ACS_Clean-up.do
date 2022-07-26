/*Amanda Levis
February 2011
Updated May 2011
ACS 2009 PUMS*/

/*This do-file cleans up the PUMS data from the 2009 American Community Survey,
conducted under the U.S. Census Bureau. Nearly two million housing units (HUs)
and 147,000 group quarters (GQs) comprised the final interview sample, selected
on a nationally representative basis from the Master Address File (maintained by the
Census Bureau). The 2009 data was taken from geographic areas with population of
>65,000. As a one-year survey, the 2009 ACS data file includes twelve independent
GQ and HU samples (one new sample per month).  The HU and GQ living quarters
interviewed both had response rates of 98% in 2009.*/

clear
set mem 1500m
set more off
capture log close

/*The 2009 PUMS data had to be separated into two files 
to be uploaded onto Dropbox; here I append these files from Dropbox*/

use /Users/SarahAmandaLevis/Downloads/acs_data-2/ss09pusa.dta
append using /Users/SarahAmandaLevis/Downloads/acs_data-2/ss09pusb.dta


/*Dropping all unnecessary variables*/
drop if age<16
drop if age>70

#delimit ;
drop adjinc rt ddrs dear deye dout dphy drat
dratx drem fer gcl gcm gcr hins1 hins2 hins3
hins4 hins5 hins6 hins7 intp jwmnp jwrip jwtr
marhd marhm marht marhw marhyp mig mil mlpa
mlpb mlpc mlpd mlpe mlpf mlpg mlph mlpi mlpj
mlpk oip pap rel retp semp ssip ssp wrk anc
anc1p anc2p drivesp dis esp jwap jwdp msp
oc paoc pobp povpip powpuma powsp privcov 
pubcov qtrbir rac2p rac3p racnum rc sfn sfr
vps waob fancp fddrsp fdearp fdeyep fdoutp
fdphyp fdratp fdratxp fdremp fferp fgclp
fgcmp fgcrp fhins1p fhins2p fhins3c fhins3pfhins4c fhins4p fhins5c fhins5p fhins6p fhins7pfintp fjwdp fjwmnp fjwrip  fjwtrp fmarhdp fmarhmpfmarhtp fmarhwp fmarhyp fmigp fmigsp fmilppfmilsp fpap fpobp fpowsp frelp fretp fsempfssip fssp fwrkp;

/*Dropping all person weight variables except pwgtp1, pwgtp2,
and pwgtp3 in case they are useful later on*/
drop pwgtp4 pwgtp5 pwgtp6 pwgtp7
pwgtp8 pwgtp9 pwgtp10 pwgtp11 pwgtp12
pwgtp13 pwgtp14 pwgtp15 pwgtp16 pwgtp17
pwgtp18 pwgtp19 pwgtp20 pwgtp21 pwgtp22
pwgtp23 pwgtp24 pwgtp25 pwgtp26 pwgtp27
pwgtp28 pwgtp29 pwgtp30 pwgtp31 pwgtp32
pwgtp33 pwgtp34 pwgtp35 pwgtp36 pwgtp37
pwgtp38 pwgtp39 pwgtp40 pwgtp41 pwgtp42
pwgtp43 pwgtp44 pwgtp45 pwgtp46 pwgtp47
pwgtp48 pwgtp49 pwgtp50 pwgtp51 pwgtp52
pwgtp53 pwgtp54 pwgtp55 pwgtp56 pwgtp57
pwgtp58 pwgtp59 pwgtp60 pwgtp61 pwgtp62
pwgtp63 pwgtp64 pwgtp65 pwgtp66 pwgtp67
pwgtp68 pwgtp69 pwgtp70 pwgtp71 pwgtp72
pwgtp73 pwgtp74 pwgtp75 pwgtp76 pwgtp77
pwgtp78 pwgtp79 pwgtp80;
#delimit cr

/*b. Recoding imputed values as missing*/
replace agep = . if fagep==1
replace cit = . if fcitp==1
replace citwp = . if fcitwp==1
replace cow = . if fcowp==1
replace eng = . if fengp==1
replace lanx = . if flanxp==1
replace mar = . if fmarp==1
replace schl = . if fschlp==1
replace sex = . if fsexp==1
replace wagp = . if fwagp==1
replace wkhp = . if fwkhp==1
replace wkl = . if fwklp==1
replace wkw = . if fwkwp==1
replace yoep = . if fyoep==1
replace esr = . if fesrp==1
replace decade = . if fyoep==1
replace fod1p = . if ffodp==1
replace fod2p = . if ffodp==1
replace hisp = . if fhisp==1
replace indp = . if findp==1
replace lanp = . if flanp==1
replace occp = . if foccp==1
replace rac1p = . if fracp==1
replace racaian = . if fracp==1
replace racasn = . if fracp==1
replace racblk = . if fracp==1
replace racnhpi = . if fracp==1
replace racwht = . if fracp==1
//??fracp "Detailed race flag"??//

/*c. Renaming variables and labeling values*/
#delimit ;

label variable serialno "Unique person identifier";
label variable sporder "Person number (in household)";
label variable puma "Area code";


rename serialno person_identifier;
rename sporder person_number;
rename puma area_code;

/*3) What is Person 1's sex? (mark ONE box)
a) male .....1
b) female.....2*/

replace sex = 0 if sex==1;
replace sex = 1 if sex==2;
label define sexl 0 "Male" 1 "Female";
label values sex sexl;
rename sex female ;

/*4) What is Person 1's age...? (Please report babies at age 0 when the child is less than 1 year old)
Fill in age (in years)
Under 2 year.......00
1-99 yrs........01-99 (NOTE: Top-coded)*/
rename agep age;

/*5) Is Person 1 of Hispanic, Latino, or Spanish origin?
NOTE: Respondants were asked to please answer BOTH question 5 about Hispanic origin and question 6 about race.
Respondants were told that "for this survey, Hispanic origins are not races."
a) No, not of Hispanic, Latino, or Spanish origin.......1
b) Yes, other specific Central or South American/Hispanic/Latino nationalities, excluding Spaniard.......2-22
c) Spaniard...................23
d) All other Spanish/Hispanic/Latino not listed..........24*/

label variable hisp "Hispanic origin";
/*d. Creating a new variable, hisp_detail, that takes values 0-3 for different Spanish/Hispanic/Latino background
and creating a dummy variable, latamerican_d, that takes value 1 if individual is from Central or South America*/

gen hisp_detail = 1;
replace hisp_detail = 0 if hisp==1;
replace hisp_detail = 2 if hisp==23;
replace hisp_detail = 3 if hisp==24;
label define hisp1l 0 "Not Spanish/Hispanic/Latino" 1 "Central or South American" 
2 "Spanish" 3 "All other Spanish/Hispanic/Latino";
label values hisp_detail hisp1l;


gen latamerican_d = hisp_detail;
replace latamerican_d = 0 if hisp_detail==2;
replace latamerican_d = 0 if hisp_detail==3;
label define lataml 0 "Not Central or South American" 1 "Central or South American";
lab values latamerican_d lataml;

drop hisp;


/*6) What is Person 1's race? (mark one or more boxes)
a) White
b) Black, African Am., or Negro
c) American Indian or Alaska Native (print name of enrolled or principal tribe)
d) Asian Indian
e) Japanese
f) Native Hawaiian
g) Chinese
h) Korean
i) Guamanian or Chamorro
j) Filipino
k) Vietnamese
l) Samoan
m) Other Asian (print race, for example, Hmong, Laotian, Thai, Pakistani, Cambodian, and so on)
n) Other Pacific Islander (print race, for example, Fijian, Tongan, and so on)
o) Some other race (print race)*/

label define rac1pl 
1 "White alone"
2 "Black alone" 
3 "American Indian alone"
4 "Alaska native alone" 
5 "American Indian and Alaska native tribes specified or American Indian or Alaska native, not specified, and no other races" 
6 "Asian alone" 
7 "Native Hawaiian and other Pacific Islander alone"
8 "Some other race alone"
9 "Two or more major race groups";
label values rac1p rac1pl;


#delim cr
gen black_nonhisp = 0
replace black_nonhisp = 1 if rac1p==2 & latamerican_d==0

gen nativeam_nonhisp = 0
replace nativeam_nonhisp = 1 if rac1p==3 & latamerican_d==0
replace nativeam_nonhisp = 1 if rac1p==4 & latamerican_d==0
replace nativeam_nonhisp = 1 if rac1p==5 & latamerican_d==0

gen white_nonhisp = 0
replace white_nonhisp = 1 if rac1p==1 & latamerican_d==0

gen asian_nonhisp = 0
replace asian_nonhisp = 1 if rac1p==6 & latamerican_d==0

gen pacific_nonhisp = 0
replace pacific_nonhisp = 1 if rac1p==7 & latamerican_d==0

gen mixrac_nonhisp = 0
replace mixrac_nonhisp = 1 if rac1p==9 & latamerican_d==0

gen anyrace_hisp = 0
replace anyrace_hisp = 1 if latamerican_d==1

#delimit ;
replace rac1p = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;

replace black_nonhisp = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;
replace nativeam_nonhisp = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;
replace white_nonhisp = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;
replace asian_nonhisp = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;
replace pacific_nonhisp = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;
replace nativeam_nonhisp = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;
replace anyrace_hisp = . if black_nonhisp==0 & nativeam_nonhisp==0 & white_nonhisp==0
& asian_nonhisp==0 & pacific_nonhisp==0 & mixrac_nonhisp==0 & anyrace_hisp==0;

rename rac1p race_detailed;

/*e. Heritage- It is possible for one person to have a "1" in racaian and a "1" in racasnl, for example*/

label define racaianl 0 "No American Indian/Alaska Native heritage" 
1 "Some or all American Indian/Alaska Native heritage";
label values racaian racaianl;
rename racaian amerinative_d;


label define racasnl 0 "No Asian heritage" 1 "Some or all Asian heritage";
label values racasn racasnl;
rename racasn asian_d;


label define racblkl 0 "No black heritage" 1 "Some or all black heritage";
label values racblk racblkl;
rename racblk black_d;

label define racnhpil 0 "No Native Hawaiian/Other Pacific Islander heritage" 
1 "Some or all Native Hawaiian/Other Pacific Islander heritage";
label values racnhpi racnhpil;
rename racnhpi pacific_d;

label define racwht 0 "No white heritage" 1 "Some or all white heritage";
label values racwht racwhtl;
rename racwht white_d;


/*7) Where was this person born?
a) In the United States – Print name of state.
State Code: 01-72 (NOTE: Including Puerto Rico)*/
label define stl 1 "AL" 2 "AK" 4 "AZ" 5 "AR" 6 "CA" 8 "CO"
 9 "CT" 10 "DE" 11 "DC" 12 "FL" 13 "GA" 15 "HI" 16 "ID" 17 "IL" 
 18 "IN" 19 "IA" 20 "KS" 21 "KY" 22 "LA" 23 "ME" 24 "MD" 
 25 "MA" 26 "MI" 27 "MN" 28 "MS" 29 "MO" 30 "MT" 31 "NE" 32 "NV"
 33 "NH" 34 "NJ" 35 "NM" 36 "NY" 37 "NC" 38 "ND" 39 "OH" 40 "OK"
 41 "OR" 42 "PA" 44 "RI" 45 "SC" 46 "SD" 47 "TN" 48 "TX" 49 "UT"
 50 "VT" 51 "VA" 53 "WA" 54 "WV" 55 "WI" 56 "WY" 72 "PR";
label values st stl;
rename st state;


/*8) Is this person a citizen of the United States?
a) Yes, born in the United States ? SKIP to 10a......1
b) Yes, born in Puerto Rico, Guam, the U.S. Virgin Islands, or Northern Marianas.....2
c) Yes, born abroad of U.S. citizen parent or parents.....3
d) Yes, U.S. citizen by naturalization – Print year of naturalization.....4
e) No, not a U.S. citizen......5*/
label variable cit "citizenship";
label define citl 1 "Born in U.S." 
2 "Born in Puerto Rico, Guam, the U.S. Virgin Islands, or the Northern Marianas" 
3 "Born abroad of American parent(s)" 4 "U.S. citizen by naturalization" 5 "Not a citizen of the U.S.";
label values cit citl;


/*NOTE: Year of naturalization bottom-coded:
1925 or earlier....1925
1926-1930..........1926
1931-1935..........1931
1936-1940..........1936
1941-1942..........1941
1943...............1943
1944...............1944, etc.
2009...............2009*/
label variable citwp "naturalization";
/*f. getting rid of missing data for citwp when the individual did not become a US citizen by naturalization*/
replace citwp = 0 if cit<4;
replace citwp = 0 if cit>4;
rename citwp nat_yr;



/*9) When did this person come to live in the United States? (Print numbers in boxes.)
Fill in year
Born in the US.............missing
1919 or earlier............1919 (bottom-coded)
all other years individually listed, EXCEPT:
1931- 1932.................1931
1933-1934..................1933*/
/*g. recoding year of entry data for citizens born in the United States*/
replace yoep = 0 if cit==1;
label define yoepl 0 "Born in the US";
label values yoep yoepl;
rename yoep entry;


/*11) What is the highest degree or level of school this person has COMPLETED? (Mark (X) ONE box. 
If currently enrolled, mark the previous grade or highest degree received.)
a) No schooling completed........1
b) Nursery School...............2
c) Kindergarten.................3
d) Grade 1 through 11 (Specify grade 1 - 11).............4 - 14
e) 12th grade- NO DIPLOMA............15
f) Regular high school diploma...........16
g) GED or alternative credential..........17
h) Some college credit, but less than 1 year of college credit...........18
i) 1 or more years of college credit, no degree..............19
j) Associate's degree (for example: AA, AS)........20
k) Bachelor's degree (for example: BA, BS)............21
l) Master's degree (for example: MA, MS, MEng, MEd, MSW, MBA)...............22
m) Professional degree beyond a bachelor's degree (for example: MD, DDS, DVM, LLB, JD)............23
n) Doctorate degree (for example: PhD, EdD)..............24
NOTE: N/A (Less than 3 yrs old)............missing
SCH: school enrollment
No, has not attended in the last 3 mos....1
Yes, public school or public college.....2
Yes, private school or college or home school....3*/

rename sch inschool_d
replace inschool_d = 0 if inschool_d==1
replace inschool_d = 1 if inschool_d==2
replace inschool_d = 1 if inschool_d==3
lab def insch 0 "Has not attended school in last 3 mos" 1 "Has attended school in last 3 mos"
lab values inschool_d insch

rename schg inschool_grade
replace inschool_grade = 0 if 1<=inschool_grade<=7
replace inschool_grade = 1 if 8<=inschool_grade<=10
replace inschool_grade = 2 if 11<=inschool_grade<=14
replace inschool_grade = 3 if inschool_grade==15
replace inschool_grade = 4 if inschool_grade==16
#delim ;
lab def ins 0 "Elementary School" 1 "Middle School"
2 "High School" 3 "College Undergradute" 4 "Grad or Prof School Beyond a Bachelor's";
lab values inschool_grade ins;


/*h. Creating dummy variables for highest level of education attained*/

#delimit cr

label variable schl "education"

gen schld0 = 0
replace schld0 = 1 if schl<9
lab define schld0l 0 "other" 1 "highest ed: primary"
lab values schld0 schld0l


gen schld4 = 0
replace schld4 = 1 if schl>8 & schl<16
lab define schld4l 0 "other" 1 "highest ed: hsdrop"
lab values schld4 schld4l

gen schld5 = 0
replace schld5 = 1 if schl==16
lab define schld5l 0 "other" 1 "highest ed: hsgrad"
lab values schld5 schld5l

gen schld55 = 0
replace schld55 = 1 if schl==17
lab define schld55l 0 "other" 1 "highest ed: GED_equiv"
lab values schld55 schld55l

gen schld6 = 0
replace schld6 = 1 if schl>17 & schl<20
lab define schld6l 0 "other" 1 "highest ed: coll_nodeg"
lab values schld6 schld6l

gen schld7 = 0
replace schld7 = 1 if schl==20
lab define schld7l 0 "other" 1 "highest ed: associates"
lab values schld7 schld7l

gen schld8 = 0
replace schld8 = 1 if schl==21
lab define schld8l 0 "other" 1 "highest ed: bachelors"
lab values schld8 schld8l

gen schld9 = 0
replace schld9 = 1 if schl==22
lab define schld9l 0 "other" 1 "highest ed: masters" 
lab values schld9 schld9l

gen schld10 = 0
replace schld10 = 1 if schl==23
lab define schld10l 0 "other" 1 "highest ed: profdeg"
lab values schld10 schld10l

rename schld4 schld1
rename schld5 schld2
rename schld55 schld3
rename schld6 schld4
rename schld7 schld5
rename schld8 schld6
rename schld9 schld7
rename schld10 schld8

rename schld0 primary
rename schld1 hsdrop
rename schld2 hsgrad
rename schld3 GED_equiv
rename schld4 coll_nodeg
rename schld5 associates
rename schld6 bachelors
rename schld7 masters
rename schld8 profdegree

gen PhD = 0
replace PhD = 1 if schl==24
lab def schlphdl 0 "other" 1 "highest ed: doctorate's"
lab values PhD schlphdl


/*NOTE: Answer question 12 if this person has a bachelor's degree or higher. Otherwise, SKIP to question 13.
12) This question focuses on this person's BACHELOR'S DEGREE. Please print below the specific major(s) 
of any BACHELOR'S DEGREES this person has received. (For example: chemical engineering, elementary teacher 
education, organizational psychology)*/

/*h. Recoding the missing values for fod1p and fod2p (field of degree 1 and 2) as 0 if the individual received
less than a bachelor's degree and recoding missing values for fod2p as 1 if the individual received only 1
bachelor's degree; all remaining missing values should be from simple non-responsiveness*/

replace fod1p = 0 if primary==1
replace fod1p = 0 if hsdrop==1
replace fod1p = 0 if hsgrad==1
replace fod1p = 0 if GED_equiv==1
replace fod1p = 0 if coll_nodeg==1
replace fod1p = 0 if associates==1

replace fod2p = 0 if primary==1
replace fod2p = 0 if hsdrop==1
replace fod2p = 0 if hsgrad==1
replace fod2p = 0 if GED_equiv==1
replace fod2p = 0 if coll_nodeg==1
replace fod2p = 0 if associates==1
replace fod2p = 1 if fod2p>=. & fod1p<. & fod1p>0

/*i. Non-aggregated field of degree data*/
lab def f 0 "N/A (less than bachelor's degree)", add
lab def f 1 "Received Bachelor's Degree in only 1 Major", add
lab def f 1100 "GENERAL AGRICULTURE", add
lab def f 1101 ".AGRICULTURE PRODUCTION AND MANAGEMENT", add
lab def f  1102 ".AGRICULTURAL ECONOMICS", addlab def f 1103 ".ANIMAL SCIENCES", add
lab def f  1104 ".FOOD SCIENCE", add
lab def f   1105 ".PLANT SCIENCE AND AGRONOMY", add
lab def f    1106 ".SOIL SCIENCE", add
lab def f   1199 ".MISCELLANEOUS AGRICULTURE", add
lab def f    1301 ".ENVIRONMENTAL SCIENCE", add
lab def f    1302 ".FORESTRY", add
lab def f     1303 ".NATURAL RESOURCES MANAGEMENT", add
lab def f   1401 ".ARCHITECTURE", add
lab def f    1501 ".AREA ETHNIC AND CIVILIZATION STUDIES", add
lab def f     1901 ".COMMUNICATIONS", add
lab def f     1902 ".JOURNALISM", add
lab def f   1903 ".MASS MEDIA", add
lab def f  1904 ".ADVERTISING AND PUBLIC RELATIONS", add
lab def f  2001 ".COMMUNICATION TECHNOLOGIES", add
lab def f   2100 ".COMPUTER AND INFORMATION SYSTEMS", add
lab def f  2101 ".COMPUTER PROGRAMMING AND DATA PROCESSING", add
lab def f    2102 ".COMPUTER SCIENCE", add
lab def f   2105 ".INFORMATION SCIENCES", add
lab def f   2106 ".COMPUTER ADMINISTRATION MANAGEMENT AND SECURITY", add
lab def f  2107 ".COMPUTER NETWORKING AND TELECOMMUNICATIONS", add
lab def f    2201 ".COSMETOLOGY SERVICES AND CULINARY ARTS", add
lab def f  2300 ".GENERAL EDUCATION", add
lab def f  2301 ".EDUCATIONAL ADMINISTRATION AND SUPERVISION", add
lab def f   2303 ".SCHOOL STUDENT COUNSELING", add
lab def f   2304 ".ELEMENTARY EDUCATION", add
lab def f   2305 ".MATHEMATICS TEACHER EDUCATION", add
lab def f  2306 ".PHYSICAL AND HEALTH EDUCATION TEACHING", add
lab def f 2307 ".EARLY CHILDHOOD EDUCATION", add
lab def f  2308 ".SCIENCE AND COMPUTER TEACHER EDUCATION", add
lab def f   2309 ".SECONDARY TEACHER EDUCATION", add
lab def f    2310 ".SPECIAL NEEDS EDUCATION", add
lab def f     2311 ".SOCIAL SCIENCE OR HISTORY TEACHER EDUCATION", add
lab def f    2312 ".TEACHER EDUCATION: MULTIPLE LEVELS", add
lab def f   2313 ".LANGUAGE AND DRAMA EDUCATION", add
lab def f   2314 ".ART AND MUSIC EDUCATION", add
lab def f   2399 ".MISCELLANEOUS EDUCATION", add
 lab def f   2400 ".GENERAL ENGINEERING", add
lab def f   2401 ".AEROSPACE ENGINEERING", add
lab def f     2402 ".BIOLOGICAL ENGINEERING", add
lab def f     2403 ".ARCHITECTURAL ENGINEERING", add
 lab def f   2404 ".BIOMEDICAL ENGINEERING", add
 lab def f    2405 ".CHEMICAL ENGINEERING", add
 lab def f     2406 ".CIVIL ENGINEERING", add
 lab def f    2407 ".COMPUTER ENGINEERING", add
 lab def f    2408 ".ELECTRICAL ENGINEERING", add
 lab def f   2409 ".ENGINEERING MECHANICS PHYSICS AND SCIENCE", add
 lab def f     2410 ".ENVIRONMENTAL ENGINEERING", add
 lab def f   2411 ".GEOLOGICAL AND GEOPHYSICAL ENGINEERING", add
 lab def f  2412 ".INDUSTRIAL AND MANUFACTURING ENGINEERING", add
 lab def f    2413 ".MATERIALS ENGINEERING AND MATERIALS SCIENCE", add
lab def f   2414 ".MECHANICAL ENGINEERING", add
lab def f   2415 ".METALLURGICAL ENGINEERING", add
 lab def f   2416 ".MINING AND MINERAL ENGINEERING", add
 lab def f   2417 ".NAVAL ARCHITECTURE AND MARINE ENGINEERING", add
 lab def f     2418 ".NUCLEAR ENGINEERING", add
 lab def f  2419 ".PETROLEUM ENGINEERING", add
lab def f  2499 ".MISCELLANEOUS ENGINEERING", add
lab def f     2500 ".ENGINEERING TECHNOLOGIES", add
lab def f   2501 ".ENGINEERING AND INDUSTRIAL MANAGEMENT", add
 lab def f    2502 ".ELECTRICAL ENGINEERING TECHNOLOGY", add
 lab def f   2503 ".INDUSTRIAL PRODUCTION TECHNOLOGIES", add
 lab def f  2504 ".MECHANICAL ENGINEERING RELATED TECHNOLOGIES", add
 lab def f   2599 ".MISCELLANEOUS ENGINEERING TECHNOLOGIES", add
 lab def f   2601 ".LINGUISTICS AND COMPARATIVE LANGUAGE AND LITERATURE", add
 lab def f   2602 ".FRENCH GERMAN LATIN AND OTHER COMMON FOREIGN LANGUAGE STUDIES", add
 lab def f   2603 ".OTHER FOREIGN LANGUAGES", add
 lab def f    2901 ".FAMILY AND CONSUMER SCIENCES", add
 lab def f     3201 ".COURT REPORTING", add
  lab def f   3202 ".PRE-LAW AND LEGAL STUDIES", add
 lab def f     3301 ".ENGLISH LANGUAGE AND LITERATURE", add 
 lab def f     3302 ".COMPOSITION AND SPEECH", add
 lab def f    3401 ".LIBERAL ARTS", add
 lab def f    3402 ".HUMANITIES", add
lab def f     3501 ".LIBRARY SCIENCE", add
  lab def f   3600 ".BIOLOGY", add
lab def f     3601 ".BIOCHEMICAL SCIENCES", add
 lab def f   3602 ".BOTANY", add
 lab def f   3603 ".MOLECULAR BIOLOGY", add
 lab def f    3604 ".ECOLOGY", add
 lab def f    3605 ".GENETICS", add
  lab def f    3606 ".MICROBIOLOGY", add
lab def f   3607 ".PHARMACOLOGY", add
lab def f    3608 ".PHYSIOLOGY", add
lab def f     3609 ".ZOOLOGY", add
lab def f      3699 ".MISCELLANEOUS BIOLOGY", add
 lab def f      3700 ".MATHEMATICS", addlab def f 3701 ".APPLIED MATHEMATICS", add
lab def f  3702 ".STATISTICS AND DECISION SCIENCE", add
lab def f   3801 ".MILITARY TECHNOLOGIES", add
 lab def f   4001 ".INTERCULTURAL AND INTERNATIONAL STUDIES", add
lab def f     4002 ".NUTRITION SCIENCES", add
 lab def f     4003 ".NEUROSCIENCE", add
lab def f   4005 ".MATHEMATICS AND COMPUTER SCIENCE", add
lab def f   4006 ".COGNITIVE SCIENCE AND BIOPSYCHOLOGY", add
 lab def f  4007 ".INTERDISCIPLINARY SOCIAL SCIENCES", add
 lab def f   4008 ".MULTI-DISCIPLINARY OR GENERAL SCIENCE", add
 lab def f    4101 ".PHYSICAL FITNESS PARKS RECREATION AND LEISURE", add
 lab def f     4801 ".PHILOSOPHY AND RELIGIOUS STUDIES", add
 lab def f      4901 ".THEOLOGY AND RELIGIOUS VOCATIONS", add
 lab def f   5000 ".PHYSICAL SCIENCES", add
 lab def f   5001 ".ASTRONOMY AND ASTROPHYSICS", add
 lab def f   5002 ".ATMOSPHERIC SCIENCES AND METEOROLOGY", add
 lab def f    5003 ".CHEMISTRY", add
 lab def f     5004 ".GEOLOGY AND EARTH SCIENCE", add
 lab def f     5005 ".GEOSCIENCES", add
 lab def f   5006 ".OCEANOGRAPHY", add
 lab def f  5007 ".PHYSIC", add
 lab def f      5102 ".NUCLEAR, INDUSTRIAL RADIOLOGY, AND BIOLOGICAL TECHNOLOGIES", add
 lab def f   5200 ".PSYCHOLOGY", add
  lab def f    5201 ".EDUCATIONAL PSYCHOLOGY", add
 lab def f   5202 ".CLINICAL PSYCHOLOGY", add
 lab def f   5203 ".COUNSELING PSYCHOLOGY", add
 lab def f     5205 ".INDUSTRIAL AND ORGANIZATIONAL PSYCHOLOGY", add
 lab def f       5206 ".SOCIAL PSYCHOLOGY", add
 lab def f   5299 ".MISCELLANEOUS PSYCHOLOGY", add
 lab def f    5301 ".CRIMINAL JUSTICE AND FIRE PROTECTION", add
 lab def f     5401 ".PUBLIC ADMINISTRATION", add
 lab def f   5402 ".PUBLIC POLICY", add
 lab def f   5403 ".HUMAN SERVICES AND COMMUNITY ORGANIZATION", add
 lab def f  5404 ".SOCIAL WORK", add
 lab def f    5500 ".GENERAL SOCIAL SCIENCES", add
 lab def f     5501 ".ECONOMICS", add
 lab def f   5502 ".ANTHROPOLOGY AND ARCHEOLOGY", add
 lab def f     5503 ".CRIMINOLOGY", add
 lab def f    5504 ".GEOGRAPHY", add
 lab def f    5505 ".INTERNATIONAL RELATIONS", add
 lab def f 5506 ".POLITICAL SCIENCE AND GOVERNMENT", add
 lab def f  5507 ".SOCIOLOGY", add
 lab def f   5599 ".MISCELLANEOUS SOCIAL SCIENCES", add
 lab def f    5601 ".CONSTRUCTION SERVICES", add
 lab def f  5701 ".ELECTRICAL AND MECHANIC REPAIRS AND TECHNOLOGIES", add
 lab def f 5801 ".PRECISION PRODUCTION AND INDUSTRIAL ARTS", add
 lab def f 5901 ".TRANSPORTATION SCIENCES AND TECHNOLOGIES", add
 lab def f   6000 ".FINE ARTS", add
 lab def f  6001 ".DRAMA AND THEATER ARTS", add
 lab def f  6002 ".MUSIC", add
 lab def f 6003 ".VISUAL AND PERFORMING ARTS", add
  lab def f 6004 ".COMMERCIAL ART AND GRAPHIC DESIGN", add
  lab def f  6005 ".FILM VIDEO AND PHOTOGRAPHIC ARTS", add
 lab def f    6006 ".ART HISTORY AND CRITICISM", add
 lab def f   6007 ".STUDIO ARTS", add
 lab def f    6100 ".GENERAL MEDICAL AND HEALTH SERVICES", add
 lab def f   6102 ".COMMUNICATION DISORDERS SCIENCES AND SERVICES", add
 lab def f    6103 ".HEALTH AND MEDICAL ADMINISTRATIVE SERVICES", add
 lab def f     6104 ".MEDICAL ASSISTING SERVICES", add
 lab def f   6105 ".MEDICAL TECHNOLOGIES TECHNICIANS", add
 lab def f   6106 ".HEALTH AND MEDICAL PREPARATORY PROGRAMS", add
 lab def f  6107 ".NURSING", add
 lab def f  6108 ".PHARMACY PHARMACEUTICAL SCIENCES AND ADMINISTRATION", add
 lab def f    6109 ".TREATMENT THERAPY PROFESSIONS", add
  lab def f   6110 ".COMMUNITY AND PUBLIC HEALTH", add
  lab def f   6199 ".MISCELLANEOUS HEALTH MEDICAL PROFESSIONS", add
  lab def f  6200 ".GENERAL BUSINESS", add
  lab def f  6201 ".ACCOUNTING", add
  lab def f   6202 ".ACTUARIAL SCIENCE", add
  lab def f    6203 ".BUSINESS MANAGEMENT AND ADMINISTRATION", add
  lab def f  6204 ".OPERATIONS LOGISTICS AND E-COMMERCE", add
  lab def f    6205 ".BUSINESS ECONOMICS", add
  lab def f  6206 ".MARKETING AND MARKETING RESEARCH", add
  lab def f   6207 ".FINANCE", add
  lab def f    6209 ".HUMAN RESOURCES AND PERSONNEL MANAGEMENT", add
  lab def f  6210 ".INTERNATIONAL BUSINESS", add
 lab def f  6211 ".HOSPITALITY MANAGEMENT", add
  lab def f   6212 ".MANAGEMENT INFORMATION SYSTEMS AND STATISTICS", add
 lab def f   6299 ".MISCELLANEOUS BUSINESS & MEDICAL ADMINISTRATION", add
 lab def f    6402 ".HISTORY", add
 lab def f  6403 ".UNITED STATES HISTORY", add
 
 lab values fod1p f
 lab values fod2p f
rename fod1p bachelors_1stfield
rename fod2p bachelors_2ndfield


 
/*j. Aggregated field of degree data*/
gen fod1pAG = bachelors_1stfield
gen fod2pAG = bachelors_2ndfield


replace fod1pAG = 2 if fod1p>1099 & fod1p<1304
replace fod1pAG = 3 if fod1p==1401
replace fod1pAG = 4 if fod1p==1501
replace fod1pAG = 5 if fod1p>1900 & fod1p<2002
replace fod1pAG = 6 if fod1p==2001
replace fod1pAG = 7 if fod1p>2099 & fod1p<2108
replace fod1pAG = 8 if fod1p==2201
replace fod1pAG = 8 if fod1p>5999 & fod1p<6008
replace fod1pAG = 9 if fod1p>2299 & fod1p<2400
replace fod1pAG = 10 if fod1p==2303
replace fod1pAG = 11 if fod1p==2305
replace fod1pAG = 12 if fod1p==2308
replace fod1pAG = 13 if fod1p>2399 & fod1p<2500
replace fod1pAG = 14 if fod1p>2499 & fod1p< 2600
replace fod1pAG = 15 if fod1p>2600 & fod1p<3502
replace fod1pAG = 4 if fod1p==2901
replace fod1pAG = 16 if fod1p>3502 & fod1p<3700
replace fod1pAG = 17 if fod1p>3699 & fod1p<3703
replace fod1pAG = 18 if fod1p==3801
replace fod1pAG = 4 if fod1p==4001
replace fod1pAG = 19 if fod1p==4002
replace fod1pAG = 16 if fod1p==4003
replace fod1pAG = 16 if fod1p==4006
replace fod1pAG = 17 if fod1p==4005
replace fod1pAG = 4 if fod1p==4007
replace fod1pAG = 16 if fod1p==4008
replace fod1pAG = 19 if fod1p==4101
replace fod1pAG = 20 if fod1p==4801
replace fod1pAG = 20 if fod1p==4901
replace fod1pAG = 16 if fod1p>4999 & fod1p<5103
replace fod1pAG = 21 if fod1p>5199 & fod1p<5300
replace fod1pAG = 4 if fod1p>5300 & fod1p<5600
replace fod1pAG = 22 if fod1p==5501
replace fod1pAG = 23 if fod1p==5601
replace fod1pAG = 23 if fod1p==5701
replace fod1pAG = 24 if fod1p==5801
replace fod1pAG = 25 if fod1p==5901
replace fod1pAG = 26 if fod1p>6099 & fod1p<6200
replace fod1pAG = 22 if fod1p>6199 & fod1p<6213
replace fod1pAG = 27 if fod1p==6299
replace fod1pAG = 4 if fod1p>6401 & fod1p<6404


replace fod2pAG = 2 if fod2p>1099 & fod2p<1304
replace fod2pAG = 3 if fod2p==1401
replace fod2pAG = 4 if fod2p==1501
replace fod2pAG = 5 if fod2p>1900 & fod2p<2002
replace fod2pAG = 6 if fod2p==2001
replace fod2pAG = 7 if fod2p>2099 & fod2p<2108
replace fod2pAG = 8 if fod2p==2201
replace fod2pAG = 8 if fod2p>5999 & fod2p<6008
replace fod2pAG = 9 if fod2p>2299 & fod2p<2400
replace fod2pAG = 10 if fod2p==2303
replace fod2pAG = 11 if fod2p==2305
replace fod2pAG = 12 if fod2p==2308
replace fod2pAG = 13 if fod2p>2399 & fod2p<2500
replace fod2pAG = 14 if fod2p>2499 & fod2p< 2600
replace fod2pAG = 15 if fod2p>2600 & fod2p<3502
replace fod2pAG = 4 if fod2p==2901
replace fod2pAG = 16 if fod2p>3502 & fod2p<3700
replace fod2pAG = 17 if fod2p>3699 & fod2p<3703
replace fod2pAG = 18 if fod2p==3801
replace fod2pAG = 4 if fod2p==4001
replace fod2pAG = 19 if fod2p==4002
replace fod2pAG = 16 if fod2p==4003
replace fod2pAG = 16 if fod2p==4006
replace fod2pAG = 17 if fod2p==4005
replace fod2pAG = 4 if fod2p==4007
replace fod2pAG = 16 if fod2p==4008
replace fod2pAG = 19 if fod2p==4101
replace fod2pAG = 20 if fod2p==4801
replace fod2pAG = 20 if fod2p==4901
replace fod2pAG = 16 if fod2p>4999 & fod2p<5103
replace fod2pAG = 21 if fod2p>5199 & fod2p<5300
replace fod2pAG = 4 if fod2p>5300 & fod2p<5600
replace fod2pAG = 22 if fod2p==5501
replace fod2pAG = 23 if fod2p==5601
replace fod2pAG = 23 if fod2p==5701
replace fod2pAG = 24 if fod2p==5801
replace fod2pAG = 25 if fod2p==5901
replace fod2pAG = 26 if fod2p>6099 & fod2p<6200
replace fod2pAG = 22 if fod2p>6199 & fod2p<6213
replace fod2pAG = 27 if fod2p==6299
replace fod2pAG = 4 if fod2p>6401 & fod2p<6404

lab def f2 0 "N/A (less than bachelor's degree)", add
lab def f2 1 "Received Bachelor's Degree in only 1 Major", add
lab def f2 2  "AGRICULTURE/NATURAL RESOURCES SCI AND MGMT", add
lab def f2  3  ".ARCHITECTURE", add
lab def f2  4   ".OTHER SOCIAL SCIENCE", add
lab def f2   5   ".COMMUNICATIONS", add
lab def f2  6  ".COMMUNICATION TECHNOLOGIES", add
lab def f2  7  "COMPUTERS", add
lab def f2  8   "ARTS", add
lab def f2 9  "EDUCATION: GENERAL OR NON-QUANTITATIVE FOCUS", add
lab def f2 10   ".COUNSELING", add
lab def f2 11   ". EDUCATION: MATH", add
lab def f2 12  ". EDUCATION: SCI", add
lab def f2 13   ".ENGINEERING", add
lab def f2 14   ".ENGINEERING RELATED TECH AND MGMT", add
lab def f2 15  ".LIBERAL ARTS", add
lab def f2 16   ".SCIENCE", add
lab def f2 17  ".MATHEMATICS", add
lab def f2  18  ".MILITARY TECHNOLOGIES", add
lab def f2  19   ".HEALTH AND NUTRITION", add
lab def f2  20   ".PHILOSOPHY AND RELIGION", add
lab def f2 21  ".PSYCHOLOGY", add
lab def f2  22   ".BUSINESS, STATS, AND ECONOMICS RELATED", add
lab def f2  23   ".CONSTRUCTION AND REPAIRS", add
lab def f2 24  ".PRECISION PRODUCTION AND INDUSTRIAL ARTS", add
lab def f2 25  ".TRANSPORTATION SCI AND TECH", add
lab def f2  26   ".MEDICAL/HEALTH SERVICES", add
lab def f2  27  ".MISCELLANEOUS BUSINESS & MEDICAL ADMINISTRATION", add

lab values fod1pAG f2
lab values fod2pAG f2


rename fod1pAG aggbachelors_1stfield
rename fod2pAG aggbachelors_2ndfield


/*14) Does this person speak a language other than English at home?
a) Yes
b) No-> SKIP to question 15a
    What is this language? (For example: Korean, Italian, Spanish, Vietnamese)
    How well does this person speak English?
a) Very well...........1
b) Well................2
c) Not well............3
d) Not at all..........4
NOTE: N/A less than 5 yrs old/speaks only English...............missing
 Language other than English spoken at home:
Less than 5 yrs old.....missing
Speaks another language....1
Speaks only English....2*/

/*k. Using dummy variable, engl_home, to create variable engl_ability in order to avoid missing
values for respondants who only speak English at home*/

replace lanx = 1 if lanx==2
replace lanx = 0 if lanx==1
label def lx 1 "Speaks only Engl at home" 0 "Speaks another language at home"
lab values lanx lx
rename lanx engl_home

#delimit ;
replace eng = 0 if engl_home==1;
label define engl 0 "Speaks only Engl at home" 1 "Speaks English Very Well"
 2 "Speaks English well" 3 "Speaks English not well" 4 "Speaks English not at all";
label values eng engl;
rename eng engl_ability;


/*20) What is this person’s marital status?
 a) Now married.........1
 b) Widowed.............2
 c) Divorced............3
 d) Separated ..........4
 e) Never married-> SKIP to I...............5*/
 
#delimit cr
label define marl 1 "Married" 2 "Widowed" 3 "Divorced" 4 "Separated" 5 "Never married or under 15 yrs"
label values mar marl
rename mar marstat

gen mar_d = marstat
replace mar_d = 0 if marstat!=1
lab def m 1 "Married" 0 "Not married"

lab values mar_d m

/*29) Last week, did this person work for pay at a job (or business)?
a) YES--> skip to question 30
b) No--> Did not work (or retired)
     Last week, did this person do ANY work for pay, even for as little as one hour?
a) Yes
b) No--> skip to question 35a

NOTE: Answer questions 35-38 if this person did NOT work last week. Otherwise, SKIP to question 39a.
35) LAST WEEK, was this person on layoff from a job?
a) Yes--> SKIP to question 35c
b) No
    LAST WEEK, was this person TEMPORARILY absent from a job or business?
a) Yes, on vacation, temporary illness, maternity leave, other family/personal reasons, bad weather, etc.-> 
SKIP to question 39
b) No-> SKIP to question 36
    Has this person been informed that he or she will be recalled to work within the next 6 months OR 
    been given a date to return to work?
a) Yes-> SKIP to question 37
b) No

36) During the LAST 4 WEEKS, has this person been ACTIVELY looking for work?
a) Yes..............1
b) No-> SKIP to question 38............2
NOTE: N/A (less than 16 yrs old/at work/temporarily absent/informed of recall)......missing
Did not report........3*/

label define nwlkl 1 "Looking for work" 2 "Not looking for work" 3 "Did not report"
label values nwlk nwlkl
rename nwlk seeking_work

/*38) When did this person last work, even for a few days?
a) Within the past 12 months
b) 1 to 5 years ago--> Skip to L
c) Over 5 years ago or never worked--> SKIP to question 47

39) During the Past 12 Months (52 weeks), did this person work 50 or more weeks? Count paid time off as work.
a) Yes--> SKIP to question 40
b) No
    How many weeks DID this person work, even for a few hours, including paid vacation, paid sick leave,
     and military service?
a) 50 to 52 wks...............1
b) 48 to 49 wks...............2
c) 40 to 47 wks...............3
d) 27 to 39 wks...............4
e) 14 to 26 wks...............5
f) 13 wks or less.............6
//NOTE: N/A (less than 16 yrs old/did not work during the past 12 months)..........missing*/

gen wks_wrked = wkw
replace wks_wrked = 7 if wkw==6
replace wks_wrked = 20 if wkw==5
replace wks_wrked = 33 if wkw==4
replace wks_wrked = 44 if wkw==3
replace wks_wrked = 48 if wkw==2
replace wks_wrked = 51 if wkw==1



/*40) During the PAST 12 MONTHS, in the WEEKS WORKED, how many hours did this person usually work each WEEK?
Fill in usual hours worked each WEEK
N/A (less than 16 yrs old/did not work during the past 12 months).......missing
01 - 98....................................01 - 98 (individually recorded)
99 or more..................................99 (top-coded)*/
rename wkhp hrs_wrked

gen annualhrs = hrs_wrked*wks_wrked


/*L, NOTE: Answer questions 41-46 if this person worked in the past 5 years. Otherwise, SKIP to question 47.
NOTE: 41-46 CURRENT OR MOST RECENT JOB ACTIVITY. Describe clearly this person's chief job activity or business last week.
 If this person had more than one job, describe the one at which
this person worked the most hours. If this person had no job or business last week, give information for his/her
last job or business.

41) Was this person (mark ONE box):
a) an employee of a PRIVATE FOR-PROFIT company or business, or of an individual, for wages, salary, or commissions?.........1
b) an employee of a PRIVATE NOT-FOR-PROFIT, tax-exempt, or charitable organization?..............2
c) a local GOVERNMENT employee (city, county, etc.)?......................3
d) a state GOVERNMENT employee?.....................4
e) a Federal GOVERNMENT employee?..................5
f) SELF-EMPLOYED in own NOT INCORPORATED business, professional practice, or farm?................6
g) SELF-EMPLOYED in own INCORPORATED business, professional practice, or farm..................7
h) working WITHOUT PAY in family business or farm?....................................8
NOTE: N/A (less than 16 years old/NILF who last worked more than 5 yrs ago or never worked............missing
Unemployed and last worked 5 yrs ago or earlier or never worked......................9*/

#delimit ;
label define cowl 1 "Employee of private for-profit/business/individual"
2 "Employee of private not-for-profit/tax-exempt/charitable" 3 "Employee of local government"
4 "Employee of state government" 5 "Employee of Fed government"
6 "Self-employed in own not incorporated business/practice/farm" 
7 "Self-employed in own incorporated business/practice/farm"
8 "Working without pay in family business/farm" 
9 "Unemployed and last worked at least 5 yrs ago or never"; 
label values cow cowl;
rename cow work_type;

/*42) For whom did this person work?
NOTE:If now on active duty in the Armed Forces, mark box and print the branch of the Armed Forces
Fill in name of company, business or other employer*/

label define esrl  1 "Civilian employed, at work" 2 "Civilian employed, with a job but not at work"
 3 "Unemployed" 4 "Armed forces, at work" 5 "Armed forces with a job but not at work" 6 "Not in labor force";
label values esr esrl;
rename esr wrk_stat;

/*45) What kind of work was this person doing? (For example: registered nurse, personnel manager, 
supervisor of order department, secretary, accountant)
Fill in type of work*/

/*l. 2 digit industry data*/
#delimit cr

gen naicsp_2=substr(naicsp, 1,2)

destring naicsp_2, gen(naicsp_2d) ignore("M" "Z" "P" "S")

replace naicsp_2d = . if findp==1


lab def naicsplab2 11 "Agriculture, Forestry, Fishing and Hunting", add
lab def naicsplab2 21 "Mining, Quarrying, and Oil and Gas Extraction", add
lab def naicsplab2 22 "Utilities", add
lab def naicsplab2 23 "Construction", add
lab def naicsplab2 30 "Manufacturing", add
lab def naicsplab2 31 "Manufacturing", add
lab def naicsplab2 32 "Manufacturing", add
lab def naicsplab2 33 "Manufacturing", add
lab def naicsplab2 40 "Retail Trade", add
lab def naicsplab2 42 "Wholesale Trade", add
lab def naicsplab2 44 "Retail Trade", add
lab def naicsplab2 45 "Retail Trade", add
lab def naicsplab2 48 "Transportation and Warehousing", add
lab def naicsplab2 49 "Transportation and Warehousing", add
lab def naicsplab2 51 "Information", add
lab def naicsplab2 52 "Finance and Insurance", add
lab def naicsplab2 53 "Real Estate and Rental and Leasing", add
lab def naicsplab2 54 "Professional, Scientific, and Technical Services", add
lab def naicsplab2 55 "Management of Companies and Enterprises", add
lab def naicsplab2 56 "Administrative and Support and Waste Management and Remediation Services", add
lab def naicsplab2 61 "Educational Services", add
lab def naicsplab2 62 "Health Care and Social Assistance", add
lab def naicsplab2 71 "Arts, Entertainment, and Recreation", add
lab def naicsplab2 72 "Accommodation and Food Services", add
lab def naicsplab2 81 "Other Services (except Public Administration)", add
lab def naicsplab2 92 "Public Administration", add
lab def naicsplab2 99 "Unemployed and last worked 5 years ago or earlier or never worked", add

lab values naicsp_2d naicsplab2

/*m. 3 digit industry data*/

gen naicsp_3=substr(naicsp, 1,3)

destring naicsp_3, gen(naicsp_3d) ignore("M" "Z" "P" "S")
replace naicsp_3d=naicsp_3d*10 if naicsp_3d<100
replace naicsp_3d=naicsp_3d*10 if naicsp_3d<100

replace naicsp_3d = . if findp==1

lab def naicsplab  111 "Crop Production", add
lab def naicsplab         112 "Animal Production", add
lab def naicsplab         113 "Forestry and Logging", add
lab def naicsplab         114 "Fishing, Hunting, and Trapping", add
lab def naicsplab         115 "Support Activities for Agriculture and Forestry", add
lab def naicsplab         211 "Oil and Gas Extraction", add
lab def naicsplab         212 "Mining (except Oil and Gas)", add
lab def naicsplab         213 "Support Activities for Mining", add
 lab def naicsplab        220 "Not specified utilities", add
 lab def naicsplab        221 "Utilities", add
 lab def naicsplab        230 "Construction", add
 lab def naicsplab        300 "Not specified manufacturing", add
 lab def naicsplab        310 "Knitting fabric mills, and apparel knitting mills", add
 lab def naicsplab        311 "Food Manufacturing", add
lab def naicsplab         312 "Beverage and Tobacco Product Manufacturing", add
  lab def naicsplab       313 "Textile Mills", add
lab def naicsplab         314 "Textile Product Mills", add
 lab def naicsplab        315 "Apparel Manufacturing", add
lab def naicsplab         316 "Leather and Allied Product Manufacturing", add
lab def naicsplab         321 "Wood product manufacturing", add
lab def naicsplab         322 "Paper manufacturing", add
lab def naicsplab         323 "Printing and related support activities", add
lab def naicsplab         324 "Petroleum and coal products manufacturing", add
 lab def naicsplab        325 "Chemical manufacturing", add
lab def naicsplab         326 "Plastics and rubber products manufacturing", add
 lab def naicsplab        327 "Nonmetallic mineral product manufacturing", add
 lab def naicsplab        330 "Not specified metal manufacturing", add
lab def naicsplab         331 "Primary metal manufacturing", add
lab def naicsplab         332 "Fabricated metal product manufacturing", add
lab def naicsplab         333 "Machinery manufacturing", add
lab def naicsplab         334 "Computer and electronic product manufacturing", add
 lab def naicsplab        335 "Electrical equipment, appliance, and component manufacturing", add
 lab def naicsplab        336 "Transportation equipment manufacturing", add
 lab def naicsplab        337 "Furniture and related product manufacturing", add
 lab def naicsplab        339 "Miscellaneous manufacturing", add
 lab def naicsplab        400 "Sporting goods, camera, and hobby and toy stores or not specified retail trade", add
lab def naicsplab         420 "Not specified wholesale trade", add
 lab def naicsplab        423 "Merchant wholesalers, durable goods", add
 lab def naicsplab        424 "Merchant wholesalers, nondurable goods", add
 lab def naicsplab        425 "Wholesale electronic markets and agents and brokers", add
 lab def naicsplab        441 "Motor vehicle and parts dealers", add
 lab def naicsplab        442 "Furniture and home furnishings stores", add
 lab def naicsplab        443 "Electronics and appliances stores", add
 lab def naicsplab        444 "Building material and garden equipment and supplies dealers", add
 lab def naicsplab        445 "Food and beverage stores", add
lab def naicsplab         446 "Health and personal care stores", add
  lab def naicsplab       447 "Gasoline stations", add
 lab def naicsplab        448 "Clothing and clothing accessories stores", add
  lab def naicsplab       451 "Sporting goods, hobby, book, and music stores", add
 lab def naicsplab        452 "General merchandise stores", add
 lab def naicsplab        453 "Miscellaneous store retailers", add
 lab def naicsplab        454 "Nonstore retailers", add
 lab def naicsplab        481 "Air transportation", add
 lab def naicsplab        482 "Rail transportation", add
 lab def naicsplab        483 "Water transportation", add
 lab def naicsplab        484 "Truck transportation", add
lab def naicsplab         485 "Transit and ground passenger transportation", add
 lab def naicsplab        486 "Pipeline transportation", add
 lab def naicsplab        487 "Scenic and sightseeing transportation", add
 lab def naicsplab        488 "Support activities for transportation", add
 lab def naicsplab        491 "Postal Service", add
 lab def naicsplab        492 "Couriers and Messengers", add
 lab def naicsplab        493 "Warehousing and Storage", add
 lab def naicsplab        511 "Publishing Industries", add
 lab def naicsplab        512 "Motion picture and sound recording industries", add
 lab def naicsplab        515 "Broadcasting (except internet)", add
 lab def naicsplab        517 "Telecommunications", add
 lab def naicsplab        518 "Data processing, hosting, and related services", add
 lab def naicsplab        519 "Other information services", add
 lab def naicsplab        520 "Banking and related activities or securities, commodities, funds, trusts, and other financial investments", add
 lab def naicsplab        522 "Credit intermediation and related activitis", add
 lab def naicsplab        524 "Insurance carriers and related activities", add
 lab def naicsplab        530 "Commercial, industrial, and other intangible assets rental and leasing", add
 lab def naicsplab        531 "Real estate", add
 lab def naicsplab        532 "Rental and leasing services", add
 lab def naicsplab        541 "Professional, scientific, and technical services", add
 lab def naicsplab        550 "Management of companies and enterprises", add
 lab def naicsplab        561 "Administrative and support services", add
 lab def naicsplab        562 "Waste management and remediation services", add
 lab def naicsplab        611 "Educational services", add
 lab def naicsplab        621 "Ambulatory health care services", add
 lab def naicsplab        622 "Hospitals", add
 lab def naicsplab        623 "Nursing and residential care facilities", add
  lab def naicsplab       624 "Social assistance", add
 lab def naicsplab        711 "Performing arts, spectator sports, and related industries", add
 lab def naicsplab        712 "Museums, historical sites, and similar institutions", add
 lab def naicsplab        713 "Amusement, gambling, and recreation industries", add
 lab def naicsplab        721 "Accommodation", add
 lab def naicsplab        722 "Food services and drinking places", add
 lab def naicsplab        811 "Repair and maintenance", add
 lab def naicsplab        812 "Personal and laundry services", add
 lab def naicsplab        813 "Religious, grantmaking, civic, professional, and similar organizations", add
 lab def naicsplab        814 "Private households", add
 lab def naicsplab        920 "Administration of public service and government research", add
 lab def naicsplab        921 "Executive, legislative, and other general government support", add
 lab def naicsplab        923 "Administration of human resource programs", add
 lab def naicsplab        928 "National security and international affairs", add
 lab def naicsplab        992 "Unemployed and last worked 5 years ago or earlier or never worked", add
 
lab values naicsp_3d naicsplab

/*n. 4 digit industry data*/
gen naicsp2T=substr(naicsp, 1,2)
gen naicsp3T=substr(naicsp, 1,3)
gen naicsp_4=substr(naicsp, 1,4)

destring naicsp2T, gen(naicsp2Td) ignore("M" "Z" "P" "S")
destring naicsp3T, gen(naicsp3Td) ignore("M" "Z" "P" "S")
destring naicsp_4, gen(naicsp_4d) ignore("M" "Z" "P" "S")

list if naicsp2Td<10 & naicsp3Td>10 & naicsp3Td<100
/*0 changes*/
list if naicsp_4d>10 & naicsp_4d<100 & naicsp3Td<10 & naicsp2Td<10
/*0 changes*/
list naicsp_4d if naicsp2Td>10 & naicsp3Td>10 & naicsp3Td<100 & naicsp_4d>100 
/*921, 522, 521, 922*/


replace naicsp_4d = 5201 if naicsp_4d==521
replace naicsp_4d = 5202 if naicsp_4d==522 & naicsp3Td<100
replace naicsp_4d = 9201 if naicsp_4d==921 & naicsp3Td<100
replace naicsp_4d = 9202 if naicsp_4d==922 & naicsp3Td<100

drop naicsp2T
drop naicsp3T
drop naicsp2Td
drop naicsp3Td

replace naicsp_4d=naicsp_4d*10 if naicsp_4d<1000
replace naicsp_4d=naicsp_4d*10 if naicsp_4d<1000
replace naicsp_4d=naicsp_4d*10 if naicsp_4d<1000


destring naicsp, gen(naicsp4) ignore("M" "Z" "P" "S")
replace naicsp_4d = naicsp4 if naicsp_4d==3110 & naicsp4==3111
replace naicsp_4d = naicsp4 if naicsp_4d==3110 & naicsp4==3112

replace naicsp_4d = naicsp4 if naicsp_4d==6110 & naicsp4==6112
replace naicsp_4d = naicsp4 if naicsp_4d==6110 & naicsp4==6113

replace naicsp_4d = . if findp==1

lab def naicsplab4       1110 "Crop Production", add
lab def naicsplab4        1120 "Animal Production", add
lab def naicsplab4        1130 "Forestry Except Logging", add
 lab def naicsplab4       1133 "Logging", add
 lab def naicsplab4       1140 "Fishing, Hunting, and Trapping", add
lab def naicsplab4        1150 "Support Activities for Agriculture and Forestry", add
lab def naicsplab4        2110 "Oil and Gas Extraction", add
lab def naicsplab4        2121 "Coal Mining", add
lab def naicsplab4        2122 "Metal Ore Mining",add
lab def naicsplab4        2123 "Nonmetallic Mineral Mining and Quarrying", add
 lab def naicsplab4       2130 "Support Activities for Mining", add
 lab def naicsplab4       2200 "Not Specified Utilities", add
lab def naicsplab4        2210 "Electric and Gas, and Other Combinations", add
 lab def naicsplab4       2211 "Electric Power Generation, Transmission and Distribution", add
lab def naicsplab4        2212 "Natural Gas Distribution", add
 lab def naicsplab4       2213 "Water, Sewage, and Other Systems", add
 lab def naicsplab4       2300 "Construction", add
 lab def naicsplab4       3000 "Manufacturing, Not Specified Industries" , add
 lab def naicsplab4       3100 "Knitting Fabric Mills, and Apparel Knitting Mills", add
 
 lab def naicsplab4       3110 "Not Specified Food Industries", add
lab def naicsplab4        3111 "Animal Food, Grain and Oilseed Milling", add
lab def naicsplab4        3112 "Seafood and Other Misc Foods, N.E.C.", add
lab def naicsplab4        3113 "Sugar and Confectionery Product Manufacturing", add
lab def naicsplab4        3114 "Fruit and Vegetable Preserving and Specialty Food Manufacturing", add
lab def naicsplab4        3115 "Dairy Product Manufacturing", add
lab def naicsplab4        3116 "Animal Slaughtering and Processing", add
lab def naicsplab4        3118 "Bakeries and Tortilla Manufacturing", add
lab def naicsplab4        3119 "Other Food Manufacturing", add
lab def naicsplab4        3121 "Beverage Manufacturing", add
lab def naicsplab4        3122 "Tobacco Manufacturing", add
 lab def naicsplab4       3131 "Fiber, Yarn, and Thread Mills", add
 lab def naicsplab4       3132 "Fabric Mills", add
 lab def naicsplab4       3133 "Textile and Fabric Finishing and Fabric Coating Mills", add
 lab def naicsplab4       3140 "Textile Product Mills, Except Carpet and Rug", add
  lab def naicsplab4      3141 "Carpet and Rug Mills", add
 lab def naicsplab4       3149 "Other Textile Product Mills", add
  lab def naicsplab4      3151 "Apparel Knitting Mills", add
 lab def naicsplab4       3152 "Cut and Sew Apparel Manufacturing", add
 lab def naicsplab4       3159 "Apparel Accessories and Other Apparel Manufacturing", add
 lab def naicsplab4       3160 "Leather Tanning and Finishing and Allied Product Manufacturing", add
  lab def naicsplab4      3162 "Footwear Manufacturing", add
 lab def naicsplab4       3169 "Other Leather and Allied Product Manufacturing", add
 lab def naicsplab4       3211 "Sawmills and Wood Preservation", add
lab def naicsplab4        3212 "Veneer, Plywood, and Engineered Wood Product Manufacturing", add
lab def naicsplab4        3219 "Other Wood Product Manufacturing", add
 lab def naicsplab4       3221 "Pulp, Paper, and Paperboard Mills", add
 lab def naicsplab4       3222 "Converted Paper Product Manufacturing", add
 lab def naicsplab4       3231 "Printing and Related Support Activities", add
 lab def naicsplab4       3241 "Petroleum and Coal Products Manufacturing", add
lab def naicsplab4        3250 "Industrial and Misc Chemical Manufacturing", add
lab def naicsplab4        3251 "Basic Chemical Manufacturing", add
 lab def naicsplab4       3252 "Resin, Synthetic Rubber, and Artificial Synthetic Fibers and Filaments Manufacturing", add
 lab def naicsplab4       3253 "Pesticide, Fertilizer, and Other Agricultural Chemical Manufacturing", add
 lab def naicsplab4       3254 "Pharmaceutical and Medicine Manufacturing", add
 lab def naicsplab4       3255 "Paint, Coating, and Adhesive Manufacturing", add
 lab def naicsplab4       3256 "Soap, Cleaning Compound, and Toilet Preparation Manufacturing", add
 lab def naicsplab4       3259 "Other Chemical Product and Preparation Manufacturing", add
 lab def naicsplab4       3261 "Plastics Product Manufacturing", add
 lab def naicsplab4       3262 "Rubber Product Manufacturing", add
 lab def naicsplab4       3270 "Cement, Concrete, Lime, and Gypsum Products", add
 lab def naicsplab4       3271 "Clay Product and Refractory Manufacturing", add
 lab def naicsplab4       3272 "Glass and Glass Product Manufacturing", add
 lab def naicsplab4       3279 "Other Nonmetallic Mineral Product Manufacturing", add
 lab def naicsplab4       3300 "Not Specified Metal Industries", add
 lab def naicsplab4       3310 "Iron and Steel Mills and Steel Products", add
  lab def naicsplab4      3311 "Iron and Steel Mills and Ferroalloy Manufacturing", add
  lab def naicsplab4      3312 "Steel Product Manufacturing from Purchased Steel", add
 lab def naicsplab4       3313 "Alumina and Aluminum Production and Processing", add
 lab def naicsplab4       3314 "Nonferrous Metal (except Aluminum) Production and Processing", add
lab def naicsplab4        3315 "Foundries", add
lab def naicsplab4        3320 "Structural Metals, and Boiler, Tank, and Shipping Containers and Misc Fabricated Metal Products", add
 lab def naicsplab4       3321 "Forging and Stamping", add
 lab def naicsplab4       3322 "Cutlery and Handtool Manufacturing", add
 lab def naicsplab4       3323 "Architectural and Structural Metals Manufacturing", add
 lab def naicsplab4       3324 "Boiler, Tank, and Shipping Container Manufacturing", add
 lab def naicsplab4       3325 "Hardware Manufacturing", add
 lab def naicsplab4       3326 "Spring and Wire Product Manufacturing", add
 lab def naicsplab4       3327 "Machine Shops; Turned Product; and Screw, Nut, and Bolt Manufacturing", add
 lab def naicsplab4       3328 "Coating, Engraving, Heat Treating, and Allied Activities", add
 lab def naicsplab4       3329 "Other Fabricated Metal Product Manufacturing", add
 lab def naicsplab4       3330 "Machinery Manufacturing, N.E.C., or Not Specified Machinery", add
 lab def naicsplab4       3331 "Agriculture, Construction, and Mining Machinery Manufacturing", add
 lab def naicsplab4       3332 "Industrial Machinery Manufacturing", add
 lab def naicsplab4       3333 "Commercial and Service Industry Machinery Manufacturing", add
 lab def naicsplab4       3334 "Ventilation, Heating, Air-Conditioning, and Commercial Refrigeration Equipment Manufacturing", add
 lab def naicsplab4       3335 "Metalworking Machinery Manufacturing", add
lab def naicsplab4        3336 "Engine, Turbine, and Power Transmission Equipment Manufacturing", add
lab def naicsplab4        3339  "Other General Purpose Machinery Manufacturing", add
lab def naicsplab4        3340 "Communications, and Audio and Video Equipment, and Electronic Components and Products, N.E.C.", add
lab def naicsplab4        3341 "Computer and Peripheral Equipment Manufacturing", add
 lab def naicsplab4       3342 "Communications Equipment Manufacturing", add
 lab def naicsplab4       3343 "Audio and Video Equipment Manufacturing", add
lab def naicsplab4        3344 "Semiconductor and Other Electronic Component Manufacturing", add
lab def naicsplab4        3345 "Navigational, Measuring, Electromedical, and Control Instruments Manufacturing", add
lab def naicsplab4        3346 "Manufacturing and Reproducing Magnetic and Optical Media", add
lab def naicsplab4        3350 "Electric Lighting, and Electrical Equipment Manufacturing, and Other Electrical Component Manufacturing, N.E.C.", add
lab def naicsplab4        3351 "Electric Lighting Equipment Manufacturing", add
lab def naicsplab4        3352 "Household Appliance Manufacturing", add
lab def naicsplab4        3353 "Electrical Equipment Manufacturing", add
lab def naicsplab4        3359 "Other Electrical Equipment and Component Manufacturing", add
lab def naicsplab4        3360 "Motor Vehicles and Motor Vehicle Equipment", add
 lab def naicsplab4       3364 "Aerospace Product and Parts Manufacturing", add
 lab def naicsplab4       3365 "Railroad Rolling Stock Manufacturing", add
 lab def naicsplab4       3366 "Ship and Boat Building", add
 lab def naicsplab4       3369 "Other Transportation Equipment Manufacturing", add
 lab def naicsplab4       3370 "Furniture and Related Product Manufacturing", add
 lab def naicsplab4       3372 "Office Furniture (including Fixtures) Manufacturing", add
 lab def naicsplab4       3379 "Other Furniture Related Product Manufacturing", add
 lab def naicsplab4       3391 "Medical Equipment and Supplied Manufacturing", add
  lab def naicsplab4      3399 "Other Miscellaneous Manufacturing", add
 lab def naicsplab4       4000 "Sporting Goods, Camera, and Hobby and Toy Stores and Not Specified Retail Trade", add
lab def naicsplab4        4200 "Not Specified Wholesale Trade", add
 lab def naicsplab4       4231 "Motor Vehicle and Motor Vehicle Parts and Supplies Merchant Wholesalers", add
 lab def naicsplab4       4232 "Furniture and Home Furnishing Merchant Wholesalers", add
 lab def naicsplab4       4233 "Lumber and Other Construction Materials Merchant Wholesalers", add
 lab def naicsplab4       4234 "Professional and Commercial Equipment and Supplies Merchant Wholesalers", add
 lab def naicsplab4       4235 "Metal and Mineral (except Petroleum) Merchant Wholesalers", add
 lab def naicsplab4       4236 "Electrical and Electronic Goods Merchant Wholesalers", add
  lab def naicsplab4      4237 "Hardware, and Plumbing and Heating Equipment and Supplies Merchant Wholesalers", add
 lab def naicsplab4       4238 "Machinery, Equipment, and Supplies Merchant Wholesalers", add
 lab def naicsplab4       4239 "Miscellaneous Durable Goods Merchant Wholesalers", add
 lab def naicsplab4       4240 "Durgs, Sundries, and Chemical and Allied Products Merchant Wholesalers", add
 lab def naicsplab4       4241 "Paper and Paper Product Merchant Wholesalers", add
 lab def naicsplab4       4243 "Apparel, Piece Goods, and Notions Merchant Wholesalers", add
lab def naicsplab4        4244 "Grocery and Related Poduct Merchant Wholesalers", add
lab def naicsplab4        4245 "Farm Product Raw Material Merchant Wholesalers", add
lab def naicsplab4        4246 "Chemical and Allied Products Merchant Wholesalers", add
lab def naicsplab4        4247 "Petroleum and Petroleum Products Merchant Wholesalers", add
lab def naicsplab4        4248 "Beer, Wine, and Distilled Alcoholic Beverage Merchant Wholesalers", add
 lab def naicsplab4       4249 "Miscellaneous Nondurable Goods Merchant Wholesalers", add
 lab def naicsplab4       4251 "Wholesale Electronic Markets and Agents and Brokers", add
 lab def naicsplab4       4411 "Automobile Dealers", add
 lab def naicsplab4       4412 "Other Motor Vehicle Dealers", add
 lab def naicsplab4       4413 "Automotive Parts, Accessories, and Tire Stores", add
lab def naicsplab4        4420 "Furniture and Home Furnishings stores", add
 lab def naicsplab4       4431 "Electronics and Appliance Stores", add
lab def naicsplab4        4441 "Building Material and Supplies Dealers", add
 lab def naicsplab4       4442 "Lawn and Garden Equipment and Supplies Stores", add
 lab def naicsplab4       4451 "Grocery Stores", add
 lab def naicsplab4       4452 "Specialty Food Stores", add
 lab def naicsplab4       4453 "Beer, Wine, and Liquor Stores", add
 lab def naicsplab4       4460 "Health and Personal Care Stores, Except Drug, Stores", add
 lab def naicsplab4       4461 "Pharmacies and Drug Stores", add
 lab def naicsplab4       4470 "Gasoline Stations", add
 lab def naicsplab4       4481 "Clothing Stores", add
 lab def naicsplab4       4482 "Shoe Stores", add
 lab def naicsplab4       4483 "Jewelry, Luggage, and Leather Goods Stores", add
lab def naicsplab4        4510 "Music Stores", add
 lab def naicsplab4       4511 "Sewing, Needlework, and Piece Goods Stores", add
 lab def naicsplab4       4512 "Book Stores and News Dealers", add
 lab def naicsplab4       4521 "Department Stores", add
 lab def naicsplab4       4529 "Other General Merchandise Stores", add
 lab def naicsplab4       4531 "Florists", add
 lab def naicsplab4       4532 "Office Supplies, Stationery, and Gift Stores", add
 lab def naicsplab4       4533 "Used Merchandise Stores", add
 lab def naicsplab4       4539 "Other Miscellaneous Store Retailers", add
 lab def naicsplab4       4541 "Electronic Shopping and Mail-Order Houses", add
 lab def naicsplab4       4542 "Vending Machine Operators", add
 lab def naicsplab4       4543 "Direct Selling Establishments", add
 lab def naicsplab4       4810 "Air Transportation", add
 lab def naicsplab4       4820 "Rail Transportation", add
 lab def naicsplab4       4830 "Water Transportation", add
 lab def naicsplab4       4840 "Truck Transportation", add
 lab def naicsplab4       4850 "Bus Service and Urban Transit", add
 lab def naicsplab4       4853 "Taxi and Limousine Service", add
 lab def naicsplab4       4860 "Pipeline Transporation", add
 lab def naicsplab4       4870 "Scenic and Sightseeing Transportation", add
 lab def naicsplab4       4880 "Support Activites for Transportation", add
 lab def naicsplab4       4910 "Postal Service", add
 lab def naicsplab4       4920 "Couriers and Messengers", add
 lab def naicsplab4       4930 "Warehousing and Storage", add
lab def naicsplab4        5111 "Newspaper, Periodical, Book, and Directory Publishers", add
 lab def naicsplab4       5112 "Software Publishers", add
lab def naicsplab4        5121 "Motion Picture and Video Industries", add
 lab def naicsplab4       5122 "Sound Recording Industries", add
 lab def naicsplab4       5150 "Broadcasting (except Internet)", add
 lab def naicsplab4       5170 "Telecommunications, Except Wired Telecommunications Carriers", add
 lab def naicsplab4       5171 "Wired Tellecomunications Carriers", add
 lab def naicsplab4       5172 "Wireless Telecommunications Carriers (except Satellite", add
 lab def naicsplab4       5174 "Satellite Telecommunications", add
 lab def naicsplab4       5179 "Other Telecommunications", add
 lab def naicsplab4       5182 "Data Processing, Hosting, and Related Services", add
 lab def naicsplab4       5191 "Other Information Services", add
 lab def naicsplab4       5201 "Banking and Related Activities", add
 lab def naicsplab4       5202 "Securities, Commodities, Funds, Trusts, and Other Financial Investments", add
 lab def naicsplab4       5220 "Non-Depository Credit and Related Activities", add
 lab def naicsplab4       5221 "Depository Credit Intermediation", add
 lab def naicsplab4       5240 "Insurance Carriers and Related Activities", add
 lab def naicsplab4       5300 "Commercial, Industrial, and Other Intangible Assets Rental and Leasing", add
 lab def naicsplab4       5310 "Real Estate", add
 lab def naicsplab4       5320 "Other Consumer Goods Rental", add
 lab def naicsplab4       5321 "Automotive Equipment Rental and Leasing", add
 lab def naicsplab4       5322 "Consumer Goods Rental", add
 lab def naicsplab4       5411 "Legal Services", add
 lab def naicsplab4       5412 "Acccounting, Tax Preparation, Bookkeeping, and Payroll Services", add
 lab def naicsplab4       5413 "Architectural, Engineering, and Related Services", add
 lab def naicsplab4       5414 "Specialized Design Services", add
 lab def naicsplab4       5415 "Computer Systems Design and Related Services", add
  lab def naicsplab4      5416 "Management, Scientific, and Technical Consulting Services", add
  lab def naicsplab4      5417 "Scientific Research and Development Services", add
 lab def naicsplab4       5418 "Advertising, Public Relations, and Related Services", add
 lab def naicsplab4       5419 "Other Professional, Scientific, and Technical Services", add
 lab def naicsplab4       5500 "Management of Companies and Enterprises", add
lab def naicsplab4        5610 "Other administrative and Support services", add
lab def naicsplab4        5613 "Employment Services", add
lab def naicsplab4        5614 "Business Support Services", add
lab def naicsplab4        5615 "Travel Arrangement and Reservation Services", add
lab def naicsplab4        5616 "Investigation and Security Services", add
lab def naicsplab4        5617 "Services to Buildings and Dwellings", add
 lab def naicsplab4       5619 "Other Support Services", add
 lab def naicsplab4       5620 "Waste Management and Remediation Services", add
       /*When adding extra data, make sure 6110-6116 are compatible*/
lab def naicsplab4        6110 "Colleges and Universities, Including Junior Colleges", add
lab def naicsplab4        6111 "Elementary and Secondary Schools", add
 lab def naicsplab4       6112 "Business, Technical and Trade Schools and Training", add
 lab def naicsplab4       6113 "Other Schools and Instruction, and Educational Support Services", add
 lab def naicsplab4       6210 "Other Health Care Services", add
 lab def naicsplab4       6211 "Office of Physicians", add
 lab def naicsplab4       6212 "Office of Dentists", add
 lab def naicsplab4       6213 "Offices of Other Health Practioners", add
 lab def naicsplab4       6214 "Outpatient Care Centers", add
 lab def naicsplab4       6215 "Medical and Diagnostic Laboratories", add
 lab def naicsplab4       6216 "Home Helath Care Services", add
 lab def naicsplab4       6219 "Other Ambulatory Health Care Services", add
  lab def naicsplab4      6220 "Hospitals", add
 lab def naicsplab4       6230 "Nursing and Residential Care Facilities, Without Nursing", add
 lab def naicsplab4       6231 "Nursing Care Facilities", add
 lab def naicsplab4       6232 "Residential Mental Retardation, Mental Health and Substance Abuse Facilities", add
 lab def naicsplab4       6233 "Community Care Facilities for the Elderly", add
 lab def naicsplab4       6239 "Other Residential Care Facilities", add
 lab def naicsplab4       6241 "Individual and Family Services", add
 lab def naicsplab4       6242 "Community Food and Housing,and Emergency and Other Relief Services", add
 lab def naicsplab4       6243 "Vocational Rehabilitation Services", add
 lab def naicsplab4       6244 "Child Day Care Services", add
 lab def naicsplab4       7110 "Independent Artists, Performing Arts, Spectator Sports, and Related Industries", add
 lab def naicsplab4       7120 "Museums, Art Galleries, Historical Sites, and Similar Institutions", add
 lab def naicsplab4       7130 "Other Amusement, Gambling, and Recreation Industries", add
lab def naicsplab4        7139 "Bowling Centers", add
 lab def naicsplab4       7210 "Recreational Vehicle Parks and Camps, and Rooming and Boarding Houses", add
 lab def naicsplab4       7211 "Traveler Accommodation", add
 lab def naicsplab4       7220 "Restaurants and Other Food Services", add
 lab def naicsplab4       7224 "Drinking Places (Alocholic Beverages)", add
 lab def naicsplab4       8111 "Automotive Repair and Maintenance", add
 lab def naicsplab4       8112 "Electronic and Precision Equipment Repair and Maintenance", add
 lab def naicsplab4       8113 "Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance", add
 lab def naicsplab4       8114 "Personal and Household Goods Repair and Maintenance", add
 lab def naicsplab4       8121 "Personal Care Services", add
 lab def naicsplab4       8122 "Death Care Services", add
 lab def naicsplab4       8123 "Drycleaning and Laundry Services", add
 lab def naicsplab4       8129 "Other Personal Services", add
 lab def naicsplab4       8130 "Civic, Social, Advocacy Organizations, and Grantmaking and Giving Services", add
 lab def naicsplab4       8131 "Religious Organizations", add
 lab def naicsplab4       8139 "Business, Professional, Labor, Political, and Similar Organizations", add
  lab def naicsplab4      8140 "Private Households", add
 lab def naicsplab4       9200 "Justice, Public Order, and Safety Activities", add
 lab def naicsplab4       9201 "Administration of Environmental Quality and Housing Programs", add
 lab def naicsplab4       9202 "Administration of Economic Programs and Space Research", add
 lab def naicsplab4       9211 "Executive, Legislative, and Other General Government Support", add
 lab def naicsplab4       9230 "Administration of Human Resource Programs", add
 lab def naicsplab4       9280 "National Security and International Affairs", add
 lab def naicsplab4       9281 "Military or Military Related Forces", add
 lab def naicsplab4       9920 "Unemployed and Last Worked 5 Years Ago or Earlier or Never Worked", add
 
lab values  naicsp_4d naicsplab4




/*46) What were this person's most important activities or duties? (For example: patient care, 
directing hiring policies, supervising order clerks, typing and filing, reconciling financial records)
Fill in important activities/duties*/

gen socp_4=substr(socp, 1,4)
gen socp_3=substr(socp, 1,3)
gen socp_5=substr(socp, 1,5)
gen socp_2=substr(socp, 1,2)

destring socp_2, gen(socp_2d)
destring socp_3, gen(socp_3d) ignore ("X" "Y")
destring socp_4, gen(socp_4d) ignore("X" "Y")
destring socp_5, gen(socp_5d) ignore("X" "Y")

/*Want to get check for instances when datum= 12X4, for example, so list if socp_3d!=socp_4d & socp_4d<1000 & socp_4d>=100
Want to check for instances when datum= 12XX4 or 124X4, for example, so list if  socp_4d!=socp_5d & socp_4d=socp_3d
0 listed in either case*/


replace socp_2d = . if foccp==1

/*o. 2 digit occupation data*/

lab def s2        11 "Management Occupations", add
lab def s2          13 "Business and Financial Operations Occupations", add
lab def s2          15 "Computer and Mathematical Occupations", add
 lab def s2         17 "Architecture and Engineering Occupations", add
 lab def s2         19 "Life, Physical, and Social Science Occupations", add
lab def s2          21 "Community and Social Services Occupations", add
lab def s2          23 "Legal Occupations", add
lab def s2          25 "Education, Training, and Library Occupations", add
lab def s2          27 "Arts, Design, Entertainment, Sports, and Media Occupations", add
lab def s2          29 "Healthcare Practitioners and Technical Occupations", add
 lab def s2         31 "Healthcare Support Occupations", add
 lab def s2         33 " Protective Service Occupations", add
 lab def s2         35 " Food Preparation and Serving Related Occupations", add
 lab def s2         37 "Building and Grounds Cleaning and Maintenance Occupations", add
 lab def s2         39 " Personal Care and Service Occupations", add
 lab def s2         41 "Sales and Related Occupations", add
lab def s2          43 "Office and Administrative Support Occupations", add
lab def s2          45 "Farming, Fishing, and Forestry Occupations", add
lab def s2          47 "Construction and Extraction Occupations", add
 lab def s2         49 "Installation, Maintenance, and Repair Occupations", add
 lab def s2         51 "Production Occupations", add
 lab def s2         53 "Transportation and Material Moving Occupations", add
 lab def s2         55 "Military Specific Occupations", add
 lab def s2         99 "Unemployed and Last Worked 5 Years Ago or Earlier or Never Worked" , add
 
 lab values socp_2d s2


/*p. 3 digit occupation data*/

replace socp_3d = . if foccp==1

lab def s3        111 "Top Executives", add
lab def s3          112 "Advertising, Marketing, Promotions, Public Relations, and Sales Managers", add
lab def s3          113 "Operations Specialties Managers", add
lab def s3          119 " Other Management Occupations", add
lab def s3          131 "Business Operations Specialists", add
lab def s3          132 "Financial Specialists", add
lab def s3          151 "Computer Specialists", add
lab def s3          152 " Mathematical Science Occupations", add
lab def s3          171 " Architects, Surveyors, and Cartographers", add
lab def s3          172 "Engineers", add
lab def s3          173 "Drafters, Engineering, and Mapping Technicians", add
lab def s3          191 "Life Scientists", add
lab def s3          192 "Physical Scientists", add
lab def s3          193 "Social Scientists and Related Workers", add
lab def s3          194 "Life, Physical, and Social Science Technicians", add
lab def s3          211 " Counselors, Social Workers, and Other Community and Social Service Specialists", add
lab def s3          212 "Religious Workers", add
lab def s3          231 "Lawyers, Judges, and Related Workers", add
lab def s3          232 "Legal Support Workers", add
lab def s3          251 "Postsecondary Teachers", add
lab def s3          252 "Primary, Secondary, and Special Education School Teachers", add
lab def s3          253 "Other Teachers and Instructors", add
lab def s3          254 "Librarians, Curators, and Archivists", add
lab def s3          259 "Other Education, Training, and Library Occupations", add
lab def s3          271 "Art and Design Workers", add
lab def s3          272 "Entertainers and Performers, Sports and Related Workers", add
lab def s3          273 "Media and Communication Workers", add
lab def s3          274 "Media and Communication Equipment Workers", add
 lab def s3         291 "Health Diagnosing and Treating Practitioners", add
 lab def s3         292 " Health Technologists and Technicians", add
lab def s3          299 "Other Healthcare Practitioners and Technical Occupations", add
lab def s3          311 "Nursing, Psychiatric, and Home Health Aides", add
lab def s3          312 "Occupational and Physical Therapist Assistants and Aides", add
lab def s3          319 "Other Healthcare Support Occupations", add
lab def s3          331 "First-Line Supervisors/Managers, Protective Service Workers", add
lab def s3          332 " Fire Fighting and Prevention Workers", add
lab def s3          333 "Law Enforcement Workers", add
lab def s3          339 "Other Protective Service Workers", add
lab def s3          351 "Supervisors, Food Preparation and Serving Workers", add
lab def s3          352 "Cooks and Food Preparation Workers", add
lab def s3          353 "Food and Beverage Serving Workers", add
lab def s3          359 "Other Food Preparation and Serving Related Workers", add
lab def s3          371 "Supervisors, Building and Grounds Cleaning and Maintenance Workers", add
lab def s3          372 "Building Cleaning and Pest Control Workers", add
 lab def s3         373 " Grounds Maintenance Workers", add
 lab def s3         391 "Supervisors, Personal Care and Service Workers", add
 lab def s3         392 "Animal Care and Service Workers", add
 lab def s3         393 "Entertainment Attendants and Related Workers", add
lab def s3          394 "Funeral Service Workers", add
lab def s3          395 "Personal Appearance Workers", add
lab def s3          396 "Transportation, Tourism, and Lodging Attendants", add
lab def s3          399 "Other Personal Care and Service Workers", add
lab def s3          411 "Supervisors, Sales Workers", add
lab def s3          412 "Retail Sales Workers", add
lab def s3          413 "Sales Representatives, Services", add
lab def s3          414 "Sales Representatives, Wholesale and Manufacturing", add
lab def s3          419 "Other Sales and Related Workers", add
lab def s3          431 "Supervisors, Office and Administrative Support Workers", add
lab def s3          432 "Communications Equipment Operators", add
lab def s3          433 "Financial Clerks", add
 lab def s3         434 "Information and Record Clerks", add
 lab def s3         435 "Material Recording, Scheduling, Dispatching, and Distributing Workers", add
 lab def s3         436 "Secretaries and Administrative Assistants", add
 lab def s3         439 " Other Office and Administrative Support Workers", add
 lab def s3         451 " Supervisors, Farming, Fishing, and Forestry Workers", add
lab def s3          452 "Agricultural Workers", add
lab def s3          453 "Fishing and Hunting Workers", add
lab def s3          454 "Forest, Conservation, and Logging Workers", add
lab def s3          471 "Supervisors, Construction and Extraction Workers", add
lab def s3          472 " Construction Trades Workers", add
lab def s3          473 "Helpers, Construction Trades", add
lab def s3          474 "Other Construction and Related Workers", add
lab def s3          475 "Extraction Workers", add
lab def s3          491 " Supervisors of Installation, Maintenance, and Repair Workers", add
lab def s3          492 " Electrical and Electronic Equipment Mechanics, Installers, and Repairers", add
lab def s3          493 "Vehicle and Mobile Equipment Mechanics, Installers, and Repairers", add
lab def s3          499 "Other Installation, Maintenance, and Repair Occupations", add
lab def s3          511 "Supervisors, Production Workers", add
 lab def s3         512 "Assemblers and Fabricators", add
 lab def s3         513 "Food Processing Workers", add
 lab def s3         514 "Metal Workers and Plastic Workers", add
lab def s3          515 "Printing Workers", add
lab def s3          516 "Textile, Apparel, and Furnishings Workers", add
lab def s3          517 "Woodworkers", add
lab def s3          518 "Plant and System Operators", add
lab def s3          519 "Other Production Occupations", add
 lab def s3         531 "Supervisors, Transportation and Material Moving Workers", add
lab def s3          532 "Air Transportation Workers", add
lab def s3          533 "Motor Vehicle Operators", add
lab def s3          534 "Rail Transportation Workers", add
lab def s3          535 "Water Transportation Workers", add
lab def s3          536 "Other Transportation Workers", add
 lab def s3         537 "Material Moving Workers", add
lab def s3          551 " Military Officer Special and Tactical Operations Leaders/Managers", add
lab def s3          552 "First-Line Enlisted Military Supervisor/Managers", add
lab def s3          553 "Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members", add
 lab def s3         559 "Military, Rank Not Specified", add
 lab def s3         999 "Unemployed and Last Worked 5 Years Ago or Earlier or Never Worked", add

lab values socp_3d s3

/*q. 5 digit occupation data*/

replace socp_5d = . if foccp==1

lab def s   131 "Other Business Operations Specialists", add
lab def s          434 "Correspondance Clerks and Order Clerks", add
lab def s          439 "Miscellaneous Office and Administrative Support Workers, Including Desktop Publishers", add
lab def s          514 "Miscellaneous Metal Workers and Plastic Workers, Including Milling and Planing Machine Setters, and Multiple Machine Tool Setters, and Lay-Out Workers", add
lab def s         1110 "Chief Executives and Legislators", add
lab def s         1191 "Miscellaneous Managers, Including Postmasters and Mail", add
lab def s         1510 "Computer Scientists and Systems Analysts", add
lab def s         1520 "Miscellaneous Mathematical Science Occupations, Including Mathematicians and Statisticians", add
lab def s        1720 "Biomedical and Agricultural Engineers", add
lab def s         1721 "Petroleum, Mining and Geological Engineers, Including Mining Safety Engineers or Miscellaneous Engineers, Including Nuclear Engineers", add
lab def s         1930 "Miscellaneous Social Scientists, Including Sociologists", add
lab def s         1940 "Miscellaneous Life, Physical, and Social Science Technicians, Including Social Science Research Assistants and Nuclear Technicians", add
 lab def s        2310 "Lawyers, and Judges, Magistrates, and Other Judicial Workers", add
 lab def s        2590 "Other Education, Training, and Library Workers", add
 lab def s        2740 "Broadcast and Sound Engineering Tehnicians and Radio Operators, and Media and Communication Equipment Workers, All Other", add
 lab def s        3330 "Miscellaneous Law Enforcement Workers", add
 lab def s        3590 "Miscellaneous Food Preparation and Serving Related Workers, Including Dining Room and Cafeteria Attendants and Bartender Helpers", add
lab def s         4520 "Miscellaneous Agricultural Workers, Including Animal Breeders", add
lab def s         4740 "Miscellaneous Construction Workers, Including Septic Tank Servicers and Sewer Pipe Cleaners", add
lab def s         4750 "Miscellaneous Extraction Workers, Including Roof Bolters and Helpers or Derrick, Rotary Drill, and Service Unit Operators, and Roustabouts, Oil, Gas and Mining", add
lab def s         5170 "Miscellaneous Woodworkers, Including Model Makers and Patternmakers", add
 lab def s        5191 "Other Production Workers, Including Semiconductor Processors and Cooling and Freezing Equipment Operators", add
lab def s         5340 "Subway, Streetcar, and Other Rail Transportation Workers", add
lab def s         5350 "Sailors and Marine Oilers, and Ship Engineers", add
lab def s         5360 "Miscellaneous Transportation Workers, Including Bridge and Lock Tenders and Traffic Technicians", add
 lab def s        5370 "Conveyor Operators and Tenders, and Hoist and Winch Operators", add
lab def s         5371 "Miscellaneous Material Moving Workers, Including shuttle Car Operators, and Tank Car, Truck, and Ship Loaders", add
lab def s        11102 "General and Operations Managers", add
lab def s        11201 "Advertising and Promotions Managers", add
lab def s        11202 "Marketing and Sales Managers", add
lab def s        11203 "Public Relations Managers", add
lab def s        11301 "Administrative Services managers", add
lab def s        11302 "Computer and Information Systems Managers", add
lab def s        11303 "Financial Managers", add
lab def s        11304 "Human Resources Managers", add
lab def s        11305 "Industrial Production Managers", add
lab def s        11306 "Purchasing Managers", add
lab def s        11307 "Transportation, Storage, and Distribution Managers", add
lab def s        11901 "Agricultural Managers", add
 lab def s       11902 "Construction Managers", add
lab def s        11903 "Education Administrators", add
lab def s        11904 "Engineering Managers", add
lab def s        11905 "Food Service Managers", add
 lab def s       11906 "Funeral Directors", add
 lab def s       11907 "Gaming Managers", add
 lab def s       11908 "Lodging Managers", add
lab def s        11911 "Medical and Health Services Managers", add
 lab def s       11912 "Natural Sciences Managers", add
 lab def s       11914 "Property, Real Estate, and Community Association Managers", add
 lab def s       11915 "Social and Community Service Managers", add
 lab def s       13101 "Agents and Business Managers of Artists, Performers, and Athletes", add
 lab def s       13102 "Buyers and Purchasing Agents", add
 lab def s       13103 "Claims Adjusters, Appraisers, Examiners, and Investigators", add
 lab def s       13104 "Compliance Officers, Except Agriculture, Construction, Health and Safety, and Transportation", add
 lab def s       13105 "Cost Estimators", add
 lab def s       13107 "Human Resources, Training, and Labor Relations Specialists", add
  lab def s      13108 "Logisticians", add
 lab def s       13111 "Management Analysts", add
 lab def s       13112 "Meeting and Convention Planners", add
 lab def s       13201 "Accountants and Auditors", add
 lab def s       13202 "Appraisers and Assessors of Real Estate", add
 lab def s       13203 "Budget Analysts", add
 lab def s       13204 " Credit Analysts", add
 lab def s       13205 "Financial Analysts and Advisors", add
 lab def s       13206 "Financial Examiners", add
 lab def s       13207 "Loan Counselors and Officers", add
 lab def s       13208 "Tax Examiners, Collectors, Preparers, and Revenue Agents", add
 lab def s       13209 "Miscellaneous Financial Specialists", add
 lab def s       15102 "Computer Programmers", add
 lab def s       15103 "Computer Software Engineers", add
 lab def s       15104 "Computer Support Specialists", add
  lab def s      15106 "Database Administrators", add
lab def s        15107 "Network and Computer Systems Administrators", add
lab def s        15108 "Network Systems and Data Communications Analysts", add
lab def s        15201 "Actuaries", add
lab def s        15203 "Operations Research Analysts", add
lab def s        17101 "Architects, Except Naval", add
 lab def s       17102 "Surveyors, Cartographers, and Photogrammetrists", add
 lab def s       17201 "Aerospace Engineers", add
 lab def s       17204 " Chemical Engineers", add
 lab def s       17205 "Civil Engineers", add
 lab def s       17206 "Computer Hardware Engineers", add
 lab def s       17207 "Electrical and Electronics Engineers", add
 lab def s       17208 "Environmental Engineers", add
 lab def s       17211 "Industrial Engineers, Including Health and Safety", add
  lab def s      17212 "Marine Engineers and Naval Architects", add
  lab def s      17213 "Materials Engineers", add
 lab def s       17214 "Mechanical Engineers", add
 lab def s       17301 " Drafters", add
 lab def s       17302 "Engineering Technicians, Except Drafters", add
 lab def s       17303 "Surveying and Mapping Technicians", add
 lab def s       19101 "Agricultural and Food Scientists", add
 lab def s       19102 "Biological Scientists", add
lab def s        19103 "Conservation Scientists and Foresters", add
lab def s        19104 "Medical Scientists", add
lab def s        19201 "Astronomers and Physicists", add
 lab def s       19202 "Atmospheric and Space Scientists", add
lab def s        19203 "Chemists and Materials Scientists", add
lab def s        19204 "Environmental Scientists and Geoscientists", add
lab def s        19209 "Miscellaneous Physical Scientists", add
lab def s        19301 "Economists", add
 lab def s       19302 "Market and Survey Researchers", add
 lab def s       19303 "Psychologists", add
 lab def s       19305 "Urban and Regional Planners", add
 lab def s       19401 " Agricultural and Food Science Technicians", add
 lab def s       19402 " Biological Technicians", add
lab def s        19403 "Chemical Technicians", add
lab def s        19404 "Geological and Petroleum Technicians", add
lab def s        21101 "Counselors", add
lab def s        21102 "Social Workers", add
 lab def s       21109 "Miscellaneous Community and Social Service Specialists", add
 lab def s       21201 "Clergy", add
 lab def s       21202 "Directors, Religious Activities and Education", add
 lab def s       21209 "Miscellaneous Religious Workers", add
 lab def s       23201 "Paralegals and Legal Assistants", add
 lab def s       23209 "Miscellaneous Legal Support Workers", add
 lab def s       25100 "Postsecondary Teachers", add
 lab def s       25201 "Preschool and Kindergarten Teachers", add
 lab def s       25202 "Elementary and Middle School Teachers", add
 lab def s       25203 "Secondary School Teachers", add
 lab def s       25204 "Special Education Teachers", add
lab def s        25300 "Other Teachers and Instructors", add
 lab def s       25401 "Archivists, Curators, and Museum Technicians", add
 lab def s       25402 "Librarians", add
 lab def s       25403 "Library Technicians", add
 lab def s       25904 "Teacher Assistants", add
 lab def s       27101 "Artists and Related Workers", add
 lab def s       27102 "Designers", add
 lab def s       27201 "Actors, Producers, and Directors", add
 lab def s       27202 "Athletes, Coaches, Umpires, and Related Workers", add
 lab def s       27203 "Dancers and Choreographers", add
 lab def s       27204 "Musicians, Singers, and Related Workers", add
 lab def s       27209 "Miscellaneous Entertainers and Performers, Sports and Related Workers", add
 lab def s       27301 "Announcers", add
 lab def s       27302 " News Analysts, Reporters and Correspondents", add
 lab def s       27303 " Public Relations Specialists", add
 lab def s       27304 "Writers and Editors", add
lab def s        27309 "Miscellaneous Media and Communication Workers", add
 lab def s       27402 " Photographers", add
 lab def s       27403 "Television, Video, and Motion Picture Camera Operators and Editors", add
 lab def s       29101 " Chiropractors", add
 lab def s       29102 " Dentists", add
 lab def s       29103 "Dietitians and Nutritionists", add
 lab def s       29104 "Optometrists", add
 lab def s       29105 "Pharmacists", add
 lab def s       29106 " Physicians and Surgeons", add
 lab def s       29107 "Physician Assistants", add
 lab def s       29108 "Podiatrists", add
 lab def s       29111 "Registered Nurses", add
 lab def s       29112 "Therapists", add
 lab def s       29113 "Veterinarians", add
 lab def s       29119 "Miscellaneous Health Diagnosing and Treating Practitioners", add
 lab def s       29201 "Clinical Laboratory Technologists and Technicians", add
 lab def s       29202 "Dental Hygienists", add
 lab def s       29203 "Diagnostic Related Technologists and Technicians", add
 lab def s       29204 "Emergency Medical Technicians and Paramedics", add
 lab def s       29205 "Health Diagnosing and Treating Practitioner Support Technicians", add
 lab def s       29206 "Licensed Practical and Licensed Vocational Nurses", add
 lab def s       29207 "Medical Records and Health Information Technicians", add
lab def s        29208 " Opticians, Dispensing", add
 lab def s       29209 "Miscellaneous Health Technologists and Technicians", add
lab def s        29900 " Other Healthcare Practitioners and Technical Occupations", add
lab def s        31101 "Nursing, Psychiatric, and Home Health Aides", add
lab def s        31201 "Occupational Therapist Assistants and Aides", add
lab def s        31202 " Physical Therapist Assistants and Aides", add
 lab def s       31901 "Massage Therapists", add
 lab def s       31909 " Miscellaneous Healthcare Support Occupations", add
 lab def s       33101 "First-Line Supervisors/Managers, Law Enforcement Workers", add
 lab def s       33102 "First-Line Supervisors/Managers, Fire Fighting and Prevention Workers", add
 lab def s       33109 "Miscellaneous First-Line Supervisors/Managers, Protective Service Workers", add
 lab def s       33201 " Fire Fighters", add
 lab def s       33202 "Fire Inspectors", add
lab def s        33301 " Bailiffs, Correctional Officers, and Jailers", add
lab def s        33302 "Detectives and Criminal Investigators", add
 lab def s       33305 "Police Officers", add
 lab def s       33901 "Animal Control Workers", add
 lab def s       33902 "Private Detectives and Investigators", add
 lab def s       33903 "Security Guards and Gaming Surveillance Officers", add
 lab def s       33909 "Miscellaneous Protective Service Workers", add
 lab def s       35101 "First-Line Supervisors/Managers, Food Preparation and Serving Workers", add
 lab def s       35201 " Cooks", add
 lab def s       35202 "Food Preparation Workers", add
 lab def s       35301 "Bartenders", add
 lab def s       35302 "Fast Food and Counter Workers", add
 lab def s       35303 "Waiters and Waitresses", add
 lab def s       35304 "Food Servers, Nonrestaurant", add
 lab def s       35902 "Dishwashers", add
 lab def s       35903 "Hosts and Hostesses, Restaurant, Lounge, and Coffee Shop", add
 lab def s       37101 "First-Line Supervisors/Managers, Building and Grounds Cleaning and Maintenance Workers", add
 lab def s       37201 " Building Cleaning Workers", add
 lab def s       37202 "Pest Control Workers", add
 lab def s       37301 "Grounds Maintenance Workers", add
 lab def s       39101 "First-Line Supervisors/Managers of Gaming Workers", add
 lab def s       39102 "First-Line Supervisors/Managers of Personal Service Workers", add
 lab def s       39201 " Animal Trainers", add
 lab def s       39202 "Nonfarm Animal Caretakers", add
 lab def s       39301 "Gaming Services Workers", add
 lab def s       39302 "Motion Picture Projectionists", add
 lab def s       39303 "Ushers, Lobby Attendants, and Ticket Takers", add
 lab def s       39309 "Miscellaneous Entertainment Attendants and Related Workers", add
 lab def s       39400 "Funeral Service Workers", add
 lab def s       39501 "Barbers and Cosmetologists", add
 lab def s       39509 " Miscellaneous Personal Appearance Workers", add
 lab def s       39601 " Baggage Porters, Bellhops, and Concierges", add
 lab def s       39602 "Tour and Travel Guides", add
 lab def s       39603 "Transportation Attendants", add
lab def s        39901 "Child Care Workers", add
 lab def s       39902 "Personal and Home Care Aides", add
 lab def s       39903 "Recreation and Fitness Workers", add
 lab def s       39904 "Residential Advisors", add
 lab def s       39909 "Miscellaneous Personal Care and Service Workers", add
 lab def s       41101 "First-Line Supervisors/Managers, Sales Workers", add
 lab def s       41201 "Cashiers", add
 lab def s       41202 "Counter and Rental Clerks and Parts Salespersons", add
 lab def s       41203 "Retail Salespersons", add
 lab def s       41301 " Advertising Sales Agents", add
 lab def s       41302 "Insurance Sales Agents", add
 lab def s       41303 "Securities, Commodities, and Financial Services Sales Agents", add
 lab def s       41304 "Travel Agents", add
 lab def s       41309 "Miscellaneous Sales Representatives, Services", add
 lab def s       41401 "Sales Representatives, Wholesale and Manufacturing", add
 lab def s       41901 " Models, Demonstrators, and Product Promoters", add
 lab def s       41902 " Real Estate Brokers and Sales Agents", add
 lab def s       41903 "Sales Engineers", add
lab def s        41904 "Telemarketers", add
 lab def s       41909 "Miscellaneous Sales and Related Workers", add
 lab def s       43101 "First-Line Supervisors/Managers of Office and Administrative Support Workers", add
 lab def s       43201 "Switchboard Operators, Including Answering Service", add
lab def s        43202 "Telephone Operators", add
 lab def s       43209 " Miscellaneous Communications Equipment Operators", add
lab def s        43301 " Bill and Account Collectors", add
 lab def s       43302 "Billing and Posting Clerks and Machine Operators", add
 lab def s       43303 "Bookkeeping, Accounting, and Auditing Clerks", add
 lab def s       43304 "Gaming Cage Workers", add
 lab def s       43305 " Payroll and Timekeeping Clerks", add
 lab def s       43306 " Procurement Clerks", add
 lab def s       43307 " Tellers", add
 lab def s       43401 "Brokerage Clerks", add
 lab def s       43403 "Court, Municipal, and License Clerks", add
 lab def s       43404 "Credit Authorizers, Checkers, and Clerks", add
 lab def s       43405 "Customer Service Representatives", add
 lab def s       43406 "Eligibility Interviewers, Government Programs", add
 lab def s       43407 "File Clerks", add
 lab def s       43408 "Hotel, Motel, and Resort Desk Clerks", add
 lab def s       43411 " Interviewers, Except Eligibility and Loan", add
 lab def s       43412 "Library Assistants, Clerical", add
 lab def s       43413 "Loan Interviewers and Clerks", add
 lab def s       43414 "New Accounts Clerks", add
 lab def s       43416 "Human Resources Assistants, Except Payroll and Timekeeping", add
 lab def s       43417 "Receptionists and Information Clerks", add
 lab def s       43418 " Reservation and Transportation Ticket Agents and Travel Clerks", add
 lab def s       43419 "Miscellaneous Information and Record Clerks", add
 lab def s       43501 "Cargo and Freight Agents", add
 lab def s       43502 "Couriers and Messengers", add
 lab def s       43503 "Dispatchers", add
 lab def s       43504 "Meter Readers, Utilities", add
 lab def s       43505 "Postal Service Workers", add
 lab def s       43506 "Production, Planning, and Expediting Clerks", add
 lab def s       43507 " Shipping, Receiving, and Traffic Clerks", add
 lab def s       43508 "Stock Clerks and Order Fillers", add
 lab def s       43511 " Weighers, Measurers, Checkers, and Samplers, Recordkeeping", add
 lab def s       43601 "Secretaries and Administrative Assistants", add
 lab def s       43901 "Computer Operators", add
 lab def s       43902 "Data Entry and Information Processing Workers", add
 lab def s       43904 "Insurance Claims and Policy Processing Clerks", add
 lab def s       43905 " Mail Clerks and Mail Machine Operators, Except Postal Service", add
 lab def s       43906 " Office Clerks, General", add
 lab def s       43907 "Office Machine Operators, Except Computer", add
 lab def s       43908 " Proofreaders and Copy Markers", add
 lab def s       43911 "Statistical Assistants", add
lab def s        45101 "First-Line Supervisors/Managers of Farming, Fishing, and Forestry Workers", add
  lab def s      45201 "Agricultural Inspectors", add
  lab def s      45204 " Graders and Sorters, Agricultural Products", add
 lab def s       45300 "Fishing and Hunting Workers", add
 lab def s       45401 " Forest and Conservation Workers", add
 lab def s       45402 "Logging Workers", add
 lab def s       47101 " First-Line Supervisors/Managers of Construction Trades and Extraction Workers", add
 lab def s       47201 " Boilermakers", add
 lab def s       47202 "Brickmasons, Blockmasons, and Stonemasons", add
 lab def s       47203 "Carpenters", add
 lab def s       47204 "Carpet, Floor, and Tile Installers and Finishers", add
 lab def s       47205 " Cement Masons, Concrete Finishers, and Terrazzo Workers", add
 lab def s       47206 " Construction Laborers", add
 lab def s       47207 " Construction Equipment Operators", add
 lab def s       47208 " Drywall Installers, Ceiling Tile Installers, and Tapers", add
 lab def s       47211 "Electricians", add
 lab def s       47212 "Glaziers", add
 lab def s       47213 "Insulation Workers", add
 lab def s       47214 "Painters and Paperhangers", add
 lab def s       47215 "Pipelayers, Plumbers, Pipefitters, and Steamfitters", add
 lab def s       47216 "Plasterers and Stucco Masons", add
 lab def s       47217 " Reinforcing Iron and Rebar Workers", add
 lab def s       47218 " Roofers", add
 lab def s       47221 "Sheet Metal Workers", add
 lab def s       47222 "Structural Iron and Steel Workers", add
 lab def s       47301 "Helpers, Construction Trades", add
 lab def s       47401 "Construction and Building Inspectors", add
 lab def s       47402 " Elevator Installers and Repairers", add
 lab def s       47403 "Fence Erectors", add
 lab def s       47404 "Hazardous Materials Removal Workers", add
 lab def s       47405 "Highway Maintenance Workers", add
 lab def s       47406 "Rail-Track Laying and Maintenance Equipment Operators", add
 lab def s       47502 "Earth Drillers, Except Oil and Gas", add
 lab def s       47503 " Explosives Workers, Ordnance Handling Experts, and Blasters", add
lab def s        47504 "Mining Machine Operators", add
lab def s        49101 "First-Line Supervisors/Managers of Mechanics, Installers, and Repairers", add
lab def s        49201 " Computer, Automated Teller, and Office Machine Repairers", add
lab def s        49202 "Radio and Telecommunications Equipment Installers and Repairers", add
 lab def s       49209 "Miscellaneous Electrical and Electronic Equipment Mechanics, Installers, and Repairers", add
 lab def s       49301 "Aircraft Mechanics and Service Technicians", add
lab def s        49302 "Automotive Technicians and Repairers", add
 lab def s       49303 " Bus and Truck Mechanics and Diesel Engine Specialists", add
 lab def s       49304 "Heavy Vehicle and Mobile Equipment Service Technicians and Mechanics", add
lab def s        49305 "Small Engine Mechanics", add
 lab def s       49309 "Miscellaneous Vehicle and Mobile Equipment Mechanics, Installers, and Repairers", add
lab def s        49901 "Control and Valve Installers and Repairers", add
lab def s        49902 "Heating, Air Conditioning, and Refrigeration Mechanics and Installers", add
lab def s        49903 "Home Appliance Repairers", add
lab def s        49904 "Industrial Machinery Installation, Repair, and Maintenance Workers", add
lab def s        49905 "Line Installers and Repairers", add
lab def s        49906 "Precision Instrument and Equipment Repairers", add
 lab def s       49909 "Miscellaneous Installation, Maintenance, and Repair Workers", add
 lab def s       51101 " First-Line Supervisors/Managers of Production and Operating Workers", add
 lab def s       51201 "Aircraft Structure, Surfaces, Rigging, and Systems Assemblers", add
 lab def s       51202 " Electrical, Electronics, and Electromechanical Assemblers", add
 lab def s       51203 "Engine and Other Machine Assemblers", add
lab def s        51204 "Structural Metal Fabricators and Fitters", add
lab def s        51209 " Miscellaneous Assemblers and Fabricators", add
lab def s        51301 " Bakers", add
lab def s        51302 " Butchers and Other Meat, Poultry, and Fish Processing Workers", add
 lab def s       51309 " Miscellaneous Food Processing Workers", add
 lab def s       51401 "Computer Control Programmers and Operators", add
 lab def s       51402 "Forming Machine Setters, Operators, and Tenders, Metal and Plastic", add
 lab def s       51403 "Machine Tool Cutting Setters, Operators, and Tenders, Metal and Plastic", add
 lab def s       51404 " Machinists", add
 lab def s       51405 "Metal Furnace and Kiln Operators and Tenders", add
 lab def s       51406 "Model Makers and Patternmakers, Metal and Plastic", add
 lab def s       51407 " Molders and Molding Machine Setters, Operators, and Tenders, Metal and Plastic", add
lab def s        51411 "Tool and Die Makers", add
 lab def s       51412 " Welding, Soldering, and Brazing Workers", add
 lab def s       51419 " Miscellaneous Metalworkers and Plastic Workers", add
  lab def s      51501 " Bookbinders and Bindery Workers", add
 lab def s       51502 "Printers", add
 lab def s       51601 "Laundry and Dry-Cleaning Workers", add
 lab def s       51602 " Pressers, Textile, Garment, and Related Materials", add
 lab def s       51603 " Sewing Machine Operators", add
 lab def s       51604 " Shoe and Leather Workers", add
 lab def s       51605 "Tailors, Dressmakers, and Sewers", add
 lab def s       51606 "Textile Machine Setters, Operators, and Tenders", add
 lab def s       51609 "Miscellaneous Textile, Apparel, and Furnishings Workers", add
 lab def s       51701 "Cabinetmakers and Bench Carpenters", add
 lab def s       51702 "Furniture Finishers", add
 lab def s       51704 "Woodworking Machine Setters, Operators, and Tenders", add
 lab def s       51801 "Power Plant Operators, Distributors, and Dispatchers", add
 lab def s       51802 "Stationary Engineers and Boiler Operators", add
 lab def s       51803 "Water and Liquid Waste Treatment Plant and System Operators", add
 lab def s       51809 "Miscellaneous Plant and System Operators", add
 lab def s       51901 "Chemical Processing Machine Setters, Operators, and Tenders", add
 lab def s       51902 "Crushing, Grinding, Polishing, Mixing, and Blending Workers", add
 lab def s       51903 " Cutting Workers", add
 lab def s       51904 "Extruding, Forming, Pressing, and Compacting Machine Setters, Operators, and Tenders", add
 lab def s       51905 "Furnace, Kiln, Oven, Drier, and Kettle Operators and Tenders", add
 lab def s       51906 " Inspectors, Testers, Sorters, Samplers, and Weighers", add
 lab def s       51907 "Jewelers and Precious Stone and Metal Workers", add
 lab def s       51908 " Medical, Dental, and Ophthalmic Laboratory Technicians", add
 lab def s       51911 " Packaging and Filling Machine Operators and Tenders", add
 lab def s       51912 " Painting Workers", add
 lab def s       51913 "Photographic Process Workers and Processing Machine Operators", add
 lab def s       51919 "Miscellaneous Production Workers", add
 lab def s       53100 "Supervisors, Transportation and Material Moving Workers", add
 lab def s       53201 "Aircraft Pilots and Flight Engineers", add
lab def s        53202 "Air Traffic Controllers and Airfield Operations Specialists", add
 lab def s       53301 "Ambulance Drivers and Attendants, Except Emergency Medical Technicians", add
 lab def s       53302 "Bus Drivers", add
 lab def s       53303 " Driver/Sales Workers and Truck Drivers", add
 lab def s       53304 "Taxi Drivers and Chauffeurs", add
 lab def s       53309 "Miscellaneous Motor Vehicle Operators", add
 lab def s       53401 "Locomotive Engineers and Operators", add
 lab def s       53402 "Railroad Brake, Signal, and Switch Operators", add
 lab def s       53403 "Railroad Conductors and Yardmasters", add
 lab def s       53502 "Ship and Boat Captains and Operators", add
 lab def s       53602 "Parking Lot Attendants", add
 lab def s       53603 "Service Station Attendants", add
lab def s        53605 "Transportation Inspectors", add
lab def s        53702 "Crane and Tower Operators", add
lab def s        53703 "Dredge, Excavating, and Loading Machine Operators", add
lab def s        53705 "Industrial Truck and Tractor Operators", add
lab def s        53706 "Laborers and Material Movers, Hand", add
 lab def s       53707 "Pumping Station Operators", add
 lab def s       53708 "Refuse and Recyclable Material Collectors", add
 lab def s       55101 "Military Officer Special and Tactical Operations Leaders/Managers", add
 lab def s       55201 "First-Line Enlisted Military Supervisors/Managers", add
 lab def s       55301 "Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members", add
 lab def s       55983 "Military, Rank Not Specified", add
 lab def s       99992 "Unemployed and Last Worked 5 Years Ago or Earlier or Never Worked", add

lab values socp_5d s


/*47) Income in the past 12 months
Mark the "Yes" box for each type of income this person received, and give your best estimate of the TOTAL AMOUNT
 during the PAST 12 MONTHS.
NOTE: The "past 12 months" is the period from today’s date one year ago up through today.
Mark the "No" box to show types of income NOT received.
If net income was a loss, mark the "loss" box to the right of the dollar amount.
For income received jointly, report the appropriate share for each person- or, if that's not possible, report
 the whole amount for only one person and mark the "No" box for the other person.
47a- 47h list different sources of income, and the respondant fills in the amount received from each source 
in a box for parts a-h
48) What was this person’s total income during the PAST 12 MONTHS? 
Add entries in questions 47a to 47h; subtract any losses. 
If net income was a loss, enter the amount and mark (X) the "Loss" box next to the dollar amount.
None....................................0
Loss of $19998 or more..................-19998 (rounded and bottom-coded)
Loss of $1 to $19997....................-1 ..-19997 (rounded)
$1 or break even.........................1
$2 to $9,999,999.........................2..9999999 (rounded and top-coded)*/

rename wagp yrly_wage
//"wages or salary income"//
rename pernp earnings_total
rename pincp income_total

/*r. Renaming additional variables that may come in handy and recoding dummy variables*/
rename migpuma migration_puma
rename migsp migration_location
replace nativity = 0 if nativity==1
replace nativity = 1 if nativity==2
rename nativity foreignborn_d
rename nop parents_nativity
replace sciengp = 0 if sciengp==2
rename sciengp scieng_deg
replace sciengrlp = 0 if sciengrlp==2
rename sciengrlp sciengrelated_deg

/*s. Dropping imputation flags. Renaming the variables for which imputed values were recoded as missing; this is
done to distinguish them from the variables for which imputation information was not available.*/
#delimit ;
drop fagep fcitp fcitwp fcowp fengp flanxp fmarpfschlp fsexp fwagp fwkhp fwklp fwkwp fyoep fesrp 
ffodp fhisp findp flanp foccp fracp;
#delimit cr

rename age age_f
rename cit cit_f
rename nat_yr nat_yrf
rename work_type work_typef
rename engl_ability engl_abilityf
rename engl_home engl_homef
rename marstat marstatf
rename mar_d mar_df
rename primary primary_f
rename hsdrop hsdrop_f
rename hsgrad hsgrad_f
rename GED_equiv GED_equivf
rename coll_nodeg coll_nodegf
rename associates associates_f
rename bachelors bachelors_f
rename masters masters_f
rename profdeg profdeg_f
rename female female_f
rename yrly_wage yrly_wagef
rename hrs_wrked hrs_wrkedf
rename wks_wrked wks_wrkedf
rename wkw wkwf
rename entry entry_f
rename wrk_stat wrk_statf
rename bachelors_1stfield bachelors_1stfieldf
rename bachelors_2ndfield bachelors_2ndfieldf
rename hisp_detail hisp_detailf
rename latamerican_d latamerican_df
rename naicsp_2d naicsp_2df
rename naicsp_3d naicsp_3df
rename naicsp_4d naicsp_4df
rename socp_2d socp_2df
rename socp_3d socp_3df
rename socp_5d socp_5df
rename race_detailed race_detailedf
rename amerinative_d amerinative_df
rename asian_d asian_df
rename black_d black_df
rename pacific_d pacific_df
rename white_d white_df

/*t. Dropping all other variables that, while needed earlier in the do-file,
 are unnecessary after the do-file is run.*/
 #delimit ;
 drop nwab nwav nwla nwre wkl decade hicov indp lanp naicsp naicsp4 occp socp naicsp_2
 naicsp_3 naicsp_4 socp_4 socp_4d socp_3 socp_5 socp_2;
 #delimit cr
 
