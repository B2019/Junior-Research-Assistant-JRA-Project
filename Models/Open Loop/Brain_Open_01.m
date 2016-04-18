%Brain_Open_01.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Open loop CTRNN model showing motor adaption of 
%Francis Poole
%20.7.14

clf;
clc;
clear;

%Init
dt = 0.01; %Time step
T = 100; %Amount of time
time = 0:dt:T; %Time array
tau_b = 1; %Time scale
replay = 40; %Amount of replay time

M(1) = 0; %Motor node start
S(1) = 0; %Sensor node start

w_M = 0; %Motor weight
w_S = 0; %Sensor weight
w_MS = 1; %Motor <- Sensor weight
w_SM = 1; %Sensor <- Motor weight

flow_V = -1; %Flow velocity of water
swim_V(1) = 0; %Swim velocity of fish. Start at rest

fish_X(1) = 0; %Starting fish x position

%Gain parameter
%K(1:T/dt + 1) = 1;
%    OR
K(1:(T+1)/dt) = 5;
K(11/dt:20/dt) = 3;
K(31/dt:40/dt) = 3;
K(51/dt:60/dt) = 3;

for t = 1:(T-replay)/dt
    M(t+1) = M(t) + 1/tau_b * dt * (-M(t) + w_M * M(t) + w_MS * S(t) + randn / sqrt(dt)); %Update motor node
    S(t+1) = S(t) + 1/tau_b * dt * (-S(t) + w_S * S(t) + w_SM * M(t) - (swim_V(t) + flow_V) + randn / sqrt(dt)); %Update sensor node
    swim_V(t+1) = K(t+1) * M(t+1); %Update swim velocity
    fish_X(t+1) = fish_X(t) + dt * (swim_V(t) + flow_V); %Update fish position
end
swim_V(t+1) = K(t) * M(t); %Update final swim velocity

for t = 60/dt:length(time) - 1
    M(t+1) = M(t) + 1/tau_b * dt * (-M(t) + w_M * M(t) + w_MS * S(t) + randn * sqrt(dt)); %Update motor node
    S(t+1) = S(t-replay/dt); %Update sensor node
    swim_V(t+1) = K(t+1) * M(t+1); %Update swim velocity
    fish_X(t+1) = fish_X(t) + dt * (swim_V(t) + flow_V); %Update fish position
    
end


%Plot 1
%Fish Movement Animation
% for t = 1:10:length(time) - 1
%     plot(time(1:t),fish_X(1:t),'g');
%     hold on
%     plot(time(t),fish_X(t),'gO');
%     hold off
%     xlim([0,T]);
%     ylim([min(fish_X),0]);
%     pause(0.01);
% end

%Plot 2
%Fish Position
subplot(2,2,1)
area([0,10],[2,2],-2,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([10,20],[1.5,1.5],-1.5,'FaceColor','w','LineStyle','none')
area([20,30],[1.5,1.5],-1.5,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([30,40],[1.5,1.5],-1.5,'FaceColor','w','LineStyle','none')
area([40,50],[1.5,1.5],-1.5,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([50,60],[1.5,1.5],-1.5,'FaceColor','w','LineStyle','none')
area([60,T],[1.5,1.5],-1.5,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time,fish_X,'g');
axis([0,T,-1,0])
hold off;

title('Fish Position');

%Relative Velocity
subplot(2,2,2)
area([0,10],[2,2],-2,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([10,20],[1,1],-1,'FaceColor','w','LineStyle','none')
area([20,30],[1,1],-1,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([30,40],[1,1],-1,'FaceColor','w','LineStyle','none')
area([40,50],[1,1],-1,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([50,60],[1,1],-1,'FaceColor','w','LineStyle','none')
area([60,T],[1.5,1.5],-1.5,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time,flow_V+swim_V);
hold off
ylim([-1,1]);
xlim([0,T]);
title('Relative Velocity');

%Sensor
subplot(2,2,3)
area([0,10],[2,2],-2,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([10,20],[1,1],-1,'FaceColor','w','LineStyle','none')
area([20,30],[1,1],-1,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([30,40],[1,1],-1,'FaceColor','w','LineStyle','none')
area([40,50],[1,1],-1,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([50,60],[1,1],-1,'FaceColor','w','LineStyle','none')
area([60,T],[1.5,1.5],-1.5,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time, S)
hold off;
ylim([-1,1]);
xlim([0,T]);
title('Sensor');

%Motor
subplot(2,2,4);
area([0,10],[2,2],-2,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([10,20],[1,1],-1,'FaceColor','w','LineStyle','none')
area([20,30],[1,1],-1,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([30,40],[1,1],-1,'FaceColor','w','LineStyle','none')
area([40,50],[1,1],-1,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([50,60],[1,1],-1,'FaceColor','w','LineStyle','none')
area([60,T],[1.5,1.5],-1.5,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time, M);
hold off;
ylim([-1,1]);
xlim([0,T]);
title('Motor');