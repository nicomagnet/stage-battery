function [v] = normalized_batt(n,a1,a2)
% Normalize the vector to max and min values
% input 
% n:0= normalize with the max value of the vector
% n:1= normalize with the value of the cap 2150
% a1: vector 1
% a2:Vector 2
% Output
% v/ matrix double vector 1 and 2
capacity=2150;
switch n
    case 0
        v(:,1)=a1*100./capacity;
        v(:,2)=a2;
    case 1
        v(:,1)=a1*100./(max(a1)-min(a1));% change (max(a1)
%         v(:,1)=a1./(capacity-min(a1));% change (max(a1)
        v(:,2)=a2;
    otherwise
        disp('no case')
end
   