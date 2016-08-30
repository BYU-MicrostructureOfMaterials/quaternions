function [q_avg,miso,deltaq] = quat_avg_sym(q1,q2,q_symops,method,interp,W1,W2)
%QUAT_AVG_SYM Interpolates quaternions with given symmetry operators
%   Quaternions are of the form [r, ai, bj, ck]
%
%   q_avg = quat_avg_sym(q1,q2,q_symops)
%       Calculates the average quaternion, q_avg, between quaternions q1
%       and q2 for symmetry operators q_symops. If q1 and q2 are Nx4 and
%       Mx4 vectors of quaternions, respectively, q_avg will be an Mx4xN 
%       array of quaternions, such that 
%       q_avg(j,:,i) = quat_avg_sym(q1(i,:),q2(j,:),q_symops).
%
%       q_symops is an Px4 array of quaternion symmetry operators.
%
%   [q_avg,miso] = quat_avg_sym(q1,q2,q_symops)
%       Returns an MxN array of the minimum misorientation angles between
%       the quaternion elements of q1 and q2.
%
%   [q_avg,miso,delta] = quat_avg_sym(q1,q2,q_symops)
%       Returns an MxN array of the minimum misorientation angles between
%       the quaternion elements of q1 and q2.
%
%   q_avg = quat_avg_sym(q1,q2,q_symops,interp)
%       Specify type of interpolation used.
%       'lerp' for linear interpolation
%       'slerp' for spherical interpolation.
%       For an equally-weighted average, these will return the same value.
%
%   q_avg = quat_avg_sym(q1,q2,q_symops,interp,t)
%       Will return the interpolation between the quaternions at a value t,
%       which gives the fractional distance from q1 to q2. t must be a
%       value between 0 and 1.
%
%   q_avg = quat_avg_sym(q1,q2,q_symops,interp,W1,W2)
%       Will return the interpolcation between the quaternions for a weight
%       W1 on q1, and weight W2 on q2, such that t = W2/(W1+W2).
%
% Brian Jackson August 2016
% Brigham Young University
% 
% Acknowledgements to Stephen Cluff for original code

tic
if nargin < 4
    method = 'default';
end
if nargin < 5
    interp = 'lerp';
end
if nargin < 6
    W1 = 1;
    W2 = 1;
end
t = W2/(W1+W2);

if nargin == 6
    t = W1;
end

% Get Misorientation and Rotated Quaternions
[miso,q1_rot,q2_rot,deltaq] = quatMisoSym(q1,q2,q_symops,method);

% Calculate Average
if strcmp(interp,'lerp')
    q_avg = quatlerp(q1_rot,q2_rot,t,'element');
    q_avg = quatnorm(q_avg);
elseif strcmp(interp,'slerp')
    q_avg = quatslerp(q1_rot,q2_rot,t,'element');
end
toc

end