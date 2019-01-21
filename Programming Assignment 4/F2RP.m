%This function takes in a frame transformation and produces a rotation
%matrix and a translation. 

function [R,p] = F2RP(F)

R=F(1:3,1:3);
p=F(1:3,4);