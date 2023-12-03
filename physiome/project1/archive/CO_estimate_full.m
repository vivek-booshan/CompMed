%function [CO,TPR] = estCO_v2(features,DAP,PP,onset_times)
%% Parlikar Estimator 

%ABP input is from abpfeature.m col 6, mean pressure.

%DAP input is from abpfeature.m col 4, diastolic pressure.

%PP input is from abpfeature.m col 5, pulse pressure. 
%   need to calculate pulse pressure changes between pulses from this. 

%onset times - seconds
%% calculate delta p
pressure_onset_1= time_ABP_table(onset_times,2);
%collect pressure at tn+1 and tn
pressure_onset_2 = [0;pressure_onset_1];
pressure_onset_1 = [pressure_onset_1; 0];
delta_p = pressure_onset_1 - pressure_onset_2;
delta_p = delta_p(2:end-1);
MAP=features(:,6);
DAP=features(:,4);

%% Use equation (8) to estimate 1/Taun from knowledge of remaining quantities​
%Tn = duration of cardiac cycle
onset_times_1=[0;onset_times];
onset_times_2=[onset_times;0];
Tn=onset_times_2-onset_times_1; 
Tn=Tn(2:end-1);
alpha=2;
PP_n = alpha*(MAP - DAP);
tau_n=MAP./((PP_n./Tn)-(delta_p./Tn));
window_size=3; %only odd number
beta_n=[];
for i = 1:length(tau_n)
    if i-(window_size-1)/2 <1
        numerator= (i-(window_size-1)/2)*MAP(i)*(PP_n(i)-delta_p(i))/Tn(i);
        denominator= (i-(window_size-1)/2)*MAP(i)^2;
        for j =i+1:i+(window_size-1)/2
            numerator = numerator + MAP(j)*(PP_n(j)-delta_p(j))/Tn(j);
            denominator= denominator+MAP(j)^2;
        end
        beta_n(i,1)=numerator/denominator; 
    elseif i+(window_size-1)/2>length(tau_n)
        beta_n(i,1)=beta_n(end); 
    else
        for j =i-(window_size-1)/2:1:i+(window_size-1)/2
            numerator = numerator + MAP(j)*(PP_n(j)-delta_p(j))/Tn(j);
            denominator= denominator+MAP(j)^2; 
        end
        beta_n(i,1)=numerator/denominator; 
    end
end

%% Estimate CO and find Cn
CO_est = ((delta_p./Tn) + (MAP.*beta_n));

%% Find Cn and gamma
j=1;
x=[];
MAP_12=[];
CO_12=[];
t_new=[];
for i = 1:length(onset_times)
    if onset_times(i) >= t_CO(j) %to is in minutes, t is in seconds
        t_new=[t_new; onset_times(i)];
        CO_12=[CO_12; CO_est(i)];
        MAP_12 = [MAP_12; PP_n(i)];
        j=j+1;
    end
    if j>length(t_CO)
        break;
    end
end
%%
a = [CO_12./r_CO, MAP_12.*(CO_12./r_CO)];
b=ones(length(r_CO),1);
x = linsolve(a,b);
gamma_1=x(1);
gamma_2=x(2);
Cn = gamma_1 + gamma_2*MAP;
cali_CO = Cn.*((delta_p./Tn) + (MAP.*beta_n));



figure;
stem(t_CO/3600,r_CO)
hold on
plot(onset_times(1:513)/3600,cali_CO(1:513))
xlabel("hours")

%% TPR
%TPR = ABP/(CO - ((Cn*(delta_p))/(T_n)));