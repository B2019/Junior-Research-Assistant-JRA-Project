%Brain_Open_01.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Open loop CTRNN model showing motor adaption of 
%Francis Poole
%24.7.14

clf;
clc;
clear;

%Init
dt = 0.01; %Time step (0.01)
initialTime = 80; %Amount of closed loop (initial) time
replayTime = 60; %Amount of open loop (replay) time
T = initialTime + replayTime; %Amount of time
time = 0:dt:T; %Time array
tau_b = 1; %Time scale (1)

M(1) = 0; %Motor node start (0)
S(1) = 0; %Sensor node start (0)

w_M = 0; %Motor weight (0)
w_S = 0; %Sensor weight (0)
w_MS = 1; %Motor <- Sensor weight (1)
w_SM = 1; %Sensor <- Motor weight (1)

flow_V = -3; %Flow velocity of water
swim_V(1) = 0; %Swim velocity of fish. Start at rest (0)

fish_X(1) = 0; %Starting fish x position (0)

%Gain parameter
%K(1:T/dt + 1) = 1; %Constant gain
%    OR
phase = ((T - replayTime)/dt + 1)/8; %Phase time
high = 5;
low = 1;
K(1:phase) = high;
K(phase:phase*2) = low;
K(phase*2:phase*3) = high;
K(phase*3:phase*4) = low;
K(phase*4:phase*5) = high;
K(phase*5:phase*6) = low;
K(phase*6:phase*7) = high;
K(phase*7:phase*8 + 1) = low;

%Closed loop swim
for t = 1:(T-replayTime)/dt - 1
    M(t+1) = M(t) + 1/tau_b * dt * (-M(t) + w_M * M(t) + w_MS * S(t) + randn / sqrt(dt)); %Update motor node
    S(t+1) = S(t) + 1/tau_b * dt * (-S(t) + w_S * S(t) + w_SM * M(t) - (swim_V(t) + flow_V) + randn / sqrt(dt)); %Update sensor node
    swim_V(t+1) = K(t+1) * M(t+1); %Update swim velocity
    fish_X(t+1) = fish_X(t) + dt * (swim_V(t) + flow_V); %Update fish position
end
swim_V(t+1) = K(t) * M(t); %Update final swim velocity

%Open loop swim (replayTime)
for t = (T-replayTime)/dt:length(time) - 1
    M(t+1) = M(t) + 1/tau_b * dt * (-M(t) + w_M * M(t) + w_MS * S(t) + randn / sqrt(dt)); %Update motor node
    S(t+1) = S(t) + 1/tau_b * dt * (-S(t) + w_S * S(t) - (swim_V(t-replayTime/dt+1) + flow_V) );
    swim_V(t+1) = K(t-replayTime/dt+1) * M(t+1); %Update swim velocity
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
area([0,(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([(T-replayTime)/8,2*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([2*(T-replayTime)/8,3*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*(T-replayTime)/8,4*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([4*(T-replayTime)/8,5*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([5*(T-replayTime)/8,6*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([6*(T-replayTime)/8,7*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([7*(T-replayTime)/8,T-replayTime],[50,50],-50,'FaceColor','w','LineStyle','none')
area([T-replayTime,T],[50,50],-50,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time,fish_X,'g');
axis([0,T,-50,50])
hold off;

title('Fish Position');

%Relative Velocity
subplot(2,2,2)
area([0,(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([(T-replayTime)/8,2*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([2*(T-replayTime)/8,3*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*(T-replayTime)/8,4*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([4*(T-replayTime)/8,5*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([5*(T-replayTime)/8,6*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([6*(T-replayTime)/8,7*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([7*(T-replayTime)/8,T-replayTime],[50,50],-50,'FaceColor','w','LineStyle','none')
area([T-replayTime,T],[50,50],-50,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time,flow_V+swim_V);
hold off
ylim([-10,10]);
xlim([0,T]);
title('Relative Velocity');

%Sensor
subplot(2,2,3)
area([0,(T-replayTime)/6],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([(T-replayTime)/8,2*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([2*(T-replayTime)/8,3*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*(T-replayTime)/8,4*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([4*(T-replayTime)/8,5*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([5*(T-replayTime)/8,6*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([6*(T-replayTime)/8,7*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([7*(T-replayTime)/8,T-replayTime],[50,50],-50,'FaceColor','w','LineStyle','none')
area([T-replayTime,T],[50,50],-50,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time, S)
hold off;
ylim([-4,4]);
xlim([0,T]);
title('Sensor');

%Motor
subplot(2,2,4);
area([0,(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([(T-replayTime)/8,2*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([2*(T-replayTime)/8,3*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*(T-replayTime)/8,4*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([4*(T-replayTime)/8,5*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([5*(T-replayTime)/8,6*(T-replayTime)/8],[50,50],-50,'FaceColor','w','LineStyle','none')
area([6*(T-replayTime)/8,7*(T-replayTime)/8],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([7*(T-replayTime)/8,T-replayTime],[50,50],-50,'FaceColor','w','LineStyle','none')
area([T-replayTime,T],[50,50],-50,'FaceColor',[1,1,0.8],'LineStyle','none')
plot(time, M);
hold off;
ylim([-4,4]);
xlim([0,T]);
title('Motor');


figure();
plot(time((T-replayTime-replayTime)/dt:(T-replayTime)/dt), M((T-replayTime-replayTime)/dt:(T-replayTime)/dt));
hold on
plot(time((T-replayTime-replayTime)/dt:(T-replayTime)/dt), M((T-replayTime)/dt:(T)/dt),'g');
hold off