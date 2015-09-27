******An Empirical Study of Child Labor Participation in Madagascar
*** This file uses data files from the 2005 EPM in Madagascar to calculate various components of household expenditure
****Create a file named "688EPM" on your computer's desktop.  Download the data files and put them in that folder. 
****Note that you may need to change the file path on your computer


/*Files you will use
Survey excel file

Expenditures 14 A
	"C:\Documents and Settings\Administrator\Desktop\688EPM\Spending14_A.dta"

Expenditures 14 C  
	"C:\Documents and Settings\Administrator\Desktop\688EPM\Spending14_C.dta", clear
		
Housing 
	"C:\Documents and Settings\Administrator\Desktop\688EPM\epm2005_sect7.dta"	

Expend 14 B Food and fuel
	"C:\Documents and Settings\Administrator\Desktop\688EPM\Spending14_B.dta"

Durables  
	"C:\Documents and Settings\Administrator\Desktop\Development\EPM\epm2005\data\epm2005_sect9.dta"

autoconsumption
	"C:\Documents and Settings\Administrator\Desktop\688EPM\agriBrevised.dta"			

hh consumption of fish
	"C:\Documents and Settings\Administrator\Desktop\688EPM\fishconsumption.dta"

HOUSEHOLD COMPOSITION
	"C:\Documents and Settings\Administrator\Desktop\688EPM\Demographie.dta"

*/




clear
	set mem 300m
	set matsize 600


	


use "/Volumes/USB20FD/688EPM/epm2005_sect10.dta"
gen gender=q01a01
replace gender=0 if gender==2
rename age_ans age
rename q01a03 relation

gen child=0
replace child=1 if age <=15
gen ychild=0
replace ychild=1 if age<=6

gen  all=0 
replace all=1 if age >=6 & age<=15

gen young=0
replace young=1 if age >=6 & age <=10 

gen old=0
replace old=1 if age>=11 & age <=15

gen boy=0
replace boy=1 if gender==1
replace boy=0 if all==0
gen girl=0
replace girl=1 if gender==0
replace girl=0 if all==0 
gen urban=0
replace urban=1 if  milieu==1

gen Antananarivo=0
replace Antananarivo=1 if  far==1
gen Fianarantsoa =0
replace Fianarantsoa =1 if  far==2
gen Toamasina=0
replace Toamasina=1 if  far==3
gen  Mahajanga=0
replace  Mahajanga=1 if  far==4
gen  Toliara=0
replace  Toliara=1 if  far==5
gen  Antsiranana=0
replace  Antsiranana=1 if  far==7


keep   Antananarivo Fianarantsoa Toamasina Mahajanga Toliara Antsiranana  codeind all young old girl ychild boy idmen  idmen_zd  idind age relation child gender urban

save "/Volumes/USB20FD/688EPM/table_1.dta", replace

clear
use "/Volumes/USB20FD/688EPM/table_1.dta"

drop if child==0

drop if all==1

save  "/Volumes/USB20FD/688EPM/child.dta", replace

clear
use "/Volumes/USB20FD/688EPM/epm2005_sect40.dta"	
rename q04a12 attend
rename q04a10 enroll
rename q04a04 non

gen schooling=0
replace  schooling=1 if  attend==1
replace  schooling=. if  attend==.
replace  schooling=0 if  enroll==2 & attend ==.
replace  schooling=0 if  non==2 & attend==.


keep schooling idmen_zd idmen idind

joinby(idind) using "/Volumes/USB20FD/688EPM/table_1.dta", unmatched(both)

save "/Volumes/USB20FD/688EPM/table_1.1.dta", replace





clear

use "/Volumes/USB20FD/688EPM/epm2005_sect5b0.dta"



rename q05b01 allwork

rename q05b07 hour
rename q05b08 day

gen  week=hour*day
keep idind  allwork week 

joinby(idind) using "/Volumes/USB20FD/688EPM/epm2005_sect5a0.dta", unmatched(both)


rename q05aa hhchores
rename q05a01 last
rename q05a02 non

replace hhchores=0 if hhchores==.
gen employ=0

replace employ=1 if non==1 | last==1

gen agri=2
replace agri=1 if allwork==621
replace agri=0 if allwork==.
replace week=0 if week==.
 

