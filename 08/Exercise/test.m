% clear all
clc; clear all; close all;
% Load image
A = im2double(imread('CTAbdomen.png'));

size_i=size(A, 1);
size_j=size(A, 2);
size_A=size(A);

beta = 90;
nzA=4*3+(size_i-2)*4*2+(size_j-2)*4*2+(size_i-2)*(size_j-2)*5;
W=spalloc(size_i,size_j,nzA);
tic
for i=1:size_i*size_j
        [I,J]=ind2sub(size_A,i);
        if I+1 <= size_i
        W(i,sub2ind(size_A,I+1,J))=abs(A(I+1,J)-A(I,J));
        end
        if I-1 >= 1
        W(i,sub2ind(size_A,I-1,J))=abs(A(I-1,J)-A(I,J));
        end
        if J+1 <= size_j
        W(i,sub2ind(size_A,I,J+1))=abs(A(I,J+1)-A(I,J));
        end
        if J-1 >= 1
        W(i,sub2ind(size_A,I,J-1))=abs(A(I,J-1)-A(I,J));
        end
        %W=sparse(W);
end
toc
%Normalize weights
tic
W = sparse((W - min(W(:))) ./ (max(W(:)) - min(W(:)) + eps));
%Gaussian weighting
EPSILON = 10e-6;
toc
tic
% for i=1:size_i*size_j
%         [I,J]=ind2sub(size_A,i);
%         if I+1 <= size_i
%         W(i,sub2ind(size_A,I+1,J))=-((exp(-beta*W(i,sub2ind(size_A,I+1,J)))) + EPSILON);        
%         W(i,i)=-1*(W(i,sub2ind(size_A,I+1,J)));
%         end
%         if I-1 >= 1
%         W(i,sub2ind(size_A,I-1,J))=-((exp(-beta*W(i,sub2ind(size_A,I-1,J)))) + EPSILON);
%         if I+1 > size_i
%             W(i,i)=-1*(W(i,sub2ind(size_A,I-1,J)));
%         end
%         end
%         if J+1 <= size_j
%         W(i,sub2ind(size_A,I,J+1))=-((exp(-beta*W(i,sub2ind(size_A,I,J+1)))) + EPSILON);
%         W(i,i)=W(i,i)-W(i,sub2ind(size_A,I,J+1));
%         end
%         if J-1 >= 1
%         W(i,sub2ind(size_A,I,J-1))=-((exp(-beta*W(i,sub2ind(size_A,I,J-1)))) + EPSILON);
%         if J+1 > size_j
%         W(i,i)=W(i,i)-W(i,sub2ind(size_A,I,J-1));
%         end
%         end
%    %     W=sparse(W);        
% end
[row,col,V]= find(W);
V=-((exp(-beta*V)) + EPSILON);
for i=1:size(row)
    W(row(i),col(i))=V(i);
end
% for i=1:size_i*size_j
%         [I,J]=ind2sub(size_A,i);
%         if I+1 <= size_i
%         W(i,sub2ind(size_A,I+1,J))=-((exp(-beta*W(i,sub2ind(size_A,I+1,J)))) + EPSILON);        
%         W(i,i)=-1*(W(i,sub2ind(size_A,I+1,J)));
%         end
%         if I-1 >= 1
%         W(i,sub2ind(size_A,I-1,J))=-((exp(-beta*W(i,sub2ind(size_A,I-1,J)))) + EPSILON);
%         if I+1 > size_i
%             W(i,i)=-1*(W(i,sub2ind(size_A,I-1,J)));
%         end
%         end
%         if J+1 <= size_j
%         W(i,sub2ind(size_A,I,J+1))=-((exp(-beta*W(i,sub2ind(size_A,I,J+1)))) + EPSILON);
%         W(i,i)=W(i,i)-W(i,sub2ind(size_A,I,J+1));
%         end
%         if J-1 >= 1
%         W(i,sub2ind(size_A,I,J-1))=-((exp(-beta*W(i,sub2ind(size_A,I,J-1)))) + EPSILON);
%         if J+1 > size_j
%         W(i,i)=W(i,i)-W(i,sub2ind(size_A,I,J-1));
%         end
%         end
%    %     W=sparse(W);        
% end
toc
tic
L=sparse(W);
toc

