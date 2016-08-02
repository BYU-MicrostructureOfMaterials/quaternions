function r = quatmult(q1,q2,method)
%QUATMULT
% r = quatmult(q1,q2)
%   Equal to quaternion multiplication q1*q2
%   Multiplies quaternions of the form [r; ai; bj; ck]
%
%   q1 and q2 need to have 4 rows and any number of columns
%   r will be a matrix of size Nx4xM where M is the number of quaternions in
%   q1 and N is the number of quaternions in q2.
%   I.E. quatmult(q1(i,:),q2(j,:)) = r(j,:,i)
%
% r = quatmult(q1,q2,'element')
%   Multiplies two sets of quaternions of the same size element-wise, or
%   the 1st of q1 with the 1st of q2, 2nd of q1 with 2nd of q2, etc.
%   q1 and q2 can be Nx4xM arrays of quaternions.
%   q1 and q2 must be the same size.
%
% r = quatmult(q1,q2,'noreshape')
%   Only affects output when N = 1 and M > 1. Instead of returning an Mx4
%   array, it will return a 1x4xM array.
%
% Brian Jackson July 2016
% Brigham Young University

if nargin < 3
    method = 'default';
end
if size(q1,2) ~= 4 || size(q2,2) ~= 4
    error('Invalid inputs. q1 and q2 must be Nx4 and Mx4 matrices.')
end

M1 = size(q1,1);
M2 = size(q2,1);
N1 = size(q1,3);
N2 = size(q2,3);

%Create matrix for fast multiplication
q1 = permute(q1,[2 1 3]);
Q1 = [q1(1,:) -q1(2,:) -q1(3,:) -q1(4,:);...
      q1(2,:)  q1(1,:) -q1(4,:)  q1(3,:);...
      q1(3,:)  q1(4,:)  q1(1,:) -q1(2,:);...
      q1(4,:) -q1(3,:)  q1(2,:)  q1(1,:)];

%Avoid extra operations if multiplying only two quaternions
if M1 == 1 && M2 == 1 && N1 == 1 && N2 == 1 
    r = (Q1*q2')';
else %Multiply arrays of quaternions
    
    %Element-wise multiplication
    if strcmp(method,'element')
        if M1 == M2 && N1 == N2
            r= zeros(4,M1,N1);
            for j = 1:N1
                for i = 1:M1
                    r(:,i,j) = Q1(:,i+M2*(j-1):M1*N1:M1*N1*4)*q2(i,:,j)';
                end
            end
            r = permute(r,[2 1 3]);
        else
            error('Arrays must be the same size for element-wise multiplication')
        end
    %Array multiplication
    elseif N1 == 1 && N2 == 1
        Q1 = reshape(Q1,4*M1,4);
        r = (Q1*q2')';
        r = reshape(r,M2,4,M1);
        
        %Reshape singleton dimension
        if M2 == 1 && M1 > 1 && ~strcmp('noreshape',method)
            r = squeeze(r)';
        end
    else
        error('Only vectors of quaternions are accepted for matrix multiplication')
    end
end