gen hh=0
replace hh=1 if hhchores~=0 
gen hhweek=hhchores*7/60


keep  idmen idmen_zd hhweek hh employ idind agri allwork week 

save "/Volumes/USB20FD/688EPM/table_1.2.dta", replace

clear 
use  "/Volumes/USB20FD/688EPM/table_1.2.dta"
joinby(idind) using "/Volumes/USB20FD/688EPM/table_1.1.dta"
drop allwork
gen allwork=0
replace allwork=1 if employ==1|hh==1
drop if schooling==.
gen total= hhweek + week
append using "/Volumes/USB20FD/688EPM/child.dta"

save "/Volumes/USB20FD/688EPM/q_1.dta", replace


clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"



collapse(sum)  all, by(idmen_zd)
drop if all==0
rename all a
joinby(idmen_zd) using "/Volumes/USB20FD/688EPM/q_1.dta"
drop a

gen age6=0
replace age6=1 if age==6
gen age7=0
replace age7=1 if age==7
gen age8=0
replace age8=1 if age==8
gen age9=0
replace age9=1 if age==9
gen age10=0
replace age10=1 if age==10
gen age11=0
replace age11=1 if age==11
gen age12=0
replace age12=1 if age==12
gen age13=0
replace age13=1 if age==13
gen age14=0
replace age14=1 if age==14
gen age15=0
replace age15=1 if age==15

gen agriwork=week
replace agriwork=0 if agri~=1

gen nonagriwork=week
replace nonagriwork=0 if agri~=2

save "/Volumes/USB20FD/688EPM/q_1.dta", replace


**********************************************************************************

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

tab schooling if all==1
tab agri if all==1
tab hh if all==1
tab allwork if all==1


tab schooling if boy==1
tab agri if boy==1
tab hh if boy==1
tab allwork if boy==1

tab schooling if girl==1
tab agri if girl==1
tab hh if girl==1
tab allwork if girl==1

tab schooling if young==1
tab agri if young==1
tab hh if young==1
tab allwork if young==1

tab schooling if old==1
tab agri if old==1
tab hh if old==1
tab allwork if old==1


sum week if all==1 &agri~=2
sum week if agri==1 &all==1 

sum week if all==1 & agri~=1
sum week if all==1 & agri==2

sum hhweek if all==1
sum hhweek if hh==1& all==1

sum total if all==1
sum total if allwork==1 & all==1



sum week if boy==1 &agri~=2
sum week if agri==1 & boy==1 

sum week if boy==1 & agri~=1
sum week if boy==1 & agri==2

sum hhweek if boy==1
sum hhweek if hh==1& boy==1

sum total if boy==1
sum total if allwork==1 & boy==1



sum week if girl==1 &agri~=2
sum week if agri==1 & girl==1 

sum week if girl==1 & agri~=1
sum week if girl==1 & agri==2

sum hhweek if girl==1
sum hhweek if hh==1& girl==1

sum total if girl==1
sum total if allwork==1 & girl==1



sum week if young==1 &agri~=2
sum week if agri==1 & young==1 

sum week if young==1 & agri~=1
sum week if young==1 & agri==2

sum hhweek if young==1
sum hhweek if hh==1& young==1

sum total if young==1
sum total if allwork==1 & young==1


sum week if old==1 &agri~=2
sum week if agri==1 & old==1 

sum week if old==1 & agri~=1
sum week if old==1 & agri==2

sum hhweek if old==1
sum hhweek if hh==1& old==1

sum total if old==1
sum total if allwork==1 & old==1

*********************************

gen agriwork=week
replace agriwork=0 if agri~=1
sum agriwork if all==1
sum agriwork if all==1 &agri==1

gen nonagriwork=week
replace nonagriwork=0 if agri~=2
sum nonagriwork if all==1
sum nonagriwork if all==1 &agri==2



sum agriwork if boy==1
sum agriwork if boy==1 &agri==1

sum nonagriwork if boy==1
sum nonagriwork if boy==1 &agri==2


sum agriwork if girl==1
sum nonagriwork if girl==1

sum agriwork if young==1
sum nonagriwork if young==1

