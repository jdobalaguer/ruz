%% 
% FIGURE_1B
% 
% Behavioural data from 18 human participants (dots) and predictions
% of the model (lines). % acuracy (top panels) and % target choice
% (bottom panels) over trials (1-16) are shown for familiar cues
% (left panels; red) and novel cues (right panels; green). Lines
% show the same data for the best-fitting parameterisation of the
% model.
%

function figure_1B()
    %% defaults
    fontname = 'Sans Serif';
    model = valid_model();
    human = 'human';
    
    %% load
    sdata   = struct();
    models  = struct();
    numbers = struct();
    load('data/sdata.mat');
    
    %% assert
    assert(isfield(models,human),'figure_1B: error. human does not exist');
    assert(isfield(models,model),'figure_1B: error. model "%s" does not exist', model);
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_trial    = numbers.shared.u_trial;
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_trial   = numbers.shared.nb_trial;
    
    %% values
    human_correct    = nan(nb_subject,nb_novel,nb_trial);
    human_choice     = nan(nb_subject,nb_novel,nb_trial);
    model_correct    = nan(nb_subject,nb_novel,nb_trial);
    model_choice     = nan(nb_subject,nb_novel,nb_trial);
    for i_subject = 1:nb_subject
    for i_novel = 1:nb_novel
    for i_trial = 1:nb_trial
        
        ii_resp     = (models.human.rt>0);
        ii_subject  = (sdata.exp_subject == u_subject(i_subject));
        ii_novel    = (sdata.vb_novel    == u_novel(i_novel));
        ii_trial    = (sdata.exp_trial   == u_trial(i_trial));
        ii_odd      = (sdata.vb_odd      == 1);
        ii = (ii_resp & ii_subject & ii_novel & ii_odd & ii_trial);
        
        human_choice(i_subject,i_novel,i_trial)     = mean(models.(human).choice(ii));
        human_correct(i_subject,i_novel,i_trial)    = mean(models.(human).correct(ii));
        model_choice(i_subject,i_novel,i_trial)     = mean(models.(model).choice(ii));
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
        subplot(2,2,j_subplot);
        hold('on');
        
        plot(squeeze(mean(model_correct(:,i_novel,:),1)),'color',colours{i_novel},'linestyle',   '-','linewidth', 2);
        plot(squeeze(mean(human_correct(:,i_novel,:),1)),'color',colours{i_novel},'linestyle','none',              'marker','o','markersize',10,'markerfacecolor',colours{i_novel});
        
        sa.xlim    = [1,16];
        sa.xtick   = 5:5:15;
        sa.xticklabel = repmat({''},1,length(sa.xtick));
        sa.ylim    = [0.4,1.0];
        sa.ytick   = 0.4:0.2:1.0;
        sa.yticklabel = repmat({''},1,length(sa.ytick));
        fig_axis(sa);
        
        % choice
        subplot(2,2,j_subplot + 2);
        hold('on');
        
        plot(squeeze(mean(model_choice(:,i_novel,:),1)),'color',colours{i_novel},'linestyle',   '-','linewidth', 2);
        plot(squeeze(mean(human_choice(:,i_novel,:),1)),'color',colours{i_novel},'linestyle','none',              'marker','o','markersize',10,'markerfacecolor',colours{i_novel});
        
        sa.xlim    = [1,16];
        sa.xtick   = 5:5:15;
        sa.xticklabel = repmat({''},1,length(sa.xtick));
        sa.ylim    = [0.4,1.0];
        sa.ytick   = 0.4:0.2:1.0;
        sa.yticklabel = repmat({''},1,length(sa.ytick));
        fig_axis(sa);
    end
    
    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],18);
 
    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_1Bbis.pdf');
    
end