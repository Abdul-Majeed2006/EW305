%% where motor spins
%indices_motors_turns = []
%for i=1:size(data,1)
%        if data(i,1) ~= 0
%            indices_motors_turns(i-8,2) = data(i,2);
%            indices_motors_turns(i-8,1) = data(i,1);
%        end
%end
%%
%indices_motors_turns(:,2) = indices_motors_turns(:,2)-0.42
%%
%save('lab4.mat',"TIME",'-append')
%% plot
figure()
plot(indices_motors_turns(:,2),indices_motors_turns(:,1))
title('volts vs steady state speed')
xlabel('volts')
ylabel('ss-speed')
%%
% dc gain = slope
dc_gain = indices_motors_turns(:,1)./indices_motors_turns(:,2);
slope = (indices_motors_turns(end,1)-indices_motors_turns(1,1))/(indices_motors_turns(end,2)-(indices_motors_turns(1,2)));
% mean dc gain
mean_dc_gain = mean(dc_gain);
% standatd deviation
std_dc_gain = std(dc_gain);
% upper lim
upper_lim_dcgain = mean_dc_gain + 2*std_dc_gain;
lower_lim_dcgain = mean_dc_gain - 2*std_dc_gain;
%%
%save('lab4.mat','SPEED','-append')
%%
figure()
plot(indices_motors_turns(:,2),dc_gain,'kx')
hold on
xlabel('volts')
ylabel('dc gains')
title('volts vs dc gain')
yline(lower_lim_dcgain,'r')
yline(upper_lim_dcgain,'g')
yline(mean_dc_gain,'b')
yline(slope,'c')
legend('volts vs dc gain','lower limit of dc gain','upper limit of dc gain','mean value of dc gain','slope',Location='best')
hold off
%% time constant
tau = [];
for i = 1:93
    speed = SPEED(:,(i + 8));
    ss_val = steadystate_0_6(i);
    x = 0.63* ss_val;
    index = knnsearch(speed,x);
    time = TIME(index,(i + 8));
    tau = [tau, time];
end
%%
mean_tau = mean(tau);
std_tau = std(tau);
% upper lim
upper_lim_tau = mean_tau + 2*std_tau;
lower_lim_tau = mean_tau - 2*std_tau;
%%
figure()
plot(indices_motors_turns(:,2),tau,'kx')
hold on
xlabel('volts')
ylabel('tau')
title('volts vs timeconstant')
yline(mean_tau,'r')
yline(lower_lim_tau,'b')
yline(upper_lim_tau,'g')
legend('volts vs time constant','mean value of time constant','lower limit of time constant','upper limit of time constant',Location='best')
hold off
%%
%save('lab4.mat','-append')
%%
a = 1/mean_tau;
b = a * mean_dc_gain;
s = tf('s');
G = b/(s+a);
nrmse = zeros(1,93);
%%
for i= 1:93
    tsim  = TIME(:,i+8);
    tsim = linspace(0,tsim(end)-tsim(1),length(tsim));
    M = indices_motors_turns(i,2);
    spd_sim = step(M*G, tsim);
    exp_spd = indices_motors_turns(i,1);
    nrsme(i) = NRMSE(exp_spd,spd_sim);
end
cv=8