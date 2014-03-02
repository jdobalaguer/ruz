
clc;

% figure
figure('color',[1 1 1]);

% plot model
clc;
using_model = 'sdata.Mfit_ch';
run_janprobsinteraction;

% plot humans
clc;
using_model = 'sdata.Mhuman_ch';
run_janprobsinteraction;

