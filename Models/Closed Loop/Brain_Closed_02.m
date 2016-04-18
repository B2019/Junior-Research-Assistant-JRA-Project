%Brain_Closed_02.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Closed loop CTRNN model of motor adaption with modulated gain
%Francis Poole
%8.7.14

clf;
clc;
clear;

%Init
dt = 0.01; %Time step
T = 30; %Amount of time
time = 0:dt:T; %Time array

m(1) = 0; %Motor node start
s(1) = 0; %Sensor node start
wM = 0; %Motor weight
wS = 0; %Sensor weight
wMS = 50; %Motor <- Sensor weight
wSM = 0; %Sensor <- Motor weight

%Gain parameter
% K(1:T/dt+1) = 1;
%    OR
K(1:(T/dt+1)/4) = 1;
K((T/dt+1)/4:(T/dt+1)/2) = 2;
K((T/dt+1)/2:3*(T/dt+1)/4) = 1;
K(3*(T/dt+1)/4:(T/dt+1)) = 2;

%Flow velocity of water.
flowV(1:T/dt+1) = -1;
%    OR
% flowV(1:(T/dt+1)/4) = -1; %Flow velocity of water
% flowV((T/dt+1)/4:(T/dt+1)/2) = 0;
% flowV((T/dt+1)/2:3*(T/dt+1)/4) = -1;
% flowV(3*(T/dt+1)/4:(T/dt+1)) = 0;

%Swim velocity of fish. Start at rest
swimV(1) = 0; 

tau_b = 1;

for t = 1:length(time) - 1
    swimV(t) = K(t) * m(t); %Update swim velocity
    m(t+1) = m(t) + 1/tau_b * dt * (-m(t) + (wM * m(t)) + wMS * s(t)); %Update motor node
    s(t+1) = s(t) + 1/tau_b * dt * (-s(t) + (wS * s(t)) + wSM * m(t) - (swimV(t) + flowV(t))); %Update sensor node
end
swimV(t+1) = K(t) * m(t);


%Plot
subplot(2,2,1)
plot(time,flowV+swimV);
hold on
plot(time,K,'r');
plot(time,flowV,'g');
hold off
title('Relative Velocity');
ylim([-3,3]);


subplot(2,2,3)
plot(time, s)
title('Sensor');

subplot(2,2,4);
plot(time, m);
title('Motor');