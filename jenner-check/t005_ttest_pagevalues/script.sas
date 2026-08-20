/*Sample of the repo's online_shoppers_intention.csv, inlined so the bundle
  is self-contained (the shipped runner uploads only script.sas + autoexec.sas,
  no sibling data files). Column order and names match the source CSV exactly;
  original PROC IMPORT is replaced with an equivalent DATA step read.*/
data online_shoppers;
  infile datalines dsd dlm=' ' truncover;
  input Administrative Administrative_Duration Informational Informational_Duration
        ProductRelated ProductRelated_Duration BounceRates ExitRates PageValues SpecialDay
        Month $ OperatingSystems Browser Region TrafficType VisitorType $ Weekend $ Revenue $;
  datalines;
1 29.5 0 0 29 569.1666667 0 0.01957672 12.455 0 May 2 2 3 2 Returning_Visitor FALSE TRUE
15 937.1746032 3 357 109 6682.677557 0.000833333 0.005345441 2.526616865 0 Mar 1 2 3 2 Returning_Visitor FALSE FALSE
26 1561.717567 9 503.7222222 183 9676.09318 0.011054834 0.014200442 19.56746389 0 Nov 3 2 2 13 Returning_Visitor FALSE TRUE
5 85.5 0 0 30 2188.258333 0 0.0078125 45.58268367 0 Nov 2 2 2 8 New_Visitor TRUE TRUE
0 0 0 0 5 143 0 0.04 0 0 Mar 2 4 1 1 Returning_Visitor FALSE FALSE
0 0 0 0 12 315.7797619 0.016666667 0.025 0 0 Nov 1 1 9 2 Returning_Visitor TRUE FALSE
2 57.5 0 0 16 1226 0 0.0125 143.4766783 0 Dec 2 2 9 2 New_Visitor TRUE TRUE
7 70 4 35 131 4442.394444 0.011678832 0.014283502 0 0 Nov 4 1 1 2 Returning_Visitor TRUE FALSE
2 30.5 2 18 15 1518.097619 0 0.031764706 31.75764706 0 May 2 2 8 2 Returning_Visitor FALSE TRUE
0 0 0 0 23 566.8 0 0.007971014 0 0 Nov 3 2 1 13 Returning_Visitor FALSE FALSE
9 181.375 0 0 116 4426.650649 0 0.008064516 84.30663844 0 May 2 2 2 6 Returning_Visitor TRUE TRUE
0 0 0 0 4 49.5 0.05 0.075 0 0 Mar 3 2 1 1 Returning_Visitor FALSE FALSE
0 0 0 0 2 28 0 0.1 0 0 May 2 2 1 3 Returning_Visitor FALSE FALSE
4 60 3 37.83333333 21 868.0166667 0 0.008 40.72562976 0 Dec 1 1 1 2 New_Visitor FALSE TRUE
0 0 0 0 2 30.5 0 0.05 0 0 Mar 3 2 4 10 Returning_Visitor FALSE FALSE
0 0 0 0 3 61.5 0.066666667 0.1 0 0 Dec 3 2 3 8 New_Visitor FALSE FALSE
0 0 1 19 10 852 0 0.009090909 0 0 Feb 2 2 3 6 Returning_Visitor FALSE FALSE
2 112.25 0 0 9 97.41666667 0.018181818 0.036363636 0 0 Dec 3 2 3 2 New_Visitor FALSE FALSE
1 26.2 1 6 28 677.5333333 0 0.019472789 0 0 Jul 1 1 6 1 Returning_Visitor TRUE TRUE
0 0 0 0 3 96.5 0 0.022222222 0 0 Mar 1 1 1 3 Returning_Visitor TRUE FALSE
2 151 0 0 19 716.3571429 0.004761905 0.015873016 10.8692605 0 Mar 1 1 7 1 Returning_Visitor TRUE TRUE
11 202.4254386 5 1767.666667 338 13265.35595 0.007520348 0.018855633 1.114150182 0 Nov 2 2 3 2 Returning_Visitor FALSE TRUE
0 0 2 485.8333333 89 3747.814286 0.013636364 0.030211039 0 0 Nov 1 1 1 2 Returning_Visitor TRUE TRUE
10 81.36666667 0 0 7 35.16666667 0 0.006060606 0 0 Nov 2 7 8 3 Returning_Visitor FALSE FALSE
0 0 0 0 4 1111 0 0.05 0 0 Mar 4 5 1 1 Returning_Visitor FALSE FALSE
0 0 0 0 1 0 0.2 0.2 0 0.6 May 2 2 1 1 Returning_Visitor FALSE FALSE
0 0 0 0 20 528 0 0.0075 31.1904 0.6 May 2 2 1 4 New_Visitor FALSE TRUE
7 187.1666667 2 72 22 680 0 0.006190476 22.45821429 0 May 3 2 3 2 New_Visitor FALSE TRUE
2 59.4 0 0 86 3334.506667 0.025581395 0.050387597 0 0 Aug 2 2 7 3 Returning_Visitor FALSE FALSE
3 59 0 0 10 269 0 0.018181818 50.388 0 May 1 1 1 5 New_Visitor TRUE TRUE
0 0 0 0 2 20 0 0.05 0 0 May 4 5 1 13 Returning_Visitor FALSE FALSE
0 0 0 0 3 77 0 0.066666667 0 0 Mar 3 6 1 9 Returning_Visitor TRUE FALSE
7 272.0333333 0 0 13 295.1 0.011764706 0.017647059 0 0 Nov 3 2 1 20 Returning_Visitor FALSE FALSE
3 86.95 6 173.2 17 481.31 0 0 27.69500776 0 Nov 2 2 9 20 New_Visitor FALSE TRUE
5 75 0 0 31 1066 0 0.014285714 0 0 May 2 2 1 6 Returning_Visitor FALSE FALSE
;
run;

/*Checking the relationship between target variable and other numerical variables*/
title 'PageValues Vs Revenue';
proc ttest data=online_shoppers;
class Revenue;
var PageValues;
run;

title 'ProductRelated Vs Revenue';
proc ttest data=online_shoppers;
class Revenue;
var ProductRelated;
run;

title 'ExitRates Vs Revenue';
proc ttest data=online_shoppers;
class Revenue;
var ExitRates;
run;
