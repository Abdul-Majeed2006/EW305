load('C:\Users\m287110\Google Drive Streaming\My Drive\EW305\labs\lab 2\lab2_part_3_0-6.mat')
steady_state = nan(1,size(SPEED,2));
for i = 1:size(SPEED,2)
    steady_state(i)= comp_ss_value(SPEED(:,i),100);
end
steady_state = cleanData(steady_state);
data =[]
data(:,1) = steady_state
data(:,2) = volts
%% solve for max deadzone voltage
deadzone = []
for i=1:size(data,1)
        if data(i,1) == 0
            deadzone(end+1) = data(i,2);
        end
end
deadzone = max(deadzone)
%% solve for first voltage with non zero speed
min_voltage = []
for i=1:size(data,1)
    if data(i,1) ~= 0
        min_voltage (end+1) = data(i,2);
    end
end
min_voltage = min(min_voltage)
%% Plotting data of steady-state voltage vs input voltage
figure(); % open figure
plot(volts(9:end),steady_state(9:end)) % steady state vs voltage
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
save('lab3_data.mat','TIME',"SPEED","POSITION","VOLT",'volts','deadzone','V_50rads','steady_state','data','min_voltage')
%%