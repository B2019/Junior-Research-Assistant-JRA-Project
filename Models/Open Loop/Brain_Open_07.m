%Brain_Open_07.m
%Project Title: An agent based model of motor adaption in larval zebrafish
%Description: Open loop CTRNN model showing motor adaption of 
%Francis Poole
%10.8.14

close all;
clc;
clear;

%Init
dt = 0.01; %Time step (0.01)
replayT = 1000; %Amount of replay time
phases = 10; %Number of different gain phases in recorded (replay) time
T = (replayT / phases) + (replayT * 2); %Total amount of time. Initial unrecorded single phase time plus recorded time plus replay time
phaseTime = replayT/phases;
time = dt:dt:T; %Time array
tau_b = 1; %Time scale (1)

M(1) = 0; %Motor node start (0)
S(1) = 0; %Sensor node start (0)

w_M = 0; %Motor weight (0)
w_S = 0; %Sensor weight (0)
w_MS = 1; %Motor <- Sensor weight (1)
w_SM = 1; %Sensor <- Motor weight (1)

flow_V = -1; %Flow velocity of water
swim_V(1) = 0; %Swim velocity of fish. Start at rest (0)

fish_X(1) = 0; %Starting fish x position (0)

%Gain parameter
high = 1;
low = 10;
K(1:(replayT/phases)/dt) = low; %Initial phase
for n = 1:2:phases %Loop through phase pairs
    K(((replayT/phases)*n)/dt + 1:((replayT/phases)*(n+1))/dt) = high; %Set high gain phase
    K(((replayT/phases)*(n+1))/dt + 1:((replayT/phases)*(n+2))/dt) = low; %Set low gain phase
end

%Closed loop swim
for t = 1:(T - replayT)/dt - 1
    M(t+1) = M(t) + 1/tau_b * dt * (-M(t) + w_M * M(t) + w_MS * S(t)); %Update motor node
    S(t+1) = S(t) + 1/tau_b * dt * (-S(t) + w_S * S(t) + w_SM * M(t) - (swim_V(t) + flow_V) + randn / sqrt(dt)); %Update sensor node
    X1(t+1) =  w_SM * M(t);
    X2(t+1) = -(swim_V(t) + flow_V);
    swim_V(t+1) = K(t+1) * M(t+1); %Update swim velocity
    fish_X(t+1) = fish_X(t) + dt * (swim_V(t) + flow_V); %Update fish position
end

%Open loop swim
for t = (T - replayT)/dt:T/dt - 1
    M(t+1) = M(t) + 1/tau_b * dt * (-M(t) + w_M * M(t) + w_MS * S(t)); %Update motor node
    S(t+1) = S(t) + 1/tau_b * dt * (-S(t) + w_S * S(t) + w_SM * M(t) - (swim_V(t-replayT/dt+1) + flow_V) + randn / sqrt(dt));
    X1(t+1) =  w_SM * M(t);
    X2(t+1) = -(swim_V(t-replayT/dt+1) + flow_V);
    swim_V(t+1) = K(t-replayT/dt) * M(t+1); %Update swim velocity
    fish_X(t+1) = fish_X(t) + dt * (swim_V(t) + flow_V); %Update fish position
end


figure;
plot(time,X1,'r');
hold on
plot(time,X2,'b');
plot(time,X1+X2,'m');
hold off

%Fourrier Transform
[powerClosed,f,AS] = cb_FFT(M((T-replayT-replayT)/dt:(T-replayT)/dt),dt);
[powerOpen,f,AS] = cb_FFT(M((T-replayT)/dt:(T)/dt),dt);

%Calculate Correlations
closedCorrelation = corr(M((T-replayT-replayT)/dt:(T-replayT)/dt)',S((T-replayT-replayT)/dt:(T-replayT)/dt)')
openCorrelation = corr(M((T-replayT)/dt:(T)/dt)',S((T-replayT)/dt:(T)/dt)')
fourrierCorrelation = corr(powerClosed',powerOpen')

    %PLOTTING
