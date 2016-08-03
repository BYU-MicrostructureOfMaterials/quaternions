function [q_avg,miso] = quat_avg_sym(q1,q2,q_symops,interp,W1,W2)
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

if nargin == 3
    interp = 'lerp';
end
if nargin <= 4
    W1 = 1;
    W2 = 1;
end
t = W2/(W1+W2);

if nargin == 5
    t = W1;
end


numq1 = size(q1,1);
numq2 = size(q2,1);
numsym = size(q_symops,1);

% Get all symmetric orientations for q1
q1_sym = quatmult(q_symops,q1,'noreshape');
q1_sym = cat(3,q1_sym,-1*q1_sym);
q1_sym2 = reshape(permute(q1_sym,[3 1 2]),numq1*numsym*2,4);

% Calculate misorientations between all pairs
misos = reshape(quatangle(q1_sym2,q2),numsym*2,numq1,numq2);

% Find minimum misorientations
[miso,I] = min(misos);
I = squeeze(I);
miso = squeeze(miso);
if numq1 == 1 || numq2 == 1
    I = I';
    miso = miso(:);
end

% Extract out rotated quaternions
if numq1 == 1 && numq2 == 1 % Save computation time by avoiding data wrangling for simple case
    q1_rot = q1_sym2(I,:);
    q2_rot = q2;
else
    I_all = sub2ind(size(q1_sym),repmat((1:numq1)',1,numq2,4),repmat(permute(1:4,[1 3 2]),numq1,numq2,1),repmat(I,1,1,4));
    q1_rot = permute(q1_sym(I_all),[1 3 2]);
    q2_rot = permute(repmat(q2,1,1,numq1),[3 2 1]);
end

% Calculate Average
if strcmp(interp,'lerp')
    q_avg = quatlerp(q1_rot,q2_rot,t,'element');
    q_avg = quatnorm(q_avg);
elseif strcmp(interp,'slerp')
    q_avg = quatslerp(q1_rot,q2_rot,t,'element');
end
q_avg = permute(q_avg,[3 2 1]);
miso = miso';

end