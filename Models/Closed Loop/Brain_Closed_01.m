%Brain_Closed_01.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Closed loop CTRNN model of motor adaption with modulated gain
%Francis Poole
%7.7.14

clc;
clear;

%Init
dt = 0.01; %Time step
T = 100; %Amount of time
time = 0:dt:T; %Time array

flowV = -1; %Flow velocity of water
swimV = 0; %Swim velocity of fish

m(1) = 0; %Motor node start
s(1) = 0; %Sensor node start
wM = 0; %Motor weight
wS = 0; %Sensor weight
wSM = 10; %Sensor -> motor weight
wMS = 0; %Motor -> Sensor weight

K = 1; %Gain parameter

for t = 1:length(time)-1
    swimV = -swimV + (K * motor(t)) %Update swim velocity
    s(t+1) = s(t) + dt * (-s(t) + (wS * s(t)) + (wMS * m(t)) + (swimV - flowV)); %Update sensor node
    m(t+1) = m(t) + dt * (-m(t) + (wM * m(t)) + (wSM * s(t))); %Update motor node
end