sum agriwork if old==1
sum nonagriwork if old==1


*************************

gen sun=0
replace sun=1 if relation==3

gen gran=0
replace gran=1 if relation==5

gen sister=0
replace sister=1 if relation==7

gen niece=0
replace niece=1 if relation==9

gen servant=0
replace servant=1 if relation==15

gen other=1
replace other=0 if relation==3
replace other=0 if relation==5
replace other=0 if relation==7
replace other=0 if relation==9
replace other=0 if relation==15



clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

gen number=1

collapse(sum) number all, by(idmen)
drop if all==0

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

gen sibling1=0
replace sibling1=1 if relation==3

gen sibling2=0
replace sibling2=1 if relation==5

gen sibling3=0
replace sibling3=1 if relation==7

gen sibling4=0
replace sibling4=1 if relation==9

gen sibling5=0
replace sibling5=1 if relation==15

collapse(sum) sibling1 sibling2 sibling3 sibling4 sibling5  all, by(idmen)

drop if all==0
gen siblings=sibling1*0.8238+sibling2*0.1123+sibling3*0.0164+sibling4*0.0285


clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

gen kid=0
replace kid=1 if age<=6



collapse(sum)  kid all, by(idmen)
*****************************************************************

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

gen spouse=0
replace spouse=1 if relation==2

collapse(sum)  spouse all, by(idmen)
replace  spouse=1 if spouse~=0





clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
  
gen head=0
replace head=1 if relation==1 & agri==1 


***************************************** order_1**********************************************8
clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==1
gen number=1
egen rank =rank(age) , by( idmen relation) 

collapse(sum) rank number, by(idmen_zd relation)
gen avg=rank/number
drop rank number
save "/Volumes/USB20FD/688EPM/rank.dta", replace

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==1
egen rank =rank(age) , by( idmen relation) 



collapse(sum) rank, by(idmen_zd relation)

gen one=0
replace one=1 if  rank==1

gen two=0
replace two=1 if  rank==3

gen three=0
replace three=1 if  rank==6

gen four=0
replace four=1 if  rank==10

gen five=0
replace five=1 if  rank==15

gen six=0
replace six=1 if  rank==21

gen seven=0
replace seven=1 if  rank==28

gen  eight=0
replace eight=1 if  rank==36


drop rank


save "/Volumes/USB20FD/688EPM/q_2.dta", replace

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==1
 
egen rank =rank(age) , by( idmen relation) 


joinby(idmen_zd relation) using "/Volumes/USB20FD/688EPM/q_2.dta"

gen order=0
replace order=1 if one==1

replace order=1 if two==1 & rank==2
replace order=2 if two==1 & rank==1

replace order=1 if three==1 & rank==3
replace order=2 if three==1 & rank==2
replace order=3 if three==1 & rank==1

replace order=1 if four==1 & rank==4
replace order=2 if four==1 & rank==3
replace order=3 if four==1 & rank==2
replace order=4 if four==1 & rank==1


replace order=1 if five==1 & rank==5
replace order=2 if five==1 & rank==4
replace order=3 if five==1 & rank==3
replace order=4 if five==1 & rank==2
replace order=5 if five==1 & rank==1


replace order=1 if six==1 & rank==6
replace order=2 if six==1 & rank==5
replace order=3 if six==1 & rank==4
replace order=4 if six==1 & rank==3
replace order=5 if six==1 & rank==2
replace order=6 if six==1 & rank==1









replace order=1 if seven==1 & rank==7
replace order=2 if seven==1 & rank==6
replace order=3 if seven==1 & rank==5
replace order=4 if seven==1 & rank==4
replace order=5 if seven==1 & rank==3
replace order=6 if seven==1 & rank==2
replace order=7 if seven==1 & rank==1





replace order=1 if eight==1 & rank==8
replace order=2 if eight==1 & rank==7
replace order=3 if eight==1 & rank==6
replace order=4 if eight==1 & rank==5
replace order=5 if eight==1 & rank==4
replace order=6 if eight==1 & rank==3
replace order=7 if eight==1 & rank==2
replace order=8 if eight==1 & rank==1

