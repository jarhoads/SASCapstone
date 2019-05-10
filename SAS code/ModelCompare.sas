/*
 * Used for DA580 Capstone Project 2019
 * Description: The following SAS program is used to create a cumulative lift report to 
 *              compare predictive models created in SAS Enterprise Miner.
 */

%macro lifts(modeln=);
data train(rename=(liftc=liftc_train capc=capc_train))
     validate(rename=(liftc=liftc_valid capc=capc_valid))
     test(rename=(liftc=liftc_test capc=capc_test)); 
  
  * use modeln as a macro variable name because model is a variable to keep from the table
  * create train validate and test datasets;
  * use CAPRPT library to load the model comparison Churn lift table data;
  set CAPRPT.attr_mdlcompchurn_emrank (keep=decile bin datarole liftc capc model);

  where model = &modeln;
  if upcase(dataRole)='TRAIN'  then output train; else 
  if upcase(dataRole) = 'VALIDATE' then output validate; else
  if upcase(dataRole) = 'TEST' then output test; 
  if decile = 0 then delete ;
  drop datarole ; 
  
run;

data both ; 

  * build lift table by decile;
  merge train validate test; 
  by decile ;
  
  if decile = 0 then delete ;
  
  label liftc_train = "Cumulative Lift Training"  
        capc_train = "Cumulative % Captured Response Training"
        liftc_valid = "Cumulative Lift Validation"  
        capc_valid = "Cumulative % Captured Response Validation" 
        liftc_test = "Cumulative Lift Test"  
        capc_test = "Cumulative % Captured Response Test" 
        decile = "Percentile";
        
run ;
 
title "Model &modeln";
proc print data=both noobs label split="/"  ; 
  var bin decile liftc_train liftc_valid liftc_test capc_train capc_valid capc_test; 
run ;

%mend lifts; 

*the below models are used with attr_mdlcompattr_emrank;
%lifts(modeln='Tree');
%lifts(modeln='Reg');
%lifts(modeln='Neural'); 
%lifts(modeln='Ensmbl');
%lifts(modeln='Boost'); 
