% Generate random undirect graph
% https://www.mathworks.com/matlabcentral/answers/563732
n = 10; % number of nodes
maxDeg = 4;
M=rand(n);
M=0.5*(M+M');
S1=sort(M,1,'descend');
S2=sort(M,2,'descend');
T=max(S1(maxDeg,:),S2(:,maxDeg));
A=M>=T;
G=graph(A);
% Test
plot(G);
st = randperm(n,2); % pick a random pair of nodes
p = AllPath(A, st(1), st(2)); ; % function defined in mfile below 
fprintf('--- test ---\n');
for k=1:size(p,1)
    fprintf('path #%d: %s\n', k, mat2str(p{k}));
end
%%
function p = AllPath(A, s, t)
% Find all paths from node #s to node #t
% INPUTS:
%   A is (n x n) symmetric ajadcent matrix
%   s, t are node number, in (1:n)
% OUTPUT
%   p is M x 1 cell array, each contains array of
%   nodes of the path, (it starts with s ends with t)
%   nodes are visited at most once.
if s == t
    p =  {s};
    return
end
p = {};
As = A(:,s)';
As(s) = 0;
neig = find(As);
if isempty(neig)
    return
end
A(:,s) = [];
A(s,:) = [];
neig = neig-(neig>=s);
t = t-(t>=s); 
for n=neig
    p = [p; AllPath(A,n,t)]; %#ok
end
p = cellfun(@(a) [s, a+(a>=s)], p, 'unif', 0);
end %AllPath