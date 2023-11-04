function [] = nvue(fname,estID,filt_order)
% NVUE  ABP/CO viewer
%   NVUE(FNAME, ESTID, FILT_ORDER) views ABP waveform, estimated CO, and
%   features.
%
%   In:   FNAME      (string)   file name -- e.g. fname='~/170.mat';
%         ESTID      (integer)  choose which CO estimation algorithm to use
%         FILT_ORDER (integer)  order of running avg LPF on estimated CO
%
%   Out:  4 plots
%         fig1 - Dashed green line is the thermodilution CO trend.  
%                Red and blue bars are the ABP waveform segments available.
%         fig2 - Relative estimate of CO using algorithm ESTID.
%         fig3 - 6 subplots of various ABP features
%         fig4 - Zoomed out view of an ABP waveform segment.  
%                ABP in blue, features of ABP marked in green and red. 
%                Red on bottom is the beat-to-beat SQI, where 0=good, 10=bad.
% 
%   Usage:
%   - When prompted with "[start_time duration] (vector in minutes):",
%     EITHER enter something like [200 100] to view ABP starting at 200
%     minutes and lasting 100 minutes
%     OR enter an integer to view an entire ABP segment.
%     Note:  viewing ABP for longer than 300 minutes is strongly
%     discouraged! Zooming in and out will take forever.
%
%   Written by James Sun (xinsun@mit.edu) on Nov 19, 2005.
%   - v2.0 - 12/19/05 - added ABP feature plotting
%   - v2.1 -  1/10/06 - compliant with new MAT data format
%   - v3.0 -  1/18/06 - commented out ABP feature plotting
%                     - repeatedly asks for plotting ABP at end

load(fname,'t0','m2t','F','onset');

t00 = t0(1,1);
t_abp(:,1) = 60*24*(t0(:,1)-t00);   % ABP segment time in minutes
t_abp(:,2) = t0(:,2)/(60*125);      % length of each segment in minutes

% sync TCO time with ABP time
tco  = m2t.CO;
ttco = m2t.t0;
t0_co  = 24*60*(ttco - t00);
t_co   = [t0_co+tco(:,1)  tco(:,2)];


%% plot fig1
scrn = get(0,'ScreenSize');
figure('Position',[1 600 scrn(3) 300]); hold on;
for i=1:size(t0,1)
    X = [t_abp(i,1) t_abp(i,1)+t_abp(i,2)];
    Y = double(mean(t_co(:,2))*[1 1]);
    if mod(i,2)==1
        line(X,Y,'Color','b','Linewidth',10);
    else
        line(X,Y,'Color','r','Linewidth',10);
    end
    text(mean(X),mean(Y),num2str(i),'HorizontalAlignment','center');
end
plot(t_co(:,1),t_co(:,2),'.--g','Linewidth',2,'MarkerSize',20);
xlabel('time [min]'); ylabel('tco [L/min]');
set(gca,'Position',[0.05    0.2    0.92    0.7])

%% plot fig2
if estID~=0
    [est_val,t_est] = estimateCO(fname,estID,filt_order);
    figure('Position',[1 200 scrn(3) 300]); hold on;
    set(gca,'Position',[0.05    0.2    0.92    0.7])
    plot(t_est,est_val,'.b');
    xlabel('time [min]');
    ylabel('relative CO');
    title(['Estimated CO using estimation algorithm ' num2str(estID)]);
end

