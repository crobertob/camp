function [ probabilities mask ] = solveRw(A, seeds, labels, beta)
% Compute the edge weights of the graph using a 4-neighborhoud connectivity:
% (Hint: MATLAB functions ind2sub and sub2ind might be of help)
size_i=size(A, 1);
size_j=size(A, 2);
size_A=size(A);
tic
beta = 90;
nzA=4*3+(size_i-2)*4*2+(size_j-2)*4*2+(size_i-2)*(size_j-2)*5;
W=spalloc(size_i,size_j,nzA);
nzB=4*2+(size_i-2)*3*2+(size_j-2)*3*2+(size_i-2)*(size_j-2)*4;

idx = zeros(nzB,1);
jdx = zeros(nzB,1);
Val = zeros(nzB,1);
j=1;

tic
for i=1:size_i*size_j
    [I,J]=ind2sub(size_A,i);
    if I+1 <= size_i
        Val(j)=abs(A(I+1,J)-A(I,J));
        idx(j)=i;
        jdx(j)=sub2ind(size_A,I+1,J);
        j=j+1;
    end
    if I-1 >= 1
        Val(j)=abs(A(I-1,J)-A(I,J));
        idx(j)=i;
        jdx(j)=sub2ind(size_A,I-1,J);
        j=j+1;
    end
    if J+1 <= size_j
        Val(j)=abs(A(I,J+1)-A(I,J));
        idx(j)=i;
        jdx(j)=sub2ind(size_A,I,J+1);
        j=j+1;
    end
    if J-1 >= 1
       Val(j)=abs(A(I,J-1)-A(I,J));
        idx(j)=i;
        jdx(j)=sub2ind(size_A,I,J-1);
        j=j+1;
    end
end
toc

%Normalize weights
Val = (Val - min(Val(:))) ./ (max(Val(:)) - min(Val(:)) + eps);

% Gaussian weighting
EPSILON = 10e-6;
Val = -((exp(-beta*Val)) + EPSILON);
W = sparse(idx,jdx,Val);

[row,col,V]= find(W);
temp = zeros(size_i*size_j,1);
for i=1:size(row)
    temp(col(i))=temp(col(i))-V(i);
end
L = spdiags(temp,0,W);

%%
% Assemble L_u by selecting rows and columns corresponding to unmarked nodes in the GraphLaplacian
% Initialize matrix L_u
L_u=L; 
% Create temporary array to obtain indices of seeds
idx_Seed=zeros(size(L,1),1); 
% Assign 1 to each voxel that has a seed
idx_Seed(seeds)=1; 
% Store the index (in this case the row vector) of marked nodes
idx_Seed=find(idx_Seed);
% Remove the rows that contain seeds
L_u(idx_Seed,:)=[];
% Remove the columns that contain seeds
L_u(:,idx_Seed)=[];

% Assemble M by creating a matrix, with one column per label (here 2 columns: label 1 =
%foreground, label 2 = background ) and one row per seed node. 
%2 labels so matrix is [size of labels, 2]
M= zeros(length(labels),2);
for i=1:length(labels)
    M(i,labels(i))=1;
end
M=sparse(M);

% Create B_T by selecting only the columns that contain a seed.
B_T = L(:,seeds);
% Then remove nodes that contain a seed.
idx_No_seed = 1:size(L,1);
% Assign zero to voxels with seeds
idx_No_seed(seeds) = 0;
% Find voxels without seeds
idx_No_seed = find(idx_No_seed);
% Only take the rows with no seeds
B_T = B_T(idx_No_seed,:);
B_T = sparse(B_T);

%Solve the linear system
x=L_u\(-B_T*M);

% Initialize the probability matrix
probabilities = zeros(size(L,1),2);
for k=1:2
    % Return probabilities for all of the unmarked nodes
    probabilities(idx_No_seed,k)=x(:,k);
    % The marked nodes should have a 100% probability
    probabilities(seeds(labels==k),k) = 1.0;
end

% use max to return 1 if column of label 1 (foreground) has the highest probability or
% 2 if column of label 2 (background) has the highest probability.
[values mask]=max(probabilities,[],2);

% change from vector to matrix of same shape as A
mask=reshape(mask,size(A));

end