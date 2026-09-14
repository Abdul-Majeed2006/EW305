%% where motor spins
indices_motors_turns = []
for i=1:size(data,1)
        if data(i,1) ~= 0
            indices_motors_turns(i-8,2) = data(i,2);
            indices_motors_turns(i-8,1) = data(i,1);
        end
end
%%
save('lab4',"indices_motors_turns",'-mat')
%% plot
figure()
plot(indices_motors_turns(:,2),indices_motors_turns(:,1))