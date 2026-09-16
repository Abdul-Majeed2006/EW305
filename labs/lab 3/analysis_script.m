%%load('C:\Users\m287110\Google Drive Streaming\My Drive\EW305\labs\lab 2\lab2_part_3_0-6.mat')
steady_state = nan(1,size(SPEED,2));
for i = 1:size(SPEED,2)
    steady_state(i)= comp_ss_value(SPEED(:,i),100);
end
steady_state = cleanData(steady_state);
%% solve for max deadzone voltage
deadzone = []
for i=1:size(data,1)
        if data(i,1) == 0
            deadzone(end+1) = data(i,2);
        end
end
deadzone = max(deadzone)
%% solve for first voltage with non zero speed
%min_voltage = []
%for i=1:size(data,1)
%    if data(i,1) ~= 0
%        min_voltage (end+1) = data(i,2);
%    end
%end
%min_voltage = min(min_voltage)
%% Plotting data of steady-state voltage vs input voltage
figure(); % open figure
plot(steady_state,volts) % steady state vs voltage
hold on % to continue working on same figure
xlabel('voltage (V)') % xlabel
ylabel('steady state speed x(t)') % ylabel
%legend('velocity vs time at 2.5V','velocity vs time at 5V') % legends
title('steady state vs voltage for 0-6V in 101 steps with no deadzone') % title
hold off % done
%% voltage at 50 rad/s
V_50rads = []
for i=1:size(data,1)
    if data(i,1) == 50
        V_50rads(end+1) = data(i,2);
    end
end
V_50rads = V_50rads 
%% saving new mat file
save('lab3_data.mat','-append')
%% solve for steadystate error
steady_state_2_34 = []
for i=1:30
    speed = SPEED(:,30)
    steady_state_2_34(end+1) = comp_ss_value(speed,100)
end
%% steady staete error
ss_error = 50 - steady_state_2_34
mean_error = mean(ss_error)
std_error = std(ss_error)
upper_lim = mean_error + 2*std_error
lower_lim = mean_error - 2*std_error
%% plot
figure();
num_of_trials = 1:30
plot(num_of_trials,ss_error)
hold on
yline(mean_error,'-r')
yline(upper_lim,'-g')
yline(lower_lim,'b')
title('SS Verification')
xlabel('nth run')
ylabel('ss error')
legend('ss error','mean error','upper lim','lower lim')
hold of
%%
figure
plot(TIME,SPEED)
%%
stead = comp_ss_value(SPEED(:,1),100)