% %% plot fig3
% scrsz = get(0,'ScreenSize');
% figure('Position',[1 -100 scrsz(3) scrsz(4)])
% 
% subplot(6,1,1); hold on
% for i=1:size(t0,1)
%     X = [t_abp(i,1) t_abp(i,1)+t_abp(i,2)];
%     Y = double(mean(t_co(:,2))*[1 1]);
%     if mod(i,2)==1
%         line(X,Y,'Color','b','Linewidth',5);
%     else
%         line(X,Y,'Color','r','Linewidth',5);
%     end
%     text(mean(X),mean(Y),num2str(i),'HorizontalAlignment','center');
% end
% plot(t_co(:,1),t_co(:,2),'.--g','Linewidth',2,'MarkerSize',20);
% xlabel('time [min]'); ylabel('tco [L/min]');
% 
% subplot(6,1,2)
% [est_val,t_est] = estimateCO(fname,estID,filt_order);
% plot(t_est,est_val,'.b')
% ylabel(['CO alg ' num2str(estID)])
% 
% subplot(6,1,3); hold on
% ymin = 1e9;
% ymax = 0;
% yavg = [];
% for i=1:size(t0,1)
%     if length(F{i})~=0
%         X = onset{i}(1:end-1)/125/60 + t_abp(i,1);
%         Y = filtfilt(ones(20,1)/20,1,60*125./F{i}(:,7));
%         plot(X,Y,'.');
%     end
%     yavg = [yavg; Y];
% end
% ylim([mean(yavg)-3*std(yavg) mean(yavg)+3*std(yavg)])
% ylabel('HR');
% 
% 
% subplot(6,1,4); hold on
% ymin = 1e9;
% ymax = 0;
% yavg = [];
% for i=1:size(t0,1)
%     if length(F{i})~=0
%         X = onset{i}(1:end-1)/125/60 + t_abp(i,1);
%         Y = filtfilt(ones(20,1)/20,1,F{i}(:,5)); %60*125./F{i}(:,7);
%         plot(X,Y,'.');
%     end
%     yavg = [yavg; Y];
% end
% ylim([mean(yavg)-3*std(yavg) mean(yavg)+3*std(yavg)])
% ylabel('PP');
% 
% 
% subplot(6,1,5); hold on
% ymin = 1e9;
% ymax = 0;
% yavg = [];
% for i=1:size(t0,1)
%     if length(F{i})~=0
%         X = onset{i}(1:end-1)/125/60 + t_abp(i,1);
%         Y = filtfilt(ones(20,1)/20,1,F{i}(:,6)); %60*125./F{i}(:,7);
%         plot(X,Y,'.');
%     end
%     yavg = [yavg; Y];
% end
% ylim([mean(yavg)-3*std(yavg) mean(yavg)+3*std(yavg)])
% ylabel('MAP');
% 
% subplot(6,1,6); hold on
% ymin = 1e9;
% ymax = 0;
% yavg=[];
% for i=1:size(t0,1)
%     if length(F{i})~=0
%         X = onset{i}(1:end-1)/125/60 + t_abp(i,1);
%         Y = filtfilt(ones(20,1)/20,1,F{i}(:,10));
%         plot(X,Y,'.');
%     end
%     yavg = [yavg; Y];
% end
% ylim([mean(yavg)-3*std(yavg) mean(yavg)+3*std(yavg)])
% ylabel('SA');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find correct abp number
while 1
IN = input('[start_time duration] (vector in minutes): ');

if isempty(IN)
    return
end

if length(IN)==1
    
    ind = IN;

    str = sprintf('load %s abp%d',fname,ind); eval(str);
    str = sprintf('abp=abp%d; clear abp%d',ind,ind); eval(str);
    
    sstart = 1;
    send = length(abp);
    
    tstart = t_abp(ind,1);
    
else
    
    tstart = IN(1);
    T      = IN(2);

    ind = find((tstart-t_abp(:,1)>0),1,'last');
    str = sprintf('load %s abp%d',fname,ind); eval(str);
    str = sprintf('abp=abp%d; clear abp%d',ind,ind); eval(str);


    % find abp index start
    dt = tstart-t_abp(ind,1);
    sstart = round(dt*7500);

    if sstart>length(abp)
        warning('begin time out of bounds, choose another');
        continue
    end

    % find abp index end
    send = sstart+T*7500-1;
    if send>length(abp)
        send = length(abp);
    end
end

% final abp segment and plot
abp_seg = abp(sstart:send);
t = tstart + (0:(length(abp_seg)-1))'/7500;

figure('Position',[1 100 scrn(3) 400]); hold on;
plot(t,abp_seg);
xlabel('time [min]');
ylabel('ABP [mmHg]');


%% load features and plot
load(fname,'onset','F','sqi');
r = F{ind};
onset = onset{ind};

% plots
ostart = find(onset>sstart,1,'first');
oend   = find(onset<send,1,'last');
t_onset = onset(ostart:oend)-sstart+1;

plot(t(t_onset),abp_seg(t_onset),'or');

r = r(ostart:oend-1,:);
o1 = r(:,1)-sstart+1;
o3 = abs(r(:,3)-sstart+1);
o9 = r(:,9)-sstart+1;
o11 = r(:,11)-sstart+1;

sqi = sqi{ind}(ostart:oend,1);

plot(t(o1),r(:,2),'--b',t(o3),r(:,4),'--b'); 
plot(t(o9),abp_seg(o9),'.g',t(o11),abp_seg(o11),'.r'); 

stairs(t(t_onset),10*sqi,'r');

axis tight
ylim([0 inf]);
set(gca,'Position',[0.05    0.2    0.92    0.7]);
end
