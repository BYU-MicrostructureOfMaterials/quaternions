function q = quatlog(q)
%QUATLOG log of a quaternion
%   quaternions of the form [r, ai, bj, ck]
%
% INPUTS:
%   q is an Mx4 quaternion array. All entries are required to be unit
%   quaternions of the form q = [cos(theta),sin(theta)*v], such that 
%   log(q) = [0,theta*v]
%
% OUTPUTS
%   q is an Mx4 quaternion array.
%
% Brian Jackson July 2016
% Brigham Young University

theta = acos(q(:,1));
v = q(:,2:4)/sin(theta);
q = [0,theta*v];
end