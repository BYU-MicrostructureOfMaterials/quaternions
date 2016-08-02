function q = quatflip(q,dir)
%QUATFLIP Changes order of quaternion elements
%   INPUTS:
%       q must be a Mx4 array of quaternions. Can be a single quaternions
%       or a vector of quaternions.
%       
%       dir (optional): 'f' or 'b'. Specifies direction of flip. Default 'f'.
%   OUTPUT:
%       q is a vector of quaternions of the same size as the input
%
%   q = quatflip(q)
%       Converts a quaternions of the form [ai, bj, ck, r] to the form [r, ai, bi, ck]
%   q = quatflip(q,dir)
%       Flips quaternions either direction. dir can either be 'f' or 'b'. Default is forward 'f'. 
%
% Brian Jackson July 2016
% Brigham Young University

if nargin == 1
    dir = 'f';
end
switch dir 
    case 'f'
        q = [q(:,4),q(:,1:3)];
    case 'b'
        q = [q(:,2:4),q(:,1)];
end