drop one two three four five six seven eight _merge
save "/Volumes/USB20FD/688EPM/men.dta", replace

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==0
rename number member
gen number=1
egen rank =rank(age) , by( idmen relation) 

collapse(sum) rank number, by(idmen_zd relation)
gen avg=rank/number
drop rank number
save "/Volumes/USB20FD/688EPM/rank.dta", replace

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==0
egen rank =rank(age) , by( idmen relation) 



collapse(sum) rank, by(idmen_zd relation)

gen one=0
replace one=1 if  rank==1

gen two=0
replace two=1 if  rank==3

gen three=0
replace three=1 if  rank==6

gen four=0
replace four=1 if  rank==10

gen five=0
replace five=1 if  rank==15

gen six=0
replace six=1 if  rank==21

gen seven=0
replace seven=1 if  rank==28

gen  eight=0
replace eight=1 if  rank==36


drop rank


save "/Volumes/USB20FD/688EPM/q_2.dta", replace

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==0
 
egen rank =rank(age) , by( idmen relation) 


joinby(idmen_zd relation) using "/Volumes/USB20FD/688EPM/q_2.dta"

gen order=0
replace order=1 if one==1

replace order=1 if two==1 & rank==2
replace order=2 if two==1 & rank==1

replace order=1 if three==1 & rank==3
replace order=2 if three==1 & rank==2
replace order=3 if three==1 & rank==1

replace order=1 if four==1 & rank==4
replace order=2 if four==1 & rank==3
replace order=3 if four==1 & rank==2
replace order=4 if four==1 & rank==1


replace order=1 if five==1 & rank==5
replace order=2 if five==1 & rank==4
replace order=3 if five==1 & rank==3
replace order=4 if five==1 & rank==2
replace order=5 if five==1 & rank==1


replace order=1 if six==1 & rank==6
replace order=2 if six==1 & rank==5
replace order=3 if six==1 & rank==4
replace order=4 if six==1 & rank==3
replace order=5 if six==1 & rank==2
replace order=6 if six==1 & rank==1









replace order=1 if seven==1 & rank==7
replace order=2 if seven==1 & rank==6
replace order=3 if seven==1 & rank==5
replace order=4 if seven==1 & rank==4
replace order=5 if seven==1 & rank==3
replace order=6 if seven==1 & rank==2
replace order=7 if seven==1 & rank==1





replace order=1 if eight==1 & rank==8
replace order=2 if eight==1 & rank==7
replace order=3 if eight==1 & rank==6
replace order=4 if eight==1 & rank==5
replace order=5 if eight==1 & rank==4
replace order=6 if eight==1 & rank==3
replace order=7 if eight==1 & rank==2
replace order=8 if eight==1 & rank==1

drop one two three four five six seven eight _merge
*********************************************************************************
clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==0

egen rank =rank(age) , by( idmen relation) 




collapse(sum) rank, by(idmen_zd relation)

gen one=0
replace one=1 if  rank==1

gen two=0
replace two=1 if  rank==3

gen three=0
replace three=1 if  rank==6

gen four=0
replace four=1 if  rank==10

gen five=0
replace five=1 if  rank==15

gen six=0
replace six=1 if  rank==21

gen seven=0
replace seven=1 if  rank==28

gen  eight=0
replace eight=1 if  rank==36

drop rank


save "/Volumes/USB20FD/688EPM/q_2.dta", replace

clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"
keep if gender==0


 
egen rank =rank(age) , by( idmen relation) 
joinby(idmen_zd relation) using "/Volumes/USB20FD/688EPM/q_2.dta"

gen order=0
replace order=1 if one==1
replace order=1 if two==1 & rank==2
replace order=1 if three==1 & rank==3
replace order=1 if four==1 & rank==4
replace order=1 if five==1 & rank==5
replace order=1 if six==1 & rank==6
replace order=1 if seven==1 & rank==7
replace order=1 if eight==1 & rank==8
drop one two three four five six seven eight
rename order gorder
gen order=0
save "/Volumes/USB20FD/688EPM/women.dta", replace
append using "/Volumes/USB20FD/688EPM/men.dta"

save "/Volumes/USB20FD/688EPM/q_1.dta", replace

*********************************************************************
clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

gen sun=0
replace sun=1 if relation==3

