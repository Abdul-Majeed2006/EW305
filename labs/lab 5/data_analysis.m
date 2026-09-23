%SPEED_clean = cleanData(SPEED)
%save('lab_5.mat')
%figure ()
%plot(TIME,SPEED)
%steady_state = comp_ss_value(SPEED_clean,100)

%%
TIME_clean = cleanData(TIME)
%%
figure();
plot(TIME_clean,SPEED_clean,'b')
hold on 
plot(time_2_5_exp,speed_2_5_exp,'r')
xlabel('time (s)')
ylabel('steady_state speed')
steady_state = comp_ss_value(SPEED_clean,100)
yline(steady_state)
steady_state_exp = comp_ss_value(speed_2_5_exp,100)
yline(steady_state_exp)
SPEED_clean_resampled = interp1(TIME_clean, SPEED_clean, time_2_5_exp, 'linear', 'extrap');
nrsme = NRMSE(speed_2_5_exp,SPEED_clean_resampled)
legend('simulation','experiment','sim ss','exp ss','Location','best')
title(sprintf('Time vs Steady State (NRMSE = %.4f)', nrsme))
hold off
