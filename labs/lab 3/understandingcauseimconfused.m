%load lab3_part_3_v_50rads_30x.mat
steady_state = nan(1,size(SPEED,2));
for i = 1:size(SPEED,2)
    steady_state(i)= comp_ss_value(SPEED(:,i),100);
end
steady_state = cleanData(steady_state);
%%
ss_error = 50 - steady_state
%% 
figure()
plot(ss_error,'ko-')
hold on
mean_ss_error = mean(ss_error)
yline(mean_ss_error,'r')
standadev = std(ss_error)
upper_lim = mean_ss_error + 2*standadev
yline(upper_lim,'b')
lower_lim = mean_ss_error - 2*standadev
yline(lower_lim,'g')
legend('ss_error','mean_ss_error','upperlim','lowerlim')
hold off