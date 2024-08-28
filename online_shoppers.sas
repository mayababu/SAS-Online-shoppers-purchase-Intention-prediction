/*Business Problem : To predict whether or not a visitor will make a purchase from the
                     clickstream and session data of the user who visits an e-commerce website.
					 The main focus of this project is to apply Machine Learning classification model to 
					 an online shopper purchasing Intention dataset*/

/*Dataset : The dataset used in this analysis is obtained from the UC Irvine Machine Learning Repository.
			Each row in the dataset contains data corresponding to a visit “session” (period of time spent) of a user 
			on an e-commerce website. The dataset was specifically formed so that each session would belong to a unique 
			user over a 1-year period. The total number of sessions in the dataset is 12,330.*/

/*Importing the dataset online_shoppers_intention.csv*/
proc import datafile="D:\DSA Course\SAS Project\Project\online_shoppers_intention.csv"
    out=online_shoppers
    dbms=csv
    replace;
	getnames=yes;
run;

/*Viewing the first 10 observations of the dataset*/
proc print data=online_shoppers (obs=10);
run;

/*Features : The features included in the dataset belongs to following categories:
	- Duration (time) spent on Administrative, Informational, or Product related sections of the website.
	- Data from Google Analytics such as bounce rate, exit rate, and page value.
	- What month the session took place it, and whether or not the day of the session falls on a weekend.
	- The operating system and browser used by the website visitor. */

/*The dataset consists of 10 numerical and 8 categorical attributes.*/

/*Browsing the descriptor portion of the dataset*/
proc contents data=online_shoppers;
run;

/* Here is a brief explanation of each variable in the Online Shoppers Purchasing Intention Dataset:

Administrative: Represents the number of pages visited by the user in the "Administrative" category (such as the website's about us, contact us, and legal pages).
Administrative_Duration: Represents the total time spent by the user on pages in the "Administrative" category during the session.
Informational: Represents the number of pages visited by the user in the "Informational" category (such as the website's FAQ, terms of service, and privacy policy pages).
Informational_Duration: Represents the total time spent by the user on pages in the "Informational" category during the session.
ProductRelated: Represents the number of pages visited by the user in the "Product Related" category (such as product pages, product categories, and the shopping cart).
ProductRelated_Duration: Represents the total time spent by the user on pages in the "Product Related" category during the session.
BounceRates: Represents the percentage of visits in which the user entered the website and left without interacting with any of the pages on the site.
ExitRates: Represents the percentage of visits to a particular page that were the last in the session.
PageValues: Represents the average value of the pages visited by the user before completing an e-commerce transaction.
SpecialDay: Represents the closeness of the session visit time to a specific special day, such as Valentine's Day or Mother's Day.
Month: Represents the month of the year in which the session took place.
OperatingSystems: Represents the operating system used by the user's device during the session.
Browser: Represents the browser used by the user during the session.
Region: Represents the geographic region from which the user accessed the website.
TrafficType: Represents the type of traffic source that led the user to the website (such as search engines, social media, or direct traffic).
VisitorType: Represents whether the user is a new or returning visitor to the website.
Weekend: A binary variable that indicates whether the session took place on a weekend or not.
Revenue: A binary variable indicating whether a transaction was made. "TRUE" means that a transaction was made, while "FALSE" means that a transaction was not made.
*/

/* Basic descriptive analysis */

/* Checking NUll Values */
proc means data=online_shoppers nmiss n; 
run; 

/*No missing values in the dataset...Checking for duplicate values*/
title "Checking for duplicate values";
proc sort data = online_shoppers nodupkey out=online_shoppers_data;
by _all_;
run;
/*125 observations with duplicate key values were deleted.
The data set WORK.ONLINE_SHOPPERS_DATA has 12205 observations and 18 variables.*/


/*Describing the numerical/continuous variables from the dataset - summary statistics*/
proc means data = online_shoppers_data maxdec=2 n min Q1 Median Q3 max mean var std cv qrange clm stderr;
var administrative administrative_duration informational informational_duration productrelated productrelated_duration bouncerates exitrates pagevalues specialday;
run;


*****Univariate analysis for Discrete/Categorical variables;

/*Using PROC FREQ to calculate frequency tables for the categorical variables.*/
title "Analysis of discrete/categorical Variables";
proc freq data = online_shoppers_data; 
table month visitorType weekend revenue operatingsystems browser region traffictype /missing;
run;

title "Revenue Distribution";
proc gchart data=online_shoppers_data;
pie revenue / value=inside percent=outside;
run;

