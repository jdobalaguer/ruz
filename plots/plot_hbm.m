
%% fit model
load_twoparams;
run_hbm_model;

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
    this_optdata = nan(1,16);

    for i_trial = 1:16
        % index
        ii_index = (sdata.trial==i_trial & sdata.cuenovelty==numbers.u_novelty(i_novelty));
        % data
        this_subdata(i_trial) = mean(sdata.Mhuman_cr(ii_index));
        this_moddata(i_trial) = mean(sdata.Mbayes_cr(ii_index));
        this_optdata(i_trial) = mean(sdata.Mopt_cor(ii_index));
    end
    
    % plot
    plot(this_subdata, 'o','markerfacecolor','k','markeredgecolor','k','markersize',10);
    plot(this_moddata,'linewidth',2,'linestyle','--','color',c(i_novelty));
    plot(this_optdata,'linewidth',2,'linestyle','-','color',c(i_novelty));
    ylim([0 1]);
    xlim([1 numbers.nb_trials]);
    set(gca,'fontsize',16,'fontname','Arial');
end

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
    this_optdata = nan(1,16);

    for i_trial = 1:16
        % index
        ii_index = (sdata.trial==i_trial & sdata.cuenovelty==numbers.u_novelty(i_novelty));
        % data
        this_subdata(i_trial) = mean(sdata.Mhuman_ch(ii_index));
        this_moddata(i_trial) = mean(sdata.Mbayes_ch(ii_index));
        this_optdata(i_trial) = mean(sdata.Mopt_ch(ii_index));
    end
    
    % plot
    plot(this_subdata, 'o','markerfacecolor','k','markeredgecolor','k','markersize',10);
    plot(this_moddata,'linewidth',2,'linestyle','--','color',c(i_novelty));
    plot(this_optdata,'linewidth',2,'linestyle','-','color',c(i_novelty));
    ylim([0 1]);
    xlim([1 numbers.nb_trials]);
    set(gca,'fontsize',16,'fontname','Arial');
end

%% candidates plot

%figure
figure('color',[1 1 1]);
c = 'rg';

for i_novelty = 1:numbers.nb_novelties

    % figure
    subplot(1,numbers.nb_novelties,i_novelty);
    hold on;
    
    this_moddata = nan(1,16);

    for i_trial = 1:16
        % index
        ii_index = (sdata.trial==i_trial & sdata.cuenovelty==numbers.u_novelty(i_novelty));
        % data
        this_moddata(i_trial) = mean(sdata.Mbayes_nc(ii_index));
    end
    
    % plot
    plot(ones(1,16)  ,'linewidth',1,'linestyle','-','color','k');
    plot(this_moddata,'linewidth',2,'linestyle','-','color',c(i_novelty));
    ylim([0 36]);
    xlim([1 numbers.nb_trials]);
    set(gca,'fontsize',16,'fontname','Arial');
end

%% probabilities plot

%figure
figure('color',[1 1 1]);
c = 'rg';

for i_novelty = 1:numbers.nb_novelties

    % figure
    subplot(1,numbers.nb_novelties,i_novelty);
    hold on;
    
    this_moddata = nan(1,16);
    this_truedata = nan(1,16);

    for i_trial = 1:16
        % index
        ii_index = (sdata.trial==i_trial & sdata.cuenovelty==numbers.u_novelty(i_novelty));
        % data
        this_moddata(i_trial) = mean(sdata.Mbayes_pr(ii_index));
        this_truedata(i_trial) = mean(sdata.newtarget(ii_index));
    end
    
    % plot
    plot(this_truedata,'linewidth',1,'linestyle','-','color','k');
    plot(this_moddata,'linewidth',2,'linestyle','-','color',c(i_novelty));
    ylim([0 1]);
    xlim([1 numbers.nb_trials]);
    set(gca,'fontsize',16,'fontname','Arial');
end

%% entropy plot

%figure
figure('color',[1 1 1]);
c = 'rg';

for i_novelty = 1:numbers.nb_novelties

    % figure
    subplot(1,numbers.nb_novelties,i_novelty);
    hold on;
    
    this_hleft= nan(1,16);
    this_hright= nan(1,16);

    for i_trial = 1:16
        % index
        ii_index = (sdata.trial==i_trial & sdata.cuenovelty==numbers.u_novelty(i_novelty));
        % data
        this_hleft(i_trial)  = mean(sdata.Mbayes_hl(ii_index));
        this_hright(i_trial) = mean(sdata.Mbayes_hr(ii_index));
    end
    
    % plot
    plot(this_hleft ,'linewidth',2,'linestyle','-','color',c(i_novelty));
    plot(this_hright,'linewidth',1,'linestyle','-.','color','k');
    ylim([0 3]);
    xlim([1 numbers.nb_trials]);
    set(gca,'fontsize',16,'fontname','Arial');
end

%% clean
clearvars -except sdata numbers;
