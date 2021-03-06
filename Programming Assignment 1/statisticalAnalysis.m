%This is a function that produces a stastical analysis of the data
%generated by my code compared to the solution output files. It takes as
%input the expected c, EM pivot point and optical pivot point generated by
%my code and the solution text files, and produces a number of statistical
%comparisons. 

function [max_diff_c,mean_diff_c, stdev_diff_c, diff_pem_mag, diff_popt_mag]=statisticalAnalysis(c_sol, ci, pem_sol, pem, popt_sol, popt)

nc=size(c_sol,2);
nf=size(c_sol,3);

c_diff=zeros(size(c_sol));
c_temp=zeros(1,nc,nf);
c_diff_mag=zeros(1,nc*nf);
%We compute the difference in the positions of the solution and those
%generated by my code. 
c_diff=c_sol-ci;
%The following for loops compute the magnitude of the difference in
%positions and store it in a 1D array. 
for j=1:nf
    for i=1:nc
        c_temp(1,i,j)=norm(c_diff(:,i,j));
        
    end
    c_diff_mag(1,nc*(j-1)+1:nc*j)=c_temp(1,:,j);
end
%We compute the max differnce observed, the mean differnece observed, and
%the standard deviations. 
max_diff_c=max(c_diff_mag);
mean_diff_c=mean(c_diff_mag);
stdev_diff_c=std(c_diff_mag);

%We compute the magnitude of the difference in positions of the EM tracker
%and the optical tracker. 
diff_pem=pem_sol-pem;
diff_pem_mag=norm(diff_pem);

diff_popt=popt_sol-popt;
diff_popt_mag=norm(diff_popt);
