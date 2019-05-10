* Use a libname statement to set the output library to a folder;
libname dataout '/home/jarhoads0/DA580CapstoneRawData';

* Use a data step to copy the SAS dataset to the name telco_churn;
data dataout.telco_churn;
    set work.churn_data;
run;