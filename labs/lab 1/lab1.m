%% EW305
clear,clc
% load functions folder
addpath('C:\Users\m287110\Google Drive Streaming\My Drive\EW305\Functions')
% load data file
load('EW305_Lab1_data_AY27.mat')
%% plot
% figure 1
figure(1)
% plot sim graph
plot(tsim,spd_sim,'Color','r')
hold on
% plot exp graph
plot(texp,spd_exp,'Color','b')
% x and y label
xlabel('time (s)')
ylabel('speed (rad/s)')
% steady state
steady_state = comp_ss_value(spd_exp,100)
% NRMSE
NRMSE = NRMSE(spd_exp,spd_sim)
% make horizontal line with staedy state
yline(steady_state)
% legend
legend('simulation','experimental','steady state','location','best')
% give graph title
title(sprintf('Speed response NRMSE'))
hold off
