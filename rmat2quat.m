function quat = rmat2quat(A)
%RMAT2QUAT Converts rotation matrices to quaternions
%   INPUTS:
%       A is a 3x3xN matrix of rotation matrices.
%
%   OUTPUTS:
%       quat is an Nx4 matrix of quaternions
%
% Brian Jackson August 2016
% Brigham Young University

%Indices to determine which case to use
tr = (A(1,1,:)+A(2,2,:)+A(3,3,:));
RI = squeeze(tr > 1);
AI = ~RI & squeeze((A(1,1,:) > A(2,2,:) & A(1,1,:) > A(3,3,:)));
BI = ~AI & ~RI & squeeze((A(2,2,:) > A(3,3,:)));
CI = ~RI & ~AI & ~BI;

%Fill in Matrix
quat = zeros(size(A,3),4);
s = 2*sqrt(tr(RI) + 1);
if any(RI)
    quat(RI,:) = permute([...
        s / 4 ...
        (A(3,2,RI) - A(2,3,RI)) ./ s...
        (A(1,3,RI) - A(3,1,RI)) ./ s...
        (A(2,1,RI) - A(1,2,RI)) ./ s],[3 2 1]);
end
if any(AI)
    s = 2*sqrt(1+A(1,1,AI)-A(2,2,AI)-A(3,3,AI));
    quat(AI,:) = permute([...
        (A(3,2,AI) - A(2,3,AI)) ./ s...
        s / 4 ...
        (A(1,2,AI) + A(2,1,AI)) ./ s...
        (A(1,3,AI) + A(3,1,AI)) ./ s],[3 2 1]);
end
if any(BI)
    s = 2*sqrt(1+A(2,2,BI)-A(1,1,BI)-A(3,3,BI));
    quat(BI,:) = permute([...
        (A(1,3,BI) - A(3,1,BI)) ./ s...
        (A(1,2,BI) + A(2,1,BI)) ./ s...
        s / 4 ...
        (A(2,3,BI) + A(3,2,BI)) ./ s],[3 2 1]);
end
if any(CI)
    s = 2*sqrt(1+A(3,3,CI)-A(1,1,CI)-A(2,2,CI));
    quat(CI,:) = permute([...
        (A(2,1,CI) - A(1,2,CI)) ./ s...
        (A(1,3,CI) + A(3,1,CI)) ./ s...
        (A(2,3,CI) + A(3,2,CI)) ./ s...
        s / 4],[3 2 1]);
    
end

%Make all real parts positive
NI = quat(:,1) < 0;
if any(NI)
    quat(NI,:) = -quat(NI,:);
end


end
