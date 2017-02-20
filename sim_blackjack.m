close all
clear all
clc

S=blackjacksim(1000,6,0);
x=linspace(1,length(S),length(S));
fit=polyfit(x,S,1);
per_hand=S(end)/x(end);


figure
hold on
plot(x,S)
plot(x,x*fit(1)+fit(2))
xlabel('number of hands')
ylabel('money')