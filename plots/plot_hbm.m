
%% fit model
run_hbm_model;

%% numbers
if ~exist('numbers','var')
    numbers = struct();
    numbers.u_subject = unique(sdata.sub);
    numbers.u_block = unique(sdata.block);
    numbers.u_trial = unique(sdata.trial);
    numbers.u_novelty = 0:1;

    numbers.u_propabs   = .6;
    numbers.u_propang   = 0:0.005:1;
    numbers.u_thresh    = 0:0.005:1;
    
    numbers.nb_subjects = length(numbers.u_subject);
    numbers.nb_blocks = length(numbers.u_block);
    numbers.nb_trials = length(numbers.u_trial);
    numbers.nb_novelties = length(numbers.u_novelty);
    numbers.nb_propabss = length(numbers.u_propabs);
    numbers.nb_propangs = length(numbers.u_propang);
    numbers.nb_threshs  = length(numbers.u_thresh);
end

%% performance plot

%figure
figure('color',[1 1 1]);
c = 'rg';

for i_novelty = 1:numbers.nb_novelties

    % figure
    subplot(1,numbers.nb_novelties,i_novelty);
    hold on;
    
    this_subdata = nan(1,16);
    this_moddata = nan(1,16);

    for i_trial = 1:16
        % index
        ii_index = (sdata.trial==i_trial);
        % data
        this_subdata(i_trial) = mean(sdata.Mhuman_cr(ii_index));
        this_moddata(i_trial) = mean(sdata.Mbayes_cr(ii_index));
    end
    
    % plot
    plot(this_subdata, 'o','markerfacecolor','k','markeredgecolor','k','markersize',10);
    plot(this_moddata,'linewidth',2,'linestyle','-','color',c(i_novelty));
    ylim([0 1]);
    xlim([1 numbers.nb_trials]);
    set(gca,'fontsize',16,'fontname','Arial');
end

% clean
clearvars -except sdata numbers;

%% response plot

%figure
figure('color',[1 1 1]);
c = 'rg';

for i_novelty = 1:numbers.nb_novelties

    % figure
    subplot(1,numbers.nb_novelties,i_novelty);
    hold on;
    
    this_subdata = nan(1,16);
    this_moddata = nan(1,16);

    for i_trial = 1:16
        % index
        ii_index = (sdata.trial==i_trial);
        % data
        this_subdata(i_trial) = mean(sdata.Mhuman_ch(ii_index));
        this_moddata(i_trial) = mean(sdata.Mbayes_ch(ii_index));
    end
    
    % plot
    plot(this_subdata, 'o','markerfacecolor','k','markeredgecolor','k','markersize',10);
    plot(this_moddata,'linewidth',2,'linestyle','-','color',c(i_novelty));
    ylim([0 1]);
    xlim([1 numbers.nb_trials]);
    set(gca,'fontsize',16,'fontname','Arial');
end

% clean
clearvars -except sdata numbers;
