function A = euler2rmat(euler)
%EULER2RMAT Converts Bunge Euler angles to rotation matrices
%
%   INPUTS:
%       euler is a Nx3 vector of Bunge Euler angles in radians.
%       Bunge Euler angles are defined by a passive ZXZ convention, commonly 
%       used in crystallographic analysis
%
%   OUTPUTS:
%       A is a 3x3xN matrix of rotation matrices.
%
% Brian Jackson August 2016
% Brigham Young University

A = zeros(3,3,size(euler,1));

cp1 = cos(euler(:,1));
sp1 = sin(euler(:,1));
cp2 = cos(euler(:,3));
sp2 = sin(euler(:,3));
cP = cos(euler(:,2));
sP = sin(euler(:,2));

A(1,1,:)= cp1.*cp2-sp1.*sp2.*cP;
A(1,2,:) = sp1.*cp2+cp1.*sp2.*cP;
A(1,3,:) = sp2.*sP;
A(2,1,:)= -cp1.*sp2-sp1.*cp2.*cP;
A(2,2,:)= -sp1.*sp2+cp1.*cp2.*cP;
A(2,3,:)= cp2.*sP;
A(3,1,:)=  sp1.*sP;
A(3,2,:)= -cp1.*sP;
A(3,3,:)=  cP;