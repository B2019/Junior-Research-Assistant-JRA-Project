%Brain Body Environment Open Loop v1
close all;
clc
clear all
dt = 0.01;
replayTime = 1000; %Amount of replay time
phases = 10; %Number of different gain phases in recorded (replay) time
time = (replayTime / phases) + (replayTime * 2);
T = dt:dt:time;

Brain(1) = 0;
Body(1) = 0;
Env(1) = 0;

wBrain_Body = 1;
wBody_Brain = 1;
wBody_Env = -1;

%Gain parameter
high = 5;
low = 2;
K(1:(replayTime/phases)/dt) = low; %Initial unrecorded gain phase
for n = 1:2:phases %Loop through phase pairs
    K(((replayTime/phases)*n)/dt + 1:((replayTime/phases)*(n+1))/dt) = high; %Set high gain phase
    K(((replayTime/phases)*(n+1))/dt + 1:((replayTime/phases)*(n+2))/dt) = low; %Set low gain phase
end

flowV = -1;

for t = 1:(time - replayTime)/dt - 1
    Brain(t+1) = Brain(t) + dt * tanh(-Brain(t) + wBrain_Body * Body(t));
    Body(t+1) = Body(t) + dt * tanh(-Body(t) + wBody_Brain * Brain(t) + wBody_Env * Env(t) + randn);
    Env(t+1) = K(t) * Body(t) + flowV;
end

for t = (time - replayTime)/dt:time/dt - 1
    Brain(t+1) = Brain(t) + dt * tanh(-Brain(t) + wBrain_Body * Body(t));
    Body(t+1) = Body(t) + dt * tanh(-Body(t) + wBody_Brain * Brain(t) + wBody_Env * Env(t-replayTime/dt+1) + randn);
    Env(t+1) = K(t-replayTime/dt+1) * Body(t) + flowV;
end


plot(T,Env);

figure()
plot(T,Body)


