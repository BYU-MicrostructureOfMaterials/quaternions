function euler = quat2euler(q)
%EULER2QUAT Converts Bunge Euler angles to quaternions
%
%   INPUTS:
%       q is a Nx4 vector of quaternions of the form [r, ai, bj, ck]     
%
%   OUTPUTS:
%       euler is a Nx3 vector of Bunge Euler angles in radians.
%       Bunge Euler angles are defined by a passive ZXZ convention, commonly 
%       used in crystallographic analysis
%
% Brian Jackson August 2016
% Brigham Young University

% Normalize quaternion
q = quatnorm(q);

euler = [...
    atan2(q(:,2).*q(:,4) - q(:,3).*q(:,1), -(q(:,3).*q(:,4) + q(:,2).*q(:,1)))...
    acos(-q(:,2).^2 - q(:,3).^2 + q(:,4).^2 + q(:,1).^2)...
    atan2(q(:,2).*q(:,4) + q(:,3).*q(:,1),   q(:,3).*q(:,4) - q(:,2).*q(:,1))];

