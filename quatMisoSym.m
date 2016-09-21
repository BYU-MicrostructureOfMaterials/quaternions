function [miso,q1_rot,q2_rot,deltaq] = quatMisoSym(q1,q2,q_symops,method)
%QUATMISOSYM Calculates the misorientation between two quaternions with
%  symmetry operators
%
%   Quaternions are of the form [r, ai, bj, ck]
%
%   miso = quatMisoSym(q1,q2,q_symops)
%       Calculates the misorientation angle (in radians), between quaternions q1
%       and q2 for symmetry operators q_symops. If q1 and q2 are Nx4 and
%       Mx4 vectors of quaternions, respectively, miso will be an MxN 
%       array of quaternions, such that 
%       miso(j,i) = quatMisoSym(q1(i,:),q2(j,:),q_symops).
%
%       q_symops is an Px4 array of quaternion symmetry operators.
%
%   [q_avg, q1_rot, q2_rot] = quatMisoSym(q1,q2,q_symops)
%       Returns the rotated quaternions that have the smallest
%       misorientation angle. q1_rot and q2_rot will always be identically
%       sized to Mx4xN.
%
%   miso = quatMisoSym(q1,q2,q_symops,method)
%       Specifies combination method.
%       'default' will calculate the misorientation of every quaternion of
%           q1 with every quaternion of q2, returning an array of MxN.
%       'element' will calculate the misorientation between each quaternion
%           pair of identically-sized Mx4 vectors of quaternions. The
%           result will be a column vector of misorientation angles, and
%           q1_rot and q2_rot will be Mx4 vectors of quaternions.
%           
%
% Brian Jackson August 2016
% Brigham Young University
% 
% Acknowledgements to Stephen Cluff for original code

isdef = strcmp(method,'default');

numq1 = size(q1,1);
numq2 = size(q2,1);
numsym = size(q_symops,1);

% Get all symmetric orientations for q1
q1_sym = quatmult(q_symops,q1,'noreshape');
q1_sym = cat(3,q1_sym,-1*q1_sym);
q1_sym2 = reshape(permute(q1_sym,[3 1 2]),numq1*numsym*2,4);

% Calculate misorientations between all pairs
if isdef
    misos = reshape(quatangle(q1_sym2,q2),numsym*2,numq1,numq2);
elseif strcmp(method,'element')
    q2_sym = reshape(repmat(q2',numsym*2,1),4,numsym*2*numq1)';
    misos = reshape(quatangle(q1_sym2,q2_sym,'element'),numsym*2,numq1);
    numq1 = 1;
end

% Find minimum misorientations
[miso,I] = min(misos);
I = squeeze(I);
miso = squeeze(miso);
if (numq1 == 1 || numq2 == 1) && isdef
    miso = miso(:);
end
I = I';
miso = miso';

if nargout > 1

    % Extract out rotated quaternions
    if numq1 == 1 && numq2 == 1 % Save computation time by avoiding data wrangling for simple case
        q1_rot = permute(q1_sym2(I,:),[3 2 1]);
        q2_rot = permute(q2,[3 2 1]);
    else
        I_all = permute(sub2ind(size(q1_sym),repmat((1:numq2)',1,4),repmat(1:4,numq2,1),repmat(I,1,4)),[3 1 2]);
        q1_rot = permute(q1_sym(I_all),[2 3 1]);
        q2_rot = repmat(q2,1,1,numq1);
    end
    
    deltaq = quatmult(q1_rot,quatconj(q2_rot),method);
    
end