title "TrafficType Distribution";
proc sgplot data=online_shoppers_data;
vbox traffictype;
run;

title "Browser Distribution";
proc sgplot data=online_shoppers_data;
vbar browser;
run;

title "Region Distribution";
proc sgplot data=online_shoppers_data;
vbar region;
run;

title "Operating Systems Distribution";
proc sgplot data=online_shoppers_data;
vbar operatingsystems;
run;

title "Month Distribution";
proc sgplot data=online_shoppers_data;
vbar month ;
run;

title "Visitor Type Distribution";
proc sgplot data=online_shoppers_data;
vbar visitorType;
run;

title "Weekend Distribution";
proc gchart data=online_shoppers_data;
pie weekend / value=inside percent=outside;
run;

/*Reducing the number of categories for operating systems by combining 5,6,7,and 8 into one category named 0*/
data online_shoppers1;
set online_shoppers_data;
if operatingsystems in (5,6,7,8) then operatingsystems=0;
run;

title "Operating Systems Distribution after combining categories";
proc sgplot data=online_shoppers1;
vbar operatingsystems;
run;

/*Reducing the number of categories of browser from 13 to 7 by combining 3,7,8,9,11,12 and 13 into one category named 0*/
data online_shoppers1;
set online_shoppers1;
if browser in (3,7,8,9,11,12,13) then browser=0;
run;

title "Browser Distribution after combining categories";
proc sgplot data=online_shoppers1;
vbar browser;
run;

/*Reducing the number of categories of TrafficType from 20 to 10 by combining 7,9,11,12,14,15,16,17,18,19 and 20
  into one category named 0 which represents others category*/
data online_shoppers1;
set online_shoppers1;
if traffictype in (7,9,11,12,14,15,16,17,18,19,20) then traffictype=0;
run;

title "Browser Distribution after combining categories";
proc sgplot data=online_shoppers1;
vbar traffictype;
run;

/*Converting months into quarters to reduce the categories */
data online_shoppers2(drop=month);
set online_shoppers1;
length quarter $3. ;
if month in ('Jan','Feb','Mar') then quarter='Q1';
	else if month in ('Apr','May','Jun') then quarter='Q2';
	else if month in ('Jul','Aug','Sep') then quarter='Q3';
	else quarter='Q4';
run;

title "Month Distribution after converting to quarters";
proc sgplot data=online_shoppers2;
vbar quarter;
run;

/*viewing the dataset after combining the categories and adding the quarter column*/
proc print data=online_shoppers2 (obs=10);
run;

/*frequency table for the categorical variables after making the changes*/
proc freq data = online_shoppers2; 
table quarter visitorType weekend revenue operatingsystems browser region traffictype;
run;

/*************** Histograms - univariate analysis for numerical variables */
title "Univariate analysis for numerical variables";
proc univariate data=online_shoppers2;
var Administrative Administrative_Duration Informational Informational_Duration ProductRelated ProductRelated_Duration BounceRates ExitRates PageValues specialday;
histogram / normal;
run;

/* Binning into 2 quantiles - SpecialDay */
proc rank data=online_shoppers2 out=online_shoppers_binned groups=2;
   var SpecialDay;
   ranks Binned_SpecialDay;
run;

/* Print the binned data */
proc freq data=online_shoppers_binned;
table binned_specialday;
run;

/*Handling Outliers*/

title "Box plot for Informational_Duration";
proc sgplot data=online_shoppers_binned;
hbox informational_duration;
run; 

proc univariate data=online_shoppers_binned noprint;
   var informational_duration;
   output out=percentiles pctlpts=5 95 pctlpre=P_;
run;
data _null_;
   set percentiles;
   call symputx('lower_threshold', P_5);
   call symputx('upper_threshold', P_95);
run;
data online_shoppers_capped;
   set online_shoppers_binned;
   if informational_duration < &lower_threshold then informational_duration = &lower_threshold;
   if informational_duration > &upper_threshold then informational_duration = &upper_threshold;
run;

title "Box plot for Informational_Duration after capping";
proc sgplot data=online_shoppers_capped;
hbox informational_duration;
run; 

title "Box plot for Administrative_Duration";
proc sgplot data=online_shoppers_capped;
hbox administrative_duration;
run; 

proc univariate data=online_shoppers_capped noprint;
   var administrative_duration;
   output out=percentiles pctlpts=5 95 pctlpre=P_;
