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
% Compute Lu & M
% Select marked columns from Laplacian to create L_M and B^T
BT = L(:,seeds);

% Select marked nodes to create BT^T
idx_U = 1:size(L,1);
idx_U(seeds) = 0;
idx_U = find(idx_U); % Index of unmarked nodes
BT = BT(idx_U,:);

% TODO  Remove marked nodes from Laplacian by deleting rows and cols
%first remove columns
Lu=L; %copy Laplacian
idx_M=zeros(size(L,1),1); %
idx_M(seeds)=1; %marked nodes
idx_M=find(idx_M); %Index of marked nodes
Lu(:,idx_M)=[];%remove nodes column
Lu(idx_M,:)=[];% remove nodes row
% Essentially, create Lu
L = Lu;

% Adjust labels
label_adjust=min(labels); labels=labels-label_adjust+1; % labels > 0

% Find number of labels (K)
labels_record(labels)=1; %creates 1 at labels, rest 0
labels_present=find(labels_record);
number_labels=length(labels_present);

% TODO-Define M matrix
M= zeros(length(labels),number_labels);
for Val=1:length(labels)
    M(Val,labels(Val))=1;
end

% TODO- Define right-handside of random walks
rhs= -BT*M; % formel S 40

rhs = sparse(rhs);

% TODO - Solve system of linear equations
% Hint: At this point all the matrices you need have been defined
x=L\rhs; % formel S. 40


% Prepare output
probabilities = zeros(size(L,1),number_labels);
for k=1:number_labels
    % Probabilities for unmarked nodes
    probabilities(idx_U,k)=x(:,k);
    % Max probability for marked node of each label
    probabilities(seeds(labels==k),k) = 1.0;
end

[dummy mask]=max(probabilities,[],2);
%Assign original labels to mask
mask=labels_present(mask)+label_adjust-1;
% reshape indices to image
mask=reshape(mask,size(A));

% % Final reshape with same size as input image (no padding)
% probabilities=reshape(probabilities,[size(A,1) size(A,2) number_labels]);


end