gen gran=0
replace gran=1 if relation==5

gen sister=0
replace sister=1 if relation==7

gen niece=0
replace niece=1 if relation==9

gen servant=0
replace servant=1 if relation==15
save "/Volumes/USB20FD/688EPM/q_1.dta", replace
clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

gen number=1

collapse(sum) number, by(idmen)



joinby(idmen) using "/Volumes/USB20FD/688EPM/q_1.dta"
save "/Volumes/USB20FD/688EPM/q_1.dta", replace
clear 
use "/Volumes/USB20FD/688EPM/q_1.dta"

gen sibling1=0
replace sibling1=1 if relation==3

gen sibling2=0
replace sibling2=1 if relation==5

gen sibling3=0
replace sibling3=1 if relation==7

gen sibling4=0
replace sibling4=1 if relation==9

gen sibling5=0
replace sibling5=1 if relation==15

collapse(sum) sibling1 sibling2 sibling3 sibling4 sibling5, by(idmen)

joinby(idmen) using "/Volumes/USB20FD/688EPM/q_1.dta"
save "/Volumes/USB20FD/688EPM/q_1.dta", replace

collapse(sum) ychild, by(idmen)
rename ychild yy
joinby(idmen) using "/Volumes/USB20FD/688EPM/q_1.dta"
save "/Volumes/USB20FD/688EPM/q_1.dta", replace

clear 

        use "/Volumes/USB20FD/688EPM/epm2005_sect10.dta"
		rename q01a01 gender
		drop if gender==1
		gen order=0
        replace order=1 if q01a03==3 
        gen notyoung=0
        replace notyoung=1 if order==0
        collapse(sum) order notyoung, by(idmen_zd)
        joinby (idmen_zd) using "/Volumes/USB20FD/688EPM/q_1.dta"
       drop if gender==1
	   
        gen birth_rank=(order/2+0.5)-codeind+notyoung
        keep idind birth_rank
		
        joinby(idind ) using "/Volumes/USB20FD/688EPM/q_1.dta"
        
rename birth_rank bb
save "/Volumes/USB20FD/688EPM/men.dta", replace

clear 

        use "/Volumes/USB20FD/688EPM/epm2005_sect10.dta"
		rename q01a01 gender
		drop if gender==2
		gen order=0
        replace order=1 if q01a03==3 
        gen notyoung=0
        replace notyoung=1 if order==0
        collapse(sum) order notyoung, by(idmen_zd)
        joinby (idmen_zd) using "/Volumes/USB20FD/688EPM/q_1.dta"
       drop if gender==0
	   
        gen birth_rank=(order/2+0.5)-codeind+notyoung
        keep idind birth_rank
		
        joinby(idind ) using "/Volumes/USB20FD/688EPM/q_1.dta"
        
rename birth_rank gb

append using "/Volumes/USB20FD/688EPM/men.dta"

replace gb=0 if gb==.
replace bb=0 if bb==.		 
	
		gen nonagri=0
		replace nonagri=1 if agri==2
		replace agri=0 if agri==2
		
save "/Volumes/USB20FD/688EPM/q4.dta", replace

clear 
use "/Volumes/USB20FD/688EPM/q_4.dta"

logit   agri urban Fianarantsoa Toamasina Mahajanga Toliara Antsiranana old gender bb gb sun gran sister niece servant   number sibling1  yy

clear 

        use "/Volumes/USB20FD/688EPM/epm2005_sect10.dta"
		rename q01a01 gender
		drop if gender==2
		gen order=0
        replace order=1 if q01a03==3 
        gen notyoung=0
        replace notyoung=1 if order==0
        collapse(sum) order notyoung, by(idmen_zd)
        joinby (idmen_zd) using "/Volumes/USB20FD/688EPM/q_1.dta"
       drop if gender==0
	   
        gen birth_rank=(order/2+0.5)-codeind+notyoung
        keep idind birth_rank
		
        joinby(idind ) using "/Volumes/USB20FD/688EPM/q_1.dta"















joinby(idmen_zd ) using "/Volumes/USB20FD/688EPM/adjust.dta"

save "/Volumes/USB20FD/688EPM/q5.dta", replace





