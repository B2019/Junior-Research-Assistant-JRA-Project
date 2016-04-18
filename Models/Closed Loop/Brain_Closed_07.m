%Brain_Closed_07.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Closed loop CTRNN model showing motor adaption of 
%Francis Poole
%28.7.14

close all
clf;
clc;
clear;

%Init
dt = 0.01; %Time step (0.01)
T = 80; %Amount of time
time = 0:dt:T; %Time array
tau_b = 1; %Time scale (1)

M(1) = 0; %Motor node start (0)
S(1) = 0; %Sensor node start (0)

w_M = 0; %Motor weight (0)
w_S = 0; %Sensor weight (0)
w_MS = 1; %Motor <- Sensor weight (1)
w_SM = 1; %Sensor <- Motor weight (1)

flow_V = -2; %Flow velocity of water
swim_V(1) = 0; %Swim velocity of fish. Start at rest (0)

fish_X(1) = 0; %Starting fish x position (0)

%Gain parameter
%K(1:T/dt + 1) = 1; %Constant gain
%    OR
high = 10; %(10)
low = 2; %(2)
rest = 0; %(0);
K(1:(T/dt+1)/4) = high;
K((T/dt+1)/4:(T/dt+1)/2) = low;
K((T/dt+1)/2:3*(T/dt+1)/4) = high;
K(3*(T/dt+1)/4:(T/dt+1)) = low;

for t = 1:length(time) - 1
    M(t+1) = M(t) + 1/tau_b * dt * (-M(t) + w_M * M(t) + w_MS * S(t)); %Update motor node
    S(t+1) = S(t) + 1/tau_b * dt * (-S(t) + w_S * S(t) + w_SM * M(t) - (swim_V(t) + flow_V) + randn / sqrt(dt)); %Update sensor node
    X1(t+1) =  w_SM * M(t);
    X2(t+1) = -(swim_V(t) + flow_V);
    swim_V(t+1) = K(t+1) * M(t+1); %Update swim velocity
    fish_X(t+1) = fish_X(t) + dt * (swim_V(t) + flow_V); %Update fish position
end
swim_V(t+1) = K(t) * M(t); %Update final swim velocity
figure;
plot(time,X1,'r',time,X2,'b');
hold on; plot(time,X1+X2,'m');

%Plot 1
%Fish Movement Animation
% for t = 1:10:length(time) - 1
%     plot(time(1:t),fish_X(1:t),'g');
%     hold on
%     plot(time(t),fish_X(t),'gO');
%     hold off
%     xlim([0,T]);
%     ylim([min(fish_X),max(fish_X)]);
%     pause(0.01);
% end

%Plot 2
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

%Sensor
subplot(2,2,3)
area([0,T/4],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([T/4,T/2],[4,4],-4,'FaceColor','w','LineStyle','none')
area([T/2,3*T/4],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*T/4,T],[4,4],-4,'FaceColor','w','LineStyle','none')
plot(time, S)
hold off;
ylim([-4,4]);
xlim([0,T]);
title('Sensor');

%Motor
subplot(2,2,4);
area([0,T/4],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
hold on;
area([T/4,T/2],[4,4],-4,'FaceColor','w','LineStyle','none')
area([T/2,3*T/4],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
area([3*T/4,T],[4,4],-4,'FaceColor','w','LineStyle','none')
plot(time, M);
hold off;
ylim([-4,4]);
xlim([0,T]);
title('Motor');