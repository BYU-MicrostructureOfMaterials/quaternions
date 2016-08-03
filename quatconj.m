function q = quatconj(q)
%QUATCONJ Computes the conjugate of q, q*
%   quaternions of the form [r, ai, bj, ck]
%
%   INPUTS:
%       q is an Mx4 quaternion vector or Mx4xN quaternion array
%
%   OUTPUT:
%       q0 is an Mx4 quaternion vector or Mx4xN quaternion array
% 
% Brian Jackson July 2016
% Brigham Young University
q(:,2:4,:) = -1*q(:,2:4,:);