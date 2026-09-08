% EW305 Lab 
% AY2027

%% 1.
clear all; close all; clc

%% 2. Open serial connection with Pico
ser = serialport("COM26",9600) % specify COM port

%% 3. interface with Pico over serial

% Desired motor voltage of step input
volts = 2.34 * ones(1,30); %v 50
% Voltage inputs to run: 2.5, 5.0, 0:0.06:6;

% Define what information is being sent to the pico
exp  = 1;  % 1 for run hardware experiment, 0 for simulation
ctrl = 0 ; % 0 for open-loop (select voltage), 1 for P ctrl, 2 for PI ctrl

if ctrl == 0
    info_to_send = [exp ctrl volts];    
elseif ctrl > 0
    % To be written later 
end
N = length(info_to_send)-2; % number of trials to run

%% 4. Memory Pre-allocation
maxSamples = 250; % 100Hz for 2 seconds = 200 samples, we have to go above to avoid any constraint
TIME     = nan(maxSamples, N);
POSITION = nan(maxSamples, N);
SPEED    = nan(maxSamples, N);
VOLT     = nan(maxSamples, N);

%% 5. Data Collection Execution Loop
for i = 1:N
    flush(ser) % flush serial port buffer to make sure there isn't old data
    pause(0.5) % wait to force flush
    writeline(ser,sprintf('%d',info_to_send([1 2])))
    pause(0.25) % wait to force read
    writeline(ser,sprintf('%f',info_to_send(i+2))) % send float message to pico
    pause(2.1) % wait for experiment to run and finish, with a little extra
    count = 1; % establish counting variable
    while ser.NumBytesAvailable>0 % if data is available to read
        line_data = readline(ser);
        msg = sscanf(line_data,'%f,%f,%f,%f');
        if length(msg)== 4 % only store data if it has the correct form
            TIME(count,i)     = msg(1);           
            POSITION(count,i) = msg(2);
            SPEED(count,i)    = msg(3);
            VOLT(count,i)     = msg(4); 
            count = count+1; % iterate counter if data was stored
        end
        pause(0.002) % pause a short time to not get ahead of the pico streaming
    end
end


%% save un processd data then Process data: Remove NaNs
save('lab3_single_v_50rads_30x.mat','TIME',"SPEED","POSITION","VOLT",'volts')
TIME = cleanData(TIME);
POSITION = cleanData(POSITION);
SPEED = cleanData(SPEED);
VOLT = cleanData(VOLT);
%% Save processed data
save('lab3_part_3_v_50rads_30x.mat','TIME',"SPEED","POSITION","VOLT",'volts')
%% Plotting AND COMPUTING STEADY STATE VALUE
% steady state 
steady_state_2_34 = comp_ss_value(SPEED(:,1),100);
%steady_state_5 = comp_ss_value(SPEED(:,2),100);
figure(); % open figure
plot(TIME,SPEED) % velocity vs time
hold on % to continue working on same figure
xlabel('time (s)') % xlabel
ylabel('speed x(t)') % ylabel
% make horizontal line with staedy state
yline(steady_state_2_5)
yline(steady_state_5)
%legend('velocity vs time at 2.5V','velocity vs time at 5V') % legends
title('velocity vs time for 0-6V in 101 steps') % title
hold off % done
