function euler = rmat2euler(A)
%RMAT2EULER Converts a rotation matrix to euler angles
%
%   INPUTS:
%       A is a 3x3xN matrix of rotation matrices
%
%   OUPUTS:
%       euler is a Nx3 vector of Bunge Euler angles in radians.
%       Bunge Euler angles are defined by a passive ZXZ convention, commonly 
%       used in crystallographic analysis
%
% Brian Jackson August 2016
% Brigham Young University

tol = 1e-12;
POS33 = squeeze(A(3,3,:) >  1 - tol);
NEG33 = squeeze(A(3,3,:) < -1 + tol);

POS11 = squeeze(A(1,1,:) >  1 - tol);
NEG11 = squeeze(A(1,1,:) < -1 + tol);

NORM = ~POS33 & ~NEG33;

A(3,3,POS33) =  1;
A(3,3,NEG33) = -1;

euler = zeros(size(A,3),3);

euler(NORM,:) = permute([...
    atan2(A(3,1,NORM),-A(3,2,NORM))...
    acos(A(3,3,NORM))...
    atan2(A(1,3,NORM), A(2,3,NORM))],[3 2 1]);

euler(euler(:,1)<0,1) = euler(euler(:,1)<0,1)+2*pi;
euler(euler(:,3)<0,3) = euler(euler(:,3)<0,3)+2*pi;


A(3,3,POS11) = 1;
A(3,3,NEG11) = -1;

euler(~NORM,:) = permute([...
    acos(A(1,1,~NORM))...
    zeros(1,1,sum(~NORM)) ...
    zeros(1,1,sum(~NORM))],[3 2 1]);
euler(NEG33,3) = atan2(A(1,3,NEG33), A(2,3,NEG33));

NEG12 = squeeze(A(1,2,:) < 0);
euler(NEG12 & ~NORM,1) = 2*pi - euler(NEG12 & ~NORM,1);


    
    
