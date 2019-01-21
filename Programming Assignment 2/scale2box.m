%This function takes in a set of values q, and scales them to between 0 and
%1.

function x = scale2box(q)
%q is all coordinates in 1D. (1xN) vector. 
N=size(q,2);
x_max=max(q);
x_min=min(q);
x=zeros(1,N);
for i=1:N
    x(1,i)=(q(1,i)-x_min)/(x_max-x_min);
end
