function [ probabilities mask ] = solveRw(A, seeds, labels, beta)
% Compute the edge weights of the graph using a 4-neighborhoud connectivity: 
% (Hint: MATLAB functions ind2sub and sub2ind might be of help)
beta = 90;
nzA=4*3+(size(A,1)-2)*4*2+(size(A,2)-2)*4*2+(size(A,1)-2)*(size(A,2)-2)*5;
%Allocate memory for sparse matrix
W=spalloc(size(A,1),size(A,2),nzA);
%Calculate initial weights
for i=1:size(A,1)*size(A,2)
        [I,J]=ind2sub(size(A),i);
        if I+1 <= size(A,1)
        W(i,sub2ind(size(A),I+1,J))=abs(A(I+1,J)-A(I,J));
        end
        if I-1 >= 1
        W(i,sub2ind(size(A),I-1,J))=abs(A(I-1,J)-A(I,J));
        end
        if J+1 <= size(A,2)
        W(i,sub2ind(size(A),I,J+1))=abs(A(I,J+1)-A(I,J));
        end
        if J-1 >= 1
        W(i,sub2ind(size(A),I,J-1))=abs(A(I,J-1)-A(I,J));
        end
        W=sparse(W);
end
%Normalize the weights in W such that their values are between 0 and 1
W = sparse((W - min(W(:))) ./ (max(W(:)) - min(W(:)) + eps));

EPSILON = 10e-6;
%Compute final exponential weights
for i=1:size(A,1)*size(A,2)
        [I,J]=ind2sub(size(A),i);
        W(i,i)=-1.0;
        if I+1 <= size(A,1)
        W(i,sub2ind(size(A),I+1,J))=-((exp(-beta*W(i,sub2ind(size(A),I+1,J)))) + EPSILON);        
        W(i,i)=-1*(W(i,sub2ind(size(A),I+1,J)));
        end
        if I-1 >= 1
        W(i,sub2ind(size(A),I-1,J))=-((exp(-beta*W(i,sub2ind(size(A),I-1,J)))) + EPSILON);
        if I+1 > size(A,1)
            W(i,i)=-1*(W(i,sub2ind(size(A),I-1,J)));
        end
        end
        if J+1 <= size(A,2)
        W(i,sub2ind(size(A),I,J+1))=-((exp(-beta*W(i,sub2ind(size(A),I,J+1)))) + EPSILON);
        W(i,i)=W(i,i)-W(i,sub2ind(size(A),I,J+1));
        end
        if J-1 >= 1
        W(i,sub2ind(size(A),I,J-1))=-((exp(-beta*W(i,sub2ind(size(A),I,J-1)))) + EPSILON);
        if J+1 > size(A,2)
        W(i,i)=W(i,i)-W(i,sub2ind(size(A),I,J-1));
        end
        end
        W=sparse(W);        
end
%Compute the graph Laplacian matrix from the final exponential weight
%matrix.
L=sparse(W);

%Assemble Lu by selecting rows and columns corresponding to unmarked nodes in the GraphLaplacian
seeds
end

