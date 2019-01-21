%This is the master function to control all other functions. 
%More information about this is given in the readme file. 

function Master_function()
[Ci,dd]=calibrationDataSet();
pemp=empivot("pa1-debug-a-empivot.txt");
popt=OPTPivot(dd, "pa1-debug-a-optpivot.txt");
[pem_sol, popt_sol, c_sol]=debugoutput("pa2-debug-d-output1.txt");
nc=size(Ci,2);
nf=size(Ci,3);
%write2file(Ci,nc,nf,pemp,popt,"unknown-a-output.txt");
[max_diff_c,mean_diff_c, stdev_diff_c, diff_pem_mag, diff_popt_mag]=statisticalAnalysis(c_sol,Ci,pem_sol,pemp,popt_sol,popt);
max_diff_c
mean_diff_c