run;
data _null_;
   set percentiles;
   call symputx('lower_threshold', P_5);
   call symputx('upper_threshold', P_95);
run;
data online_shoppers_capped;
   set online_shoppers_capped;
   if administrative_duration < &lower_threshold then administrative_duration = &lower_threshold;
   if administrative_duration > &upper_threshold then administrative_duration = &upper_threshold;
  
run;

title "Box plot for Administrative_Duration after capping";
proc sgplot data=online_shoppers_capped;
hbox administrative_duration;
run; 


title "Box plot for PageValues";
proc sgplot data=online_shoppers_capped;
hbox pagevalues;
run; 

proc univariate data=online_shoppers_capped noprint;
   var pagevalues;
   output out=percentiles pctlpts=5 95 pctlpre=P_;
run;
data _null_;
   set percentiles;
   call symputx('lower_threshold', P_5);
   call symputx('upper_threshold', P_95);
run;
data online_shoppers_capped;
   set online_shoppers_capped;
   if pagevalues < &lower_threshold then pagevalues = &lower_threshold;
   if pagevalues > &upper_threshold then pagevalues = &upper_threshold;
run;

title "Box plot for PageValues after capping";
proc sgplot data=online_shoppers_capped;
hbox pagevalues;
run; 

**************Bivariate Analysis of Categorical variables;

/*Run a chi-square test for the categorical variable Quarter and its association with Revenue*/
title "Bivariate analysis - Quarter Vs Revenue";
PROC FREQ DATA=online_shoppers2;
  TABLE Quarter*Revenue / CHISQ;
RUN;

proc sgplot data = online_shoppers2;
vbar quarter /group = revenue groupdisplay = cluster;
title 'Quarter Vs Revenue';
run;

/*Run a chi-square test for the categorical variable VisitorType and its association with Revenue*/
title "Bivariate analysis - VisitorType Vs Revenue";
PROC FREQ DATA=online_shoppers2;
    TABLE VisitorType*Revenue / CHISQ;
RUN;

proc sgplot data = online_shoppers2;
vbar visitortype /group = revenue groupdisplay = cluster;
title 'VisitorType Vs Revenue';
run;

/*Checking the relationship between target variable and other categorical variables*/
PROC FREQ DATA=online_shoppers2;
    TABLE Revenue*(weekend operatingsystems browser region traffictype) / CHISQ;
RUN;

/*Plots*/
title 'Weekend Vs Revenue';
proc sgplot data = online_shoppers2;
vbar weekend /group = revenue groupdisplay = cluster;
run;

title 'Region Vs Revenue';
proc sgplot data = online_shoppers2;
vbar region /group = revenue;
run;

title 'TrafficType Vs Revenue';
proc sgplot data = online_shoppers2;
vbar traffictype /group = revenue;
run;

title 'Browser Vs Revenue';
proc sgplot data = online_shoppers2;
vbar browser /group = revenue groupdisplay = cluster;
run;

title 'OperatingSystem Vs Revenue';
proc sgplot data = online_shoppers2;
vbar operatingsystems /group = revenue groupdisplay = cluster;
run;

/*Run a chi-square test for the association between two other categorical variables, Region and VisitorType*/
PROC FREQ DATA=online_shoppers;
  TABLES Region*VisitorType / CHISQ;
RUN;

title 'Region Vs VisitorType';
proc sgplot data = online_shoppers2;
vbar Region /group = VisitorType;
run;

**************Bivariate Analysis of Numerical variables;

/* Scatterplot matrix for numerical variables */
title "Scatterplot matrix for numerical variables";
PROC SGSCATTER DATA=online_shoppers2;
MATRIX
  Administrative
  Administrative_Duration
  Informational
  Informational_Duration
  ProductRelated
  ProductRelated_Duration
  BounceRates 
  ExitRates
  PageValues
  / GROUP=Revenue;
RUN;


/*Correlation matrix*/
title "Correlation Matrix";
proc corr data=online_shoppers2 outp=corr_matrix;
var Administrative Administrative_Duration Informational Informational_Duration ProductRelated ProductRelated_Duration BounceRates ExitRates PageValues SpecialDay OperatingSystems Browser Region TrafficType;
run;

/* Find variables with correlation greater than 0.8 */
data corr_subset;
set corr_matrix;
array corr{*} Administrative--TrafficType;
do i=1 to dim(corr);
    if corr[i] < 0.7 then corr[i] = .;
end;
drop i;
run;