***Expenditures 14 A
	******This part of non-food expenditures is done for you, just run the code
	clear
	set mem 300m
	set matsize 600

	 use "/Volumes/USB20FD/688EPM/Spending14_A.dta"
	
	******Change the "." for missing data to zeros when adding numbers
	recode q14a03  (.=0)
	******note that you have >164,000 observations because the items are "stacked", i.e., each household has 1 observation per item
	***sum by HH ID	
	collapse(sum) q14a03, by(idmen)

	rename q nonfoodA
	
	joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/region.dta"
	***replace 5% +	
	egen p95=pctile(nonfoodA), p(95) by(regu)
	replace nonfoo=p95 if nonf>p95 & nonf~=.
	******52 week annaulizing the data this is the year data*	
	replace nonfoo=nonfoo*52
	keep idmen nonf 
	la var nonf "nonfood annual expenditure from part A"
	save  "/Volumes/USB20FD/688EPM/nonfoodA.dta", replace
	

***Expenditures 14 C  
	***This looks a lot like A, so you can use a similar code.
	***
	clear
	set mem 300m
	use  "/Volumes/USB20FD/688EPM/Spending14_C.dta", clear
		
		joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/region.dta"
	
		recode  q14c_05 q14c_06 (.=0)
	*****Write your code below to finish non-food expenditures from 14 C	
	
	collapse(sum) q14c_05 q14c_06 , by(idmen)

	gen nonfoodC = q14c_05 + q14c_06 
	joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/region.dta"

	egen p95=pctile(nonfoodC), p(95) by(regu)
	replace nonfoo=p95 if nonf>p95 & nonf~=.

	keep idmen nonf
	la var nonf "nonfood annual expenditure from part C"
	save  "/Volumes/USB20FD/688EPM/nonfoodC.dta", replace

	
********Housing 
	******This is done for you, unless you want to try to improve on this
	clear
	use  "/Volumes/USB20FD/688EPM/epm2005_sect7.dta"	
	drop idmen
	rename idmen_zd  idmen
	rename q07_05 numroom
	rename q07_04 typehouse
	rename q07_10 rent
	rename q07_19 wall
	rename q07_20 floor
	rename q07_21 ceiling
	rename q07_23a water
	
	
	xi i.typehouse, noomit pre(d1)
	xi i.wall, noomit pre(d2)
	
	xi i.floor, noomit pre(d3)
	xi i.ceiling, noomit pre(d4)
	xi i.water, noomit pre(d5)
	xi i.region*i.milieu, noomit pre(d6)
	xi i.zd, noomit pre(d7)
	
	drop d2*4 d2*5  d2*4 d2*7 d2*8 d2*11 d3*3 d3*5 d4*6 d1*4
	
	
	
	
	****predict rent
	regress rent numroom d1* d2* d3* d4* d6* if  q07_11 ==2
	predict renthat
	
	gen regurb=region*10+milieu
	
	
	***gen median and 5th and 95th pctile by region/urban-rural
	 egen medianrent=pctile(rent), by(regurb)
	 egen rentp05 =pctile(rent), p(5) by(regurb)
	
	 egen rentp95 =pctile(rent), p(95) by(regurb)
	
	****replace rent with predicted rent if it's outside of bounds
	******replace with median rent if both are outside of bounds
	gen annualrent=rent if rent>rentp05 & rent<rentp95
	replace annual=renthat if renth>rentp05 & renth<rentp95 & ann==.
	replace annual=medianrent if ann==.
	replace ann=ann*12
	rename idmen idmen_zd
	 keep  idmen far region fiv codcom localite menage milieu annualrent regurb
	
	save  "/Volumes/USB20FD/688EPM/housing.dta", replace
	



