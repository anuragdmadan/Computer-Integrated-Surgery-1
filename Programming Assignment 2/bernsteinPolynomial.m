%This function takes in the order of the polynomial n, the value i, and the
%scaled value u, with 0<u<1, and returns the bernstein coefficient c. 
function c = bernsteinPolynomial(n, i, u)
c = nchoosek(n,i)*((1-u)^(n-i))*(u^i);