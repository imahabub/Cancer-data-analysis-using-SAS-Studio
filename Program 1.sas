
proc import datafile="/home/u64037756/BMI_Data/The_Cancer_data_1500_V2.csv"
    out=cancer_data
    dbms=csv
    replace;
    getnames=yes;
run;


proc means data=cancer_data mean std min max n;
    var Age BMI PhysicalActivity AlcoholIntake;
run;

proc freq data=cancer_data;
    tables Gender Smoking GeneticRisk CancerHistory Diagnosis;
run;

proc univariate data=cancer_data;
    var Age BMI PhysicalActivity AlcoholIntake;
    histogram Age BMI PhysicalActivity AlcoholIntake / normal;
run;



proc corr data=cancer_data;
    var BMI PhysicalActivity;
run;


proc ttest data=cancer_data;
    class Diagnosis;
    var PhysicalActivity;
run;




data cancer_data;
    set cancer_data;
    if BMI < 18.5 then BMI_Category = 'Underweight';
    else if BMI < 25 then BMI_Category = 'Normal';
    else if BMI < 30 then BMI_Category = 'Overweight';
    else BMI_Category = 'Obese';
run;


proc anova data=cancer_data;
    where Diagnosis = 1;
    class BMI_Category;
    model PhysicalActivity = BMI_Category;
run;


proc sgplot data=cancer_data;
    scatter x=BMI y=PhysicalActivity / group=Diagnosis;
    xaxis label="BMI";
    yaxis label="Physical Activity";
    title "Scatter Plot of BMI vs Physical Activity by Diagnosis";
run;


proc sgplot data=cancer_data;
    vbox PhysicalActivity / category=Diagnosis;
    xaxis label="Diagnosis (0 = Non-cancer, 1 = Cancer)";
    yaxis label="Physical Activity";
    title "Box Plot of Physical Activity by Cancer Diagnosis";
run;


proc sgplot data=cancer_data;
    vbar BMI_Category / group=Diagnosis groupdisplay=cluster;
    xaxis label="BMI Category";
    yaxis label="Frequency";
    title "BMI Categories by Cancer Diagnosis";
run;

