%Reaffereance/ exafferance
close all;
clc
clear all
dt = 0.01;
time = 400;
T = 0:dt:time;

K(1:(time/dt+1)/4) = 1;
K((time/dt+1)/4:(time/dt+1)/2) = 2;
K((time/dt+1)/2:3*(time/dt+1)/4) = 1;
K(3*(time/dt+1)/4:(time/dt+1)) = 2;

Brain(1) = 0;
Body(1) = 0;
Env(1) = 0;

wBrain_Body = 1;
wBody_Brain = 1;
wBody_Env = -1;

flowV = -1;

for t = 1:length(T) - 1
    Brain(t+1) = Brain(t) + dt * tanh(-Brain(t) + wBrain_Body * Body(t));
    Body(t+1) = Body(t) + dt * tanh(-Body(t) + wBody_Brain * Brain(t) + wBody_Env * Env(t) + randn);
    Env(t+1) = K(t) * Body(t) + flowV;
end


plot(T,Env);

figure()
plot(T,Body)


mean(Env)
