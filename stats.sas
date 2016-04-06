libname statslib "/folders/myshortcuts/sas_tutorial/lib/statslib";

data statslib.score;
	infile "/folders/myshortcuts/sas_tutorial/score.csv" dlm=",";
	input Gender $ Score Id;
run;

proc univariate data=statslib.score;
	var Score;
	histogram Score / normal(mu=est sigma=est) kernel;
	inset skewness kurtosis / position=ne;
	probplot Score / normal(mu=est sigma=est);
	inset skewness kurtosis;
	title 'Descriptive Statistics Using PROC UNIVARIATE';
run;

* not done;
proc sgplot date=statslib.score;
	vbox Score / datalabel=Id;
	
run;

proc means data=statslib.score maxdec=2 n mean std sterr clm;
	var Score;
	title '95% Confidence INterval fo SAT Score';
run;

proc ttest data=statslib.score h0=1200
			plots(shownull)=interval;
	var Score;
	title 'Testing whether the mean of Scores = 1200 '
			'Using PROC TTEST';
run;

*two sample t-test;
proc ttest data=statslib.score plots(shownull)=interval;
	class Gender;
	var Score;
	title 'TwoSample t-test Compoaring Girls to Boys';
run;

data data statslib.garlic;
	infile "/folders/myshortcuts/sas_tutorial/garlic.csv" dlm=",";
	input Fertilizer BulbWeight Cloves BedID $;
run;

proc glm data=statslib.garlic;
	class Fertilizer;
	model BulbWeight = Fertilizer;
	title ' Testing for Equality of Means with PROC GLM';
run;