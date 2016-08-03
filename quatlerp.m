function q_avg = quatlerp(q1,q2,t,method)
%QUATLERP Lerp function for linear interpolation of quaternions
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

if nargin == 3
    method = 'default';
end
M = size(q1,1);
N = size(q2,1);

if strcmp(method,'element')
    if M == N
        q_avg = q1*(1-t) + q2*t;
    else
        error('Arrays must be the same size for element-wise operation.')
    end
else
    Q1 = repmat(q1,1,1,N);
    Q2 = repmat(reshape(q2',1,4,N),M,1,1);
    
    q_avg = Q1*(1-t) + Q2*t;
    q_avg = permute(q_avg,[3 2 1]);
end
if size(q_avg,1) == 1 && (M > 1 || N > 1) && ~strcmp('noreshape',method)
    q_avg = squeeze(q_avg)';
end