This is a nice simple solution to the common problem of filling in missing values in a sequence by group.                
                                                                                                                         
I think it is worth repeating, R even has a 'complete' function.                                                         
                                                                                                                         
github                                                                                                                   
https://tinyurl.com/y3sdgtyf                                                                                             
https://github.com/rogerjdeangelis/utl-completing-a-sequence-of-dates-with-missing-years-months-or-days_by-group         
                                                                                                                         
SAS  Forum                                                                                                               
https://tinyurl.com/y3f32ard                                                                                             
https://communities.sas.com/t5/SAS-Data-Management/Missing-values-from-previous-dates/m-p/566027                         
                                                                                                                         
KSharp                                                                                                                   
https://communities.sas.com/t5/user/viewprofilepage/user-id/18408                                                        
                                                                                                                         
*_                   _                                                                                                   
(_)_ __  _ __  _   _| |_                                                                                                 
| | '_ \| '_ \| | | | __|                                                                                                
| | | | | |_) | |_| | |_                                                                                                 
|_|_| |_| .__/ \__,_|\__|                                                                                                
        |_|                                                                                                              
;                                                                                                                        
                                                                                                                         
data have;                                                                                                               
 input TxnID Month : yymmn6. Value;                                                                                      
 format Month yymmn6.;                                                                                                   
cards4;                                                                                                                  
1 201811 120                                                                                                             
1 201812 240                                                                                                             
1 201902 350                                                                                                             
1 201903 400                                                                                                             
1 201905 100                                                                                                             
2 201812 200                                                                                                             
2 201902 300                                                                                                             
;;;;                                                                                                                     
run;quit;                                                                                                                
                                                                                                                         
                                                                                                                         
Up to 40 obs WORK.HAVE total obs=7                                                                                       
                                                                                                                         
                            |  Rules fill in missing months by TXNID                                                     
                                                                                                                         
 TXNID   VALUE    MONTH     |  MONTH                                                                                     
                            |                                                                                            
   1      120     2018 11   |  2018 11                                                                                   
   1      240     2018 12   |  2018 12                                                                                   
                            |  2019 01                                                                                   
   1      350     2019 02   |  2019 02                                                                                   
   1      400     2019 03   |  2019 03                                                                                   
                            |  2019 04                                                                                   
   1      100     2019 05   |  2019 05                                                                                   
                                                                                                                         
   2      200     2018 12   |  2018 12  Start over                                                                       
                            |  2019 01                                                                                   
   2      300     2019 02   |  2019 02                                                                                   
                                                                                                                         
                                                                                                                         
*            _               _                                                                                           
  ___  _   _| |_ _ __  _   _| |_                                                                                         
 / _ \| | | | __| '_ \| | | | __|                                                                                        
| (_) | |_| | |_| |_) | |_| | |_                                                                                         
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                        
                |_|                                                                                                      
;                                                                                                                        
                                                                                                                         
WANT total obs=10                                                                                                        
                                                                                                                         
Obs    TXNID    MONTH     VALUE                                                                                          
                                                                                                                         
  1      1      201811     120                                                                                           
  2      1      201812     240                                                                                           
  3      1      201901     240                                                                                           
  4      1      201902     350                                                                                           
  5      1      201903     400                                                                                           
  6      1      201904     400                                                                                           
  7      1      201905     100                                                                                           
  8      2      201812     200                                                                                           
  9      2      201901     200                                                                                           
 10      2      201902     300                                                                                           
                                                                                                                         
*                                                                                                                        
 _ __  _ __ ___   ___ ___  ___ ___                                                                                       
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                                      
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                      
| .__/|_|  \___/ \___\___||___/___/                                                                                      
|_|                                                                                                                      
;                                                                                                                        
                                                                                                                         
data want   ;                                                                                                            
 merge have have(keep=txnid month rename=(txnid=_id month=_month) firstobs=2);                                           
 output;                                                                                                                 
 if txnid=_id then do;                      /* checks for achange in txnid */                                            
   do i=1 to intck('month',month,_month)-1; /* does not go beyond last date in txnid group */                            
    month=intnx('month',month,1);                                                                                        
    output;                                                                                                              
   end;                                                                                                                  
 end;                                                                                                                    
drop _: i;                                                                                                               
run;                                                                                                                     
                                                                                                                         
                                                                                                                         