*******Expend 14 B Food and fuel
	clear
	use  "/Volumes/USB20FD/688EPM/Spending14_B.dta"
	*************This one you need to complete, pay attention to units and prices
	
	recode  q14b_06 q14b_7q q14b_08 (.=0)
	
	rename q14b_06 food
	rename q14b_7q quantity
	rename q14b_7u unit 
	rename q14b_08 gift
	rename q14b_0l fname
	gen foodq=food/quantity
	joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/region.dta"
	keep idmen fname food quantity unit gift foodq regurb

	save  "/Volumes/USB20FD/688EPM/partB.dta", replace


	drop if food==0
      
	collapse(mean) foodq, by(fname)
	rename foodq avgfood
	save  "/Volumes/USB20FD/688EPM/food_price.dta", replace
	
	clear
	use  "/Volumes/USB20FD/688EPM/partB.dta"
	joinby(fname) using  "/Volumes/USB20FD/688EPM/food_price.dta"
	gen food1=foodq*1 
	replace food1=avgfood if food1==0
	gen gift_value=food1*gift
      recode gift_value  (.=0)
	gen afood=food*12
	gen foodfuel=gift_value+afood
	egen p95=pctile(foodfuel), p(95) by(regu)

	replace foodfuel=p95 if foodfuel>p95 &foodfuel~=.
      
	collapse(sum) foodfuel, by(idmen)
	
	save  "/Volumes/USB20FD/688EPM/food_housing.dta", replace



*******Durables  mostly need 5 & 6 for original and current value.
*****q09_03 is # of years
clear 


use  "/Volumes/USB20FD/688EPM/epm2005_sect9.dta"
drop if code_av==142
drop if code_av==143
drop if code_av==144
drop if code_av>170

rename q09_03 age
replace age =50 if age >50 & age~=.
gen  purchaseprice=1000*q09_05 
gen currentvalue=1000*q09_06 

rename code_avoir item
gen regurb=region*10 + milieu
gen itemreg=region*1000+item
gen durval=(purchase-current)/age
egen medianpp=pctile(purchase), by(item)
egen mediancv=pctile(current), by(item)
gen mv=medianpp-mediancv

egen medianval=pctile(durval), by(item)
*****other memeber(not me) in HH own the item, but I don't know the price so use durval 
replace durval=medianval if purchaseprice==. & q09_01==1
replace durval=medianval if current==. & q09_01==1
replace durval=medianval if durval<0 & q09_01==1


egen rentval=pctile(q09_07) if  q09_07>0 &  q09_07~=., by(item)
replace rent=rent*1000*12
egen rentval2=pctile(rentval) , by(item)
replace durval=rentval2 if durval<=0
replace durval=rentval2 if durval==. & q09_01==1


egen p95=pctile(durval), by(item) p(95)
egen p05=pctile(durval), by(item) p(05)
replace durval=p95 if durval>p95  & q09_01==1
replace durval=p05 if durval<p05  & q09_01==1


replace durval=0 if durval==.


collapse (sum) durval, by(idmen_zd)

save  "/Volumes/USB20FD/688EPM/durables.dta", replace


*******autoconsumption
		/* I have done a lot of the work for you here.  I have estimated prices for the goods consumed by the household.
			This is annual consumption.  You have to convert the units to kilos.
		*/
		clear
		
		use  "/Volumes/USB20FD/688EPM/agriBrevised.dta", replace			
		recode q12b03 q12b02b price (.=0)		
		drop idmen
		rename  q12b02b conversion
		rename  q12b03 consump
		gen autocon=price* consump* conversion
		

		
		joinby(idmen) using  "/Volumes/USB20FD/688EPM/region.dta", unmatched(both)
		egen p95=pctile(autocon), p(95) by(regurb)
		replace autocon=p95 if autocon>p95 & autocon~=.
		collapse(sum) autocon, by(idmen)		
		keep idmen autocon

		**************
		save  "/Volumes/USB20FD/688EPM/autocon.dta", replace
		 


**************Add in hh consumption of fish
clear		
use  "/Volumes/USB20FD/688EPM/\fishconsumption.dta"
joinby(idmen) using  "/Volumes/USB20FD/688EPM/agriBrevised.dta",unmatched(both)
recode autoconfish (.=0)
collapse(sum) autoconfish, by(idmen_zd)
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/region.dta",unmatched(both)

egen p95=pctile(autoconfish), p(95) by(regurb)
replace autoconfish=p95 if autoconfish>p95 & autoconfish~=.
collapse(sum) autoconfish, by(idmen_zd)

keep idmen autoconfish
save  "/Volumes/USB20FD/688EPM/autoconfish.dta", replace



