
clc;

% figure
figure('color',[1 1 1]);

% plot optimal
clc;
using_model = 'sdata.Mopt_ch';
run_janprobs;

% plot humans
clc;
using_model = 'sdata.Mhuman_ch';
run_janprobs;