title "Variables with correlation greater than 0.8";
proc print data=corr_subset;
run;
/*From the result we can see that ProductRelated and ProductRelated_Duration are highly correlated;
/*Also ExitRates and BounceRates are highly correlated;
/*So from the first pair we will remove ProductRelated_Duration, and BounceRates from the second pair when we do modeling*/

/*Checking the relationship between target variable and other numerical variables*/

title 'PageValues Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var PageValues;
run;

title 'ProductRelated Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var ProductRelated;
run;

title 'ProductRelated_Duration Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var ProductRelated_Duration;
run;

title 'ExitRates Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var ExitRates;
run;

title 'BounceRates Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var BounceRates;
run;

title 'Administrative Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var Administrative_Duration;
run;

title 'Administrative_Duration Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var Administrative_Duration;
run;

title 'Informational_Duration Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var Informational_Duration;
run;

title 'Informational Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var Informational;
run;

title 'SpecialDay Vs Revenue';
proc ttest data=online_shoppers2;
class Revenue;
var SpecialDay;
run;

**************Log transformation***********************;

data online_shoppers_transformed(drop = ExitRates);
set online_shoppers_capped;
logExitRates=log(ExitRates+1);
run;

/*Plotting after transformation*/
proc sgplot data=online_shoppers_transformed;
   histogram logExitRates / fillattrs=(color=blue transparency=0.5);
   density logExitRates / type=kernel;
run;


data online_shoppers_transformed(drop = ProductRelated_Duration);
set online_shoppers_transformed;
logProductRelated_Duration=log(ProductRelated_Duration);
run;

/*Plotting after transformation*/
proc sgplot data=online_shoppers_transformed;
   histogram logProductRelated_Duration / fillattrs=(color=blue transparency=0.5);
   density logProductRelated_Duration / type=kernel;
run;

proc print data=online_shoppers_transformed(obs=10);
run;


**************PREDICTIVE MODELLING***********************;


/*Handling target variable imbalanace*/
proc sort data=online_shoppers_transformed;by revenue;run;
proc surveyselect data=online_shoppers1 out=online_shoppers_balanced method=urs sampsize=(1908 10297);
strata revenue;
run;


proc freq data=online_shoppers_balanced;
table revenue/missing;
run;

*****LOGISTIC REGRESSION*****;

ods html;
ods graphics on; 
proc logistic data=online_shoppers_balanced plots(only)=(effect oddsratio); 
class  visitortype(ref="Returning_Visitor") weekend quarter /param=ref;
model revenue(event="TRUE")= visitortype weekend quarter browser traffictype region operatingsystems Administrative 
							 Administrative_Duration Informational Informational_Duration ProductRelated logExitRates 
							 PageValues Binned_SpecialDay / details lackfit expb; 
output out=pred p=phat lower=lcl upper=ucl predprob=(individual crossvalidate);
ods output Association=Association; 
run; 
quit;
ods graphics off;

/* Splitting dataset into training and testing sets*/
ods html;
proc surveyselect data=online_shoppers_balanced rate=0.70 outall out=result seed=12345; 
run;
data traindata testdata;
set result;
if selected=1 then output traindata;
else output testdata;
run;

/* Training the model*/
ods graphics on; 
proc logistic data=traindata plots=(ROC ) ; 
class   VisitorType Quarter weekend /param=ref ;
model revenue(event="TRUE")= visitortype weekend quarter region browser traffictype operatingsystems Administrative 
							 Administrative_Duration Informational Informational_Duration ProductRelated LogExitRates 
							 PageValues Binned_SpecialDay / details lackfit; 
score data=testdata out=testpred outroc=vroc;
roc; roccontrast;
output out=outputedata p=prob_predicted xbeta=linpred;
run; 
quit;
ods graphics off;

proc print data=testpred(obs=10);
run;

/* Creating Confusion matrix*/
proc sort data=testpred;
by descending revenue;
run;
ods html style= journal;
proc freq data=testpred  order=data;
table F_revenue*I_revenue / out=CellCounts;
run;
data CellCounts;
set CellCounts;
Match=0;
if F_revenue=I_revenue  then Match=1;
run;
proc means data=CellCounts mean;
freq count;
var Match;
run;
quit;
ods html close;

/* Calculating Sensitivity*/
ods html style=journal;
ods select all;
proc sort data=freq;
by descending I_revenue descending  F_revenue ;
run;
proc sort data=testpred;
by descending I_revenue descending  F_revenue ;
run;

proc freq data=testpred order=data;
tables  F_revenue*I_revenue / senspec;
run;
ods html close;