%Plot 1
%Power and Correlation
figure()
subplot(1,2,1)
bar([mean(powerOpen) mean(powerClosed)])
set(gca,'XTickLabel',{'Replay', 'Closed'})
title('Power')
subplot(1,2,2)
bar([abs(openCorrelation) abs(closedCorrelation)])
set(gca,'XTickLabel',{'Replay', 'Closed'})
title('Correlation')

% 
% %Plot 2
% %Fish Position
% figure()
% %Draw phases
% area([0,(replayT/phases)],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% hold on;
% for n = 1:2:phases
%     area([(replayT/phases)*n, (replayT/phases)*(n+1)],[50,50],-50,'FaceColor','w','LineStyle','none')
%     area([(replayT/phases)*(n+1), (replayT/phases)*(n+2)],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% end
% area([T-replayT,T],[50,50],-50,'FaceColor',[1,1,0.8],'LineStyle','none')
% %Plot graph
% plot(time,fish_X,'g');
% axis([0,T,-50,50])
% hold off;
% title('Fish Position');
% 
% %Relative Velocity
% figure()
% %Draw phases
% area([0,(replayT/phases)],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% hold on;
% for n = 1:2:phases
%     area([(replayT/phases)*n, (replayT/phases)*(n+1)],[50,50],-50,'FaceColor','w','LineStyle','none')
%     area([(replayT/phases)*(n+1), (replayT/phases)*(n+2)],[50,50],-50,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% end
% area([T-replayT,T],[50,50],-50,'FaceColor',[1,1,0.8],'LineStyle','none')
% plot(time,flow_V+swim_V);
% hold off
% ylim([-10,10]);
% xlim([0,T]);
% title('Relative Velocity');
% 
% %Sensor
% figure()
% %Draw phases
% area([0,(replayT/phases)],[max(S),max(S)],min(S),'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% hold on;
% for n = 1:2:phases
%     area([(replayT/phases)*n, (replayT/phases)*(n+1)],[max(S),max(S)],min(S),'FaceColor','w','LineStyle','none')
%     area([(replayT/phases)*(n+1), (replayT/phases)*(n+2)],[max(S),max(S)],min(S),'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% end
% area([T-replayT,T],[max(S),max(S)],min(S),'FaceColor',[1,1,0.8],'LineStyle','none')
% plot(time, S)
% hold off;
% ylim([min(S),max(S)]);
% xlim([0,T]);
% title('Sensor');
% 
% %Motor
% figure()
% %Draw phases
% area([0,(replayT/phases)],[max(M),max(M)],min(M),'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% hold on;
% for n = 1:2:phases
%     area([(replayT/phases)*n, (replayT/phases)*(n+1)],[max(M),max(M)],min(M),'FaceColor','w','LineStyle','none')
%     area([(replayT/phases)*(n+1), (replayT/phases)*(n+2)],[max(M),max(M)],min(M),'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
% end
% area([T-replayT,T],[max(M),max(M)],min(M),'FaceColor',[1,1,0.8],'LineStyle','none')
% plot(time, M);
% hold off;
% ylim([min(M),max(M)]);
% xlim([0,T]);
% title('Motor');
% 
% %Closed vs Open (replay) comaprison
% % figure();
% % plot(time((T-replayT-replayT)/dt:(T-replayT)/dt), M((T-replayT-replayT)/dt:(T-replayT)/dt));
% % hold on
% % plot(time((T-replayT-replayT)/dt:(T-replayT)/dt), M((T-replayT)/dt:(T)/dt),'g');
% % hold off
% 
% %Plot fourriers
% figure()
% plot(f,powerClosed,'r');
% hold on
% plot(f,powerOpen);
% hold off
% legend('Closed','Replay');
% xlim([0 0.1])
% title('Fourriers');

