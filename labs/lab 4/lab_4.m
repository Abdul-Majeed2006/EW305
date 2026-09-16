%% where motor spins
indices_motors_turns = []
for i=1:size(data,1)
        if data(i,1) ~= 0
            indices_motors_turns(i-8,2) = data(i,2);
            indices_motors_turns(i-8,1) = data(i,1);
        end
end
%%
save('lab4.mat',"indices_motors_turns",'-mat')
%% plot
figure()
plot(indices_motors_turns(:,2),indices_motors_turns(:,1))
title('volts vs steady state speed')
xlabel('volts')
ylabel('ss-speed')
%%
% dc gain = slope
dc_gain = indices_motors_turns(:,1)./indices_motors_turns(:,2)
slope = (indices_motors_turns(end,1)-indices_motors_turns(1,1))/(indices_motors_turns(end,2)-(indices_motors_turns(1,2)))
% mean dc gain
mean_dc_gain = mean(dc_gain)
% standatd deviation
std_dc_gain = std(dc_gain)
% upper lim
upper_lim_dcgain = mean_dc_gain + 2*std_dc_gain
lower_lim_dcgain = mean_dc_gain - 2*std_dc_gain
save('lab4.mat','-append')
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
tau = nan(1,size(indices_motors_turns,2))
for i = 1:size(indices_motors_turns(1,:),2)
    ss_val = steadystate_0_6(i)
    idx = knnsearch(indices_motors_turns(:,i),(0.63*ss_val))
    tau(i) = time(idx)
end
tau = cleanData(tau)