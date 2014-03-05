%#ok<*NODEF>

function plot_rt_ptargetpcorrectchoice()
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_subject   = numbers.shared.u_subject;
    u_choice    = [0,1];
    u_pcorrect  = [0,1];
    u_ptarget   = [0,1];
    
    nb_novel    = numbers.shared.nb_novel;
    nb_subject  = numbers.shared.nb_subject;
    nb_choice   = 2;
    nb_pcorrect = 2;
    nb_ptarget  = 2;
    
    %% set data
    % previous target
    sdata.vb_ptarget = [nan; sdata.vb_target(1:end-1)];
    sdata.vb_ptarget(sdata.exp_start) = nan;
    models.human.pcorrect = [nan; models.human.correct(1:end-1)];
    models.human.pcorrect(sdata.exp_start) = nan;
    
    %% plot
    % figure
    fig_figure();

    % colour
    colour        = fig_color('green')./255;
    colour(:,:,2) = fig_color('red')./255;
    
    % title
    titles = {'FAMILIAR & NOT','FAMILIAR & CHOICE';'NOVEL & NOT','NOVEL & CHOICE'};

    % loop (model,choice)
    j_subplot = 0;
    for i_novel = 1:nb_novel
        for i_choice = 1:nb_choice
            % subplot
            j_subplot = j_subplot + 1;
            subplot(nb_novel,nb_choice,j_subplot);
            hold('on');

            % loop (subject, trial)
            rt = nan(nb_subject,nb_pcorrect,nb_ptarget);
            for i_ptarget = 1:nb_ptarget
                for i_pcorrect = 1:nb_pcorrect
                    for i_subject = 1:nb_subject
                        % index
                        ii_resp    = (models.human.rt>0);
                        ii_trial   = (sdata.exp_trial   >1) & (sdata.exp_trial   <4);
                        ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                        ii_choice  = (models.human.choice   == u_choice(i_choice));
                        ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                        ii_pcorrect= (models.human.pcorrect == u_pcorrect(i_pcorrect));
                        ii_ptarget = (sdata.vb_ptarget      == u_ptarget(i_ptarget));
                        % value
                        rt(i_subject,i_pcorrect,i_ptarget) = -1000 + 1000*nanmean(models.human.rt(ii_resp & ii_trial & ii_novel & ii_choice & ii_subject & ii_pcorrect & ii_ptarget));
                    end
                end
            end

            % plot
            y = squeeze(nanmean(rt));
            e = squeeze(tools_ste(rt));
            if(~any(e)); e(:) = 0.001; end
            web = fig_barweb(   y,...                                                  height
                                e,...                                                  error
                                [],...                                                 width
                                {'prev wrong','prev correct'},...                      group names
                                titles{i_novel,i_choice},...                           title
                                [],...                                                 xlabel
                                'reaction time (ms)',...                               ylabel
                                colour(:,:,i_novel),...                                colour
                                'y',...                                                grid
                                {'prev not','prev target'},...                         legend
                                [],...                                                 error sides (1, 2)
                                'axis'...                                              legend ('plot','axis')
                                );
            % axis
            sa.ytick       =    0:100: 800;
            sa.yticklabel  = 1000:100:1800;
            sa.ylim        = [  0,     800];
            fig_axis(sa);
        end
    end
end
