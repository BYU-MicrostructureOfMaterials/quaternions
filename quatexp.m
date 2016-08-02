function q = quatexp(q)
%QUATEXP exp of a quaternion
%   quaternions of the form [r, ai, bj, ck]
%
% INPUTS:
%   q is an Mx4 quaternion array. All entries are required to be
%   quaternions of the form q = [0,theta*v], such that 
%   exp(q) = [cos(theta),sin(theta)*v]
%
% OUTPUTS
%   q is an Mx4 quaternion array.
%
% Brian Jackson July 2016
% Brigham Young University

[v,theta] = quatnorm(q(:,2:4));
q = [cos(theta),sin(theta)*v];
end