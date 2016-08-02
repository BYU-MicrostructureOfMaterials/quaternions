function ang = quatangle(q1,q2,method)
%QUATANGLE Calculates the angle between two quaternions
%   quaternions of the form [r, ai, bj, ck]
%
%   INPUTS:
%       q1 and q1 must be Mx4 and Nx4 arrays of quaternions. Inputs should
%           be unit quaternions.
%       method (optional): 'default' or 'element'.
%           'default' will find the angle between every element of q1 and
%               every element of q2
%           'element' will find the angles between paired elements of q1
%               and q2, or the angle between q1(:,i) and q2(:,i). Equal to the
%               diagonal entries of 'default' method. Inputs must be the same
%               size.
%       
%   OUTPUTS:
%       ang is a MxN array of angles between quaternions, in radians
%
% Brian Jackson July 2016
% Brigham Young University

if nargin == 2
    method = 'default';
end
switch method
    case 'default'
        ang = 2*acos(q1*q2');
    case 'element'
        if size(q1,1) == size(q2,1)
            ang = 2*acos(sum(q1.*q2,2));
        else
            error('Inputs must be the same size for element-wise operation')
        end
end