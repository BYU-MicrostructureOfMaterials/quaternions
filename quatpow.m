function q0 = quatpow(q,t)
%QUATPOW Raises a quaternion q to power t
%   quaternions of the form [r, ai, bj, ck]
%   Equivalent to quatexp(t.*quatlog(q))
%
%   INPUTS:
%       q is an Mx4xN quaternion array. All entries must be unit quaternions.
%       t is a constant or Mx1xN or MxN array that will raise the corresponding
%       quaternion to the power specified by entry in t.
%   OUTPUT:
%       q0 is an Mx4 quaternion array
% 
% Brian Jackson July 2016
% Brigham Young University

if size(t,2) > 1 && size(t,3) == 1
    t = permute(t,[1,3,2]);
end

theta = acos(q(:,1,:));
notzero = theta ~= 0;
NZ = repmat(notzero,1,3,1);
v = q(:,2:4,:)./repmat(sin(theta),1,3);
v(~NZ) = 0;
q0 = [cos(theta.*t),repmat(sin(theta.*t),1,3,1).*v];
end

