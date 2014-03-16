
numbers.ruz.u_alphat    = u_alphat;
numbers.ruz.u_alphan    = u_alphan;
numbers.ruz.u_tau       = u_tau;
numbers.ruz.nb_alphat   = nb_alphat;
numbers.ruz.nb_alphan   = nb_alphan;
numbers.ruz.nb_tau      = nb_tau;

% progress
tools_parforprogress(1);tools_parforprogress(0);

% save sdata
save('data/sdata.mat','-append','numbers');
