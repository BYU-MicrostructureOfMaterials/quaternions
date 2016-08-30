function q0 = quatinv(q)
%QUATINV Takes the inverse of a quaternion
%
%   INPUTS:
%       q is an Mx4 vector of quaternions
%
%   OUTPUTS:
%       q0 is an Mx4 vector of the inverses of q
%
% Brian Jackson August 2016
% Brigham Young University

if size(q,1) < 20
    q0 = quatconj(q)./repmat(diag((q*q')),1,4);
else
    [~,n] = quatnorm(q);
    q0 = quatconj(q)./repmat((n.^2),1,4);
end


