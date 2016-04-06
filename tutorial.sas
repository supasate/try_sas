libname outlib "/folders/myshortcuts/sas_tutorial/lib/outlib";

data outlib.employee;
	length FirstName $ 12 LastName $ 18 JobTitle $ 25;
	infile "/folders/myshortcuts/sas_tutorial/employee.csv" dlm=",";
	input FirstName $ LastName $ JobTitle $ Salary Country $;
	datalines;
Toriyama Akira Writer 50000 JP
;
run;

proc print data=work.employee;
run;

proc means data=work.employee;
	var Salary;
run;

proc contents data=work.employee;
run;

* Add data to permantent library;
data outlib.country;
	CountryName='TH';
run;

* Add summation row;
proc print data=work.employee;
	var FirstName LastName Salary;
	sum Salary;
run;

* Filtering data;
proc print data=work.employee;
	var FirstName LastName JobTitle Salary;
	where Salary <= 20000 and JobTitle in ('Programmer', 'Student');
	sum Salary;
run;

* Sorting data;
proc sort data=work.employee out=work.sorted;
	by descending Salary JobTitle;
run;

* 'by' can be used 'proc print';
proc print data=work.employee;
	by Salary;
run;

* Formatting values;
proc print data=work.employee;
	format Salary dollar8.;
	var FirstName LastName Salary;
run;

* User-defined format;
* Define string format;
proc format;
	value $ctryfmt 	'TH' = 'Thailand'
					'US' = 'United States'
					other = 'Miscoded';
run;
proc print data=work.employee;
	format Country $ctryfmt.;
	var FirstName LastName Country;
run;

* Define numerical range format;
proc format;
	value tiers low-10000 = 'Tier 1'
				10000<-20000 = 'Tier 2'
				20000<-high = 'Tier 3';
run;
proc print data=work.employee;
	format Salary tiers.;
	var FirstName LastName Salary;
run;

* Make a subset;
data work.subset1;
	set outlib.employee;
	where Salary > 15000;
	Bonus = Salary * .10;
	drop Country;
run;

* 'where' is used in copying data in;
* 'if' is used in processing data out;
data work.subset2;
	set outlib.employee;
	Bonus = Salary * .10;
	keep FirstName LastName Salary Bonus;
	if Bonus >= 2000;
run;

data work.subset3;
	set outlib.employee;
	label JobTitle = 'Occupation';
	keep FirstName LastName JobTitle;
run;

* Conditional;
data work.employee;
	set outlib.employee;
	Country = upcase(Country);
	if Country = 'US' then
		Bonus = 1000;
	else if Country = 'TH' then
		do;
			Bonus = 500;
			ExtraBonus = 200;
		end;
	else
		Bonus = 0;
	keep FirstName LastName Salary Bonus ExtraBonus Country;
run;

* Concat data;
data outlib.newemployee;
	length FirstName $ 12 LastName $ 18 JobTitle $ 25;
	infile "/folders/myshortcuts/sas_tutorial/newemployee.csv" dlm=",";
	input FirstName $ LastName $ JobTitle $ Salary Country $;
run;	

data work.employee;
	set outlib.employee outlib.newemployee;
run;

* Rename column;
data outlib.newemployee;
	length FirstName $ 12 LastName $ 18 Position $ 25;
	infile "/folders/myshortcuts/sas_tutorial/newemployee.csv" dlm=",";
	input FirstName $ LastName $ Position $ Salary Country $;
run;	

data work.employee;
	set outlib.employee outlib.newemployee(rename=(Position=JobTitle));
run;

* merge;
* the key to be merged must be sorted first;
data outlib.color;
	infile "/folders/myshortcuts/sas_tutorial/color.csv" dlm=",";
	input FirstName $ LastName $ Color $;
	by FirstName;
run;

proc sort data=outlib.employee out=work.employee;
	by FirstName;
run;

proc sort data=outlib.color out=work.color;
	by FirstName;
run;

data work.merged;
	merge work.employee work.color;
	by FirstName;
run;

* Freq;
proc freq data=outlib.employee;
	tables Salary Country;
run;

proc freq data=outlib.employee;
	tables Salary;
	by Country;
run;

proc freq data=outlib.employee;
	tables Salary*Country;
run;

proc freq data=outlib.employee;
	tables Salary*Country / list;
run;

proc freq data=outlib.employee;
	tables Salary*Country / nocum nopercent nocol norow;
run;

proc freq data=outlib.employee nlevels;
	tables Salary*Country / nocum nopercent nocol norow;
run;

* Mean;
proc means data=outlib.employee;
	var salary;
run;

proc means data=outlib.employee n mean;
	var salary;
run;

proc means data=outlib.employee nmiss min max sum;
	var salary;
	class Country Salary;
run;

* Univariate;
proc univariate data=outlib.employee;
	var Salary;
run;



