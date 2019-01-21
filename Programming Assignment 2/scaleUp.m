%This function takes in data that has been scaled between 0 and 1, and
%unscales it. 

function sc = scaleUp(p,p_max,p_min)
%p is 1 x N
N=size(p,2);
sc=zeros(1,N);
for i=1:N
    sc(1,i)=p(1,i)*(p_max-p_min)+p_min;
end
