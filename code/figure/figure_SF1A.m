%% 
% FIGURE_SF1A
% 
% Behavioural data from 18 human participants (dots) and predictions
% of the reinforcement model (continued lines) and the hierarchical
% Bayesian model (dotted lines). % accuracy over trials (1-16) is
% shown for familiar cues (left panels; red) and novel cues (right
% panels; green). Lines show the same data for the best-peformance
% parametrisation of the model.
%

function figure_SF1A()
    %% defaults
    fontname = 'Sans Serif';
    human = 'human';
    hbm   = 'hbm';
    model = model_valid();
    
    %% load
    sdata   = struct();
    models  = struct();
    numbers = struct();
    load('data/sdata.mat');
    
    %% assert
    assert(isfield(models,human),'figure_SF1A: error. human does not exist');
    assert(isfield(models,hbm  ),'figure_SF1A: error. hbm does not exist');
    assert(isfield(models,model),'figure_SF1A: error. model "%s" does not exist', model);
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_trial    = numbers.shared.u_trial;
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_trial   = numbers.shared.nb_trial;
    
    %% values
    human_correct    = nan(nb_subject,nb_novel,nb_trial);
    hbm_correct      = nan(nb_subject,nb_novel,nb_trial);
    model_correct    = nan(nb_subject,nb_novel,nb_trial);
    for i_subject = 1:nb_subject
    for i_novel = 1:nb_novel
    for i_trial = 1:nb_trial
        
        ii_resp     = (models.human.rt>0);
        ii_subject  = (sdata.exp_subject == u_subject(i_subject));
        ii_novel    = (sdata.vb_novel == u_novel(i_novel));
        ii_odd      = (mod(sdata.exp_block,2) == 1);
        ii_trial    = (sdata.exp_trial == u_trial(i_trial));
        ii = (ii_resp & ii_subject & ii_novel & ii_odd & ii_trial);
        
        human_correct(i_subject,i_novel,i_trial)    = mean(models.(human).correct(ii));
        hbm_correct(i_subject,i_novel,i_trial)      = mean(models.(hbm  ).correct(ii));
        model_correct(i_subject,i_novel,i_trial)    = mean(models.(model).correct(ii));
        
    end
    end
    end
    
    %% plot
    set(0, 'DefaultAxesFontName', fontname);
    
    % fig_figure
    figure();
    
    % colours
    colours = {[1,0,0] , [0,1,0]};
    
    j_subplot = 0;
    for i_novel = 1:2
        
        % correct
        j_subplot = j_subplot + 1;
        subplot(1,2,j_subplot);
        hold('on');
        
        plot(squeeze(mean(human_correct(:,i_novel,:),1)),'color',colours{i_novel},'linestyle','none',              'marker','o','markersize',10,'markerfacecolor',colours{i_novel});
        plot(squeeze(mean(  hbm_correct(:,i_novel,:),1)),'color',colours{i_novel},'linestyle',  '--','linewidth', 2);
        plot(squeeze(mean(model_correct(:,i_novel,:),1)),'color',colours{i_novel},'linestyle',   '-','linewidth', 2);
        
        sa.xlim    = [1,16];
        sa.xtick   = 5:5:15;
        sa.ylim    = [0.4,1.0];
        sa.ytick   = 0.4:0.2:1.0;
        fig_axis(sa);
        
    end
    
    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],18);
    
    %% smaller figure
    % window position
    pos = get(gcf(),'Position');
    pos(4) = 0.6 .* pos(4);
    set(gcf(),'Position',pos);
    % paper size
    set(gcf(),'PaperPositionMode','auto');
    psi = 4 * pos(3:4) ./ pos(4);
    set(gcf(),'PaperSize',psi);
    
    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_SF1A.pdf');
    
end
