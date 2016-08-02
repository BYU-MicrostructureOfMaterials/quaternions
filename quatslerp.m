function q_avg = quatslerp(q1,q2,t,method)
%QUATSLERP Slerp function for spherical interpolation of quaternions
%   quaternions of the form [r, ai, bj, ck]
%
%   INPUTS:
%       q1 and q2 are vectors of quaternions of size Mx4 and Nx4,
%           respectively.
%       t is the fractional distance between q1 and q2 at which the
%           quaternion is interpolated. Must be a value between 0 and 1.
%       method (optional): Either 'default' or 'element'. 
%           'default' calculates the interpolation of every quaternion in
%               q1 with every quaternion in q2. Returns an array of Nx4xM,
%               such that q_avg(j,:,i) = quatslerp(q1(i,:),q2(j,:),t)
%           'element' calculates the interpolation of each pair of
%               quaternions in q1 and q2. q1 and q2 must be indenticially sized
%               vectors of quaternions.
%           'noreshape' will avoid squeezing singleton dimenions of the
%               resultant array, where applicable.
%   OUTPUTS: 
%       q_avg is a Nx4xM array of quaternions or a Mx4 vector of
%       quaternions
%
% Brian Jackson July 2016
% Brigham Young University

sze = size(q1,1);
if nargin == 3
    mtd = 'noreshape';
    method = 'default';
else
    if ~strcmp({'default','element','noreshape'},method)
        error('Invalid method input')
    end
    if strcmp('element',method)
        sze = 1;
    else
        mtd = 'noreshape';
    end
end
q_avg = quatmult(quatpow(quatmult(q1,quatconj(q2),mtd),1-t),repmat(q2,1,1,sze),'element');
if size(q_avg,1) == 1 && ~strcmp('noreshape',method)
    q_avg = squeeze(q_avg)';
end

