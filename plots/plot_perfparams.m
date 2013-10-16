
%% START ==================================================================
fprintf('\n#### plot_perfparams ####\n');

%% LOAD ===================================================================
fprintf('\nload data');
if ~exist('sdata','var')
    load_twoparams;
else
    fprintf(['\n    skipping']);
end

%% LOAD NUMBERS ===========================================================
u_subject   = unique(sdata.sub);
nb_subjects = length(u_subject);

u_novelty   = 0:1;
nb_novelties = length(u_novelty);

u_param     = {'propabs','propang','thresh'};
nb_params   = length(u_param);

nb_ttrials  = length(sdata.sub);
nb_strials  = nb_ttrials/nb_subjects;

%% PLOT ===================================================================
% label
label_novelty = {'familiar','novel'};

% figure
figure('color',[1 1 1]);
i_subplot = 0;
for i_param = 1:nb_params
    for i_novelty = 1:nb_novelties
        % subplot
        i_subplot = i_subplot+1;
        subplot(nb_params,nb_novelties,i_subplot);

        % param values
        x_param = sdata.(['min',u_param{i_param}])(:,i_novelty);
        
        % subject values
        %sdata.subcr = nan(sub,nov,pabs,pang,thr,trial);
        x_cor = mean(squeeze(sdata.subcr(:,i_novelty,1,1,1,:)),2);

        % plot
        plot(x_param,x_cor,'ko');
        
        % labels
        xlim([0,1]);
        set(gca,'xtick',0:.2:1);
        ylim([0.5,1]);
        set(gca,'ytick',0.5:.25:1);
        xlabel = ['(',label_novelty{i_novelty},', ',u_param{i_param},')'];
        set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
        set(gca,'fontsize',16,'fontname','Arial');
        
    end
end

%% END
fprintf('\n#### /plot_perfparams ####\n');
