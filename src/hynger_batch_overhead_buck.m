% create runtime data for buck converter example

clear all;

num_sim = 50;

time_simulate = zeros(num_sim,1);
time_siminst = zeros(num_sim,1);
time_daikon = zeros(num_sim,1);

for i = 1 : num_sim
    [time_simulate(i), time_siminst(i), time_daikon(i)] = hynger('buck_hvoltage_discrete', 1);
end

mean_time_simulate = mean(time_simulate);
mean_time_siminst = mean(time_siminst);
mean_time_daikon = mean(time_daikon);

