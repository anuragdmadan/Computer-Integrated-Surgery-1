%This function accepts a rotation matrix and a translation, and produces a
%frame transformation. 

function F = RP2F(R,P)

F=[R P;0 0 0 1];
