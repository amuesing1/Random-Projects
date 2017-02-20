clear all
close all
clc

n=10000;
for h=1:n

A(1,:)=randperm(100);
B=1;

for i=1:100
    k=0;
    l=0;
    j=i;
    A(2,j)=A(1,i);
    while A(2,i)~=101
        if A(1,j)==i
            A(2,i)=101;
        else
            j=A(1,j);
            k=k+1;
            l=l+1;
        end
        if k==50
            B=-1;
        end
    end
        D(i)=l;
        E(h)=max(D);
end

C(h)=B;
end
count=0;
for i=1:n
    if C(i)==1
        count=count+1;
    end
end
hist(E,100)
xlabel('length of longest string')
ylabel('amount')
percent=(count/n)*100
