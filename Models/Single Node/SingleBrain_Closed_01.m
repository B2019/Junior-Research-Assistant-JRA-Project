%SingleBrain_Closed_01.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Closed loop CTRNN model showing motor adaption of 
%Francis Poole
%28.7.14

clf;
clc;
clear;

%Init
dt = 0.01; %Time step (0.01)
T = 80; %Amount of time
time = 0:dt:T; %Time array
tau_b = 1; %Time scale (1)

y(1) = 0; %Node start (0)

w_y = 1; %Node y weight (0)

flow_V = -5; %Flow velocity of water
swim_V(1) = 0; %Swim velocity of fish. Start at rest (0)

fish_X(1) = 0; %Starting fish x position (0)

%Gain parameter
% K(1:T/dt + 1) = 1; %Constant gain
%    OR
high = 10; %(10)
low = 2; %(2)
rest = 0; %(0);
K(1:(T/dt+1)/4) = low;
K((T/dt+1)/4:(T/dt+1)/2) = high;
K((T/dt+1)/2:3*(T/dt+1)/4) = low;
K(3*(T/dt+1)/4:(T/dt+1)) = high;

for t = 1:length(time) - 1
    y(t+1) = y(t) + 1/tau_b * dt * (-y(t) + y(t) * w_y - swim_V(t) - flow_V + randn / sqrt(dt)); %Update sensor node
    swim_V(t+1) = K(t+1) * y(t+1); %Update swim velocity
    fish_X(t+1) = fish_X(t) + dt * (swim_V(t) + flow_V); %Update fish position
end
swim_V(t+1) = K(t) * y(t); %Update final swim velocity






%Plot
%Fish Position
subplot(2,2,1)
area([0,T/4],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([T/4,T/2],[50,50],-50,'FaceColor','w','LineStyle','none')
area([T/2,3*T/4],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*T/4,T],[50,50],-50,'FaceColor','w','LineStyle','none')
plot(time,fish_X,'g');
plot([0,T],[0,T/dt*flow_V]);
%axis([0,T,-1.5,0])
hold off;
xlim([0,T]);
ylim([-50,50])

title('Fish Position');

%Relative Velocity
subplot(2,2,2)
area([0,T/4],[10,10],-10,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([T/4,T/2],[10,10],-10,'FaceColor','w','LineStyle','none')
area([T/2,3*T/4],[10,10],-10,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*T/4,T],[10,10],-10,'FaceColor','w','LineStyle','none')
plot(time,flow_V+swim_V,'k');
hold off
ylim([-10,10]);
xlim([0,T]);
title('Relative Velocity');

%Node y
subplot(2,2,3)
area([0,T/4],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([T/4,T/2],[4,4],-4,'FaceColor','w','LineStyle','none')
area([T/2,3*T/4],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*T/4,T],[4,4],-4,'FaceColor','w','LineStyle','none')
plot(time, y)
hold off;
ylim([-4,4]);
xlim([0,T]);
title('Node y');