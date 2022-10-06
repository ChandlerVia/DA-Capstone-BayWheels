proc import datafile="~/MIS581 - Capstone/Data/202108-baywheels-tripdata.csv" 
	out=AUG2021 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202109-baywheels-tripdata.csv" 
	out=SEP2021 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202110-baywheels-tripdata.csv" 
	out=OCT2021 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202111-baywheels-tripdata.csv" 
	out=NOV2021 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202112-baywheels-tripdata.csv" 
	out=DEC2021 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202201-baywheels-tripdata.csv" 
	out=JAN2022 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202202-baywheels-tripdata.csv" 
	out=FEB2022 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202203-baywheels-tripdata.csv" 
	out=MAR2022 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202204-baywheels-tripdata.csv" 
	out=APR2022 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202205-baywheels-tripdata.csv" 
	out=MAY2022 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202206-baywheels-tripdata.csv" 
	out=JUN2022 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/202207-baywheels-tripdata.csv" 
	out=JUL2022 dbms=csv replace;
run;
proc import datafile="~/MIS581 - Capstone/Data/BayWheels-Stations-clustered.csv" 
	out=BayWheelsStations dbms=csv replace;
run;


data Combined;
   set AUG2021 SEP2021 OCT2021 NOV2021 DEC2021 JAN2022 FEB2022 MAR2022 APR2022 MAY2022 JUN2022 JUL2022;
   started_at_date=datepart(started_at);
   format started_at_date mmddyy10.
run;

proc print data=Combined (obs=5);
run;

proc contents data=Combined;
run;

proc freq data=Combined;
	table member_casual start_station_name;
run;

proc sql;
   create table 
          StartAgg as
      select started_at_date,
        count(*) as N
    from Combined
    group by started_at_date;
quit;

data StartAgg;
	set StartAgg;
run;

proc reg data=StartAgg;
	model N = started_at_date;
run;

proc anova data=BayWheelsStations;
	title ANOVA Test for Frequency by Cluster group;
	class cluster;
	model freq = cluster;
	means cluster /hovtest;
run;

proc univariate data=BayWheelsStations normal plot;
	var AvgDailyUse;
run;
	
proc anova data=BayWheelsStations;
	title ANOVA Test for Frequency by Cluster group;
	class cluster;
	model AvgDailyUse = cluster;
	means cluster /hovtest;
run;