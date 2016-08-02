function quat = euler2quat(euler)
%EULER2QUAT Converts Bunge Euler angles to quaternions
%
%   INPUTS:
%       euler is a Nx3 vector of Bunge Euler angles in radians.
%       Bunge Euler angles are defined by a passive ZXZ convention, commonly 
%       used in crystallographic analysis
%
%   OUTPUTS:
%       quat is a Nx4 vector of unit quaternions of the form [r, ai, bj, ck]
%
% Brian Jackson August 2016
% Brigham Young University

quat = [...
    cos((euler(:,1)+euler(:,3))/2).*cos(euler(:,2)/2)...
    -cos((euler(:,1)-euler(:,3))/2).*sin(euler(:,2)/2)...
    -sin((euler(:,1)-euler(:,3))/2).*sin(euler(:,2)/2)...
    -sin((euler(:,1)+euler(:,3))/2).*cos(euler(:,2)/2)];

%Make all real parts positive
NI = quat(:,1) < 0;
if any(NI)
    quat(NI,:) = -quat(NI,:);
end