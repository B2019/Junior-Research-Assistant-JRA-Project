%Brain_Closed_04.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Closed loop CTRNN model of motor adaption with modulated gain
%Francis Poole
%14.7.14

clf;
clc;
clear;

%Init
dt = 0.01; %Time step
T = 30; %Amount of time
time = 0:dt:T; %Time array

m(1) = 0; %Motor node start
s(1) = 0; %Sensor node start
wM = 100; %Motor weight
wS = 100; %Sensor weight
wMS = 100; %Motor <- Sensor weight
wSM = 100; %Sensor <- Motor weight

%Gain parameter
 K(1:T/dt+1) = 1;
%    OR
% K(1:(T/dt+1)/4) = 2;
% K((T/dt+1)/4:(T/dt+1)/2) = 3;
% K((T/dt+1)/2:3*(T/dt+1)/4) = 2;
% K(3*(T/dt+1)/4:(T/dt+1)) = 3;

%Flow velocity of water.
flowV(1:T/dt+1) = -1;
%    OR
% flowV(1:(T/dt+1)/4) = -1; %Flow velocity of water
% flowV((T/dt+1)/4:(T/dt+1)/2) = 0;
% flowV((T/dt+1)/2:3*(T/dt+1)/4) = -1;
% flowV(3*(T/dt+1)/4:(T/dt+1)) = 0;

%Swim velocity of fish. Start at rest
swimV(1) = 0;

tau_b = 1; %Time scale

fishX(1) = 0; %Starting fish x position

for t = 1:length(time) - 1
    swimV(t) = K(t) * m(t); %Update swim velocity
    relativeV(t) = swimV(t) + flowV(t);
    m(t+1) = m(t) + 1/tau_b * dt * (-m(t) + tanh((wM * m(t)) + wMS * s(t)) + (randn/sqrt(dt))); %Update motor node
    s(t+1) = s(t) + 1/tau_b * dt * (-s(t) + tanh((wS * s(t)) + wSM * m(t) - (swimV(t) + flowV(t))) + (randn/sqrt(dt))); %Update sensor node
    fishX(t+1) = fishX(t) + dt * relativeV(t);
    randn/sqrt(dt)
end
swimV(t+1) = K(t) * m(t);

fishX(t)

t*dt*flowV(t)

t

for t = 1:50:length(time) - 1
    hold on
    plot(fishX(t),-t,'gO');
    plot(t*dt*flowV(t),-t,'bO');
    %xlim([-5,0.5]);
    pause(0.01);
    hold off
end

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