**************HOUSEHOLD COMPOSITION
		***Need to figure out adult equivalence
		clear
	
		use  "/Volumes/USB20FD/688EPM/Demographie.dta"
		rename IDMEN idmen
		gen kid = 0
		replace kid=1 if AGE_A <=16
		gen adult = 0
		replace adult = 1 if AGE_A>16
		gen AE = (adult + 0.4*kid)^0.8
		 drop __000000 __000001 __000002 __000003 __000004
		joinby(idmen) using  "/Volumes/USB20FD/688EPM/epm2005_sect7.dta"		
		collapse(sum) AE, by( idmen_zd)

save  "/Volumes/USB20FD/688EPM/AE.dta", replace


**************sum
clear 
use  "/Volumes/USB20FD/688EPM/nonfoodA.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/nonfoodC.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/housing.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/food_housing.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/durables.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/autocon.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/autoconfish.dta"

gen total= nonfoodA+ nonfoodC+ annualrent +foodfuel+ durval+ autocon+ autoconfish
gen totalnon=nonfoodA+ nonfoodC
gen totalfood=foodfuel+autoconfish+autocon
rename annualrent house
rename durval durables
save  "/Volumes/USB20FD/688EPM/total.dta", replace



**************adjust
clear
use  "/Volumes/USB20FD/688EPM/\regional_deflators.dta"
rename prov idmen_zd
save   "/Volumes/USB20FD/688EPM/deflators.dta", replace
clear 
use  "/Volumes/USB20FD/688EPM/total.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/deflators.dta"
joinby(idmen_zd) using  "/Volumes/USB20FD/688EPM/AE.dta"


gen rtotal=total/ regdefl
gen rnon=totalnon/ regdefl
gen rfood=totalfood/ regdefl
gen rhouse=house/ regdefl
gen rdurables=durables/ regdefl


gen rtotalc=rtotal/AE
gen rnonc=rnon/AE
gen rfoodc=rfood/AE
gen rhousec=rhouse/AE
gen rdurablesc=rdurables/AE
gen poor=0
replace poor=1 if rtotalc<=300000
save  "/Volumes/USB20FD/688EPM/adjust.dta", replace

******* Lorenz curve
gen diag=0
replace diag= milieu if  milieu==1

glcurve  rtotalc if milieu==1, gl(gl_urban) p(p_urban) lorenz nograph
glcurve  rtotalc if milieu==2, gl(gl_rural) p(p_rural) lorenz nograph
label variable diag "compare"
la variable  gl_urban "Lorenz(urban)"
la variable   gl_rural "Lorenz(rural)"
twoway (line gl_urban p_urban, sort) (line gl_rural p_rural, sort) (line diag diag)


******* poverty index
clear
use  "/Volumes/USB20FD/688EPM/\adjust.dta"

levels  milieu, local( milieu)
ge fgt0_reg = .
ge fgt1_reg = .

foreach 1 of local reg{
povdeco rtotalc if  milieu == `1', pline(300000)
  replace fgt0_reg = $FGT0 if  milieu == `1'
  replace fgt1_reg = $FGT1 if  milieu == `1'
  }

povdeco rtotalc, pline(300000) by(milieu) 

clear
use  "/Volumes/USB20FD/688EPM/\adjust.dta"
drop if  milieu==1
levels  milieu, local( milieu)
ge fgt0_reg = .
ge fgt1_reg = .



foreach 2 of local reg {
  povdeco rtotalc if  milieu == `2', pline(300000)
  replace fgt0_reg = $FGT0 if  milieu == `2'
  replace fgt1_reg = $FGT1 if  milieu == `2'
}


povdeco rtotalc, pline(300000) by(milieu)

******* CDF
clear
use  "/Volumes/USB20FD/688EPM/\adjust.dta"


 cumul rtotalc if milieu==1, gen(curban)
 cumul rtotalc if milieu==2 , gen(crural)
 stack curban rtotalc crural rtotalc, into(c expenditure) wide clear
        line curban crural expenditure, sort

******* gini

clear
use  "/Volumes/USB20FD/688EPM/\adjust.dta"

 fastgini rtotalc if milieu==1
 fastgini rtotalc if milieu==2
 fastgini rtotalc 

