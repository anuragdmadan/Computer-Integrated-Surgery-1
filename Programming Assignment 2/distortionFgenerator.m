%This is an intermediate function used to generate a full F matrix to be 
%used in computing the distortion coefficient matrix. 
%This function takes in a coordinate vector, and the order of the bernstein
%polynomial to be generated, and generates a row matrix F of all
%combinations of the polynomial. 

function f = distortionFgenerator(u,n)
%u is 3x1 vector of coordinates

f=zeros(1,(n+1)*(n+1)*(n+1));
%generate coefficients
for k=0:n
    for j=0:n
        for i=0:n
            f(1,i+(n+1)*j+(n+1)*(n+1)*k+1)=bernsteinPolynomial(n,i,u(1,1))*bernsteinPolynomial(n,j,u(2,1))*bernsteinPolynomial(n,k,u(3,1));
            
        end
    end
end