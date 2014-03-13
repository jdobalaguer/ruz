
function rts = plot_rtdiff_noveltrialcorrectchoice2()
    if ~usejava('swing'); return; end
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_trial     = numbers.shared.u_trial;
    u_novel     = numbers.shared.u_novel;
    u_correct   = [0,1];
    u_choice    = [0,1];
    u_subject   = numbers.shared.u_subject;
    
    nb_trial    = numbers.shared.nb_trial;
    nb_novel    = numbers.shared.nb_novel;
    nb_correct  = 2;
    nb_choice   = 2;
    nb_subject  = numbers.shared.nb_subject;
    
    %% remove trials
    u_trial(end-2:end) = [];
    nb_trial = length(u_trial);
    
    %% values
    % loop (novel)
    rt = nan(nb_novel,nb_subject,nb_correct,nb_choice,nb_trial);
    for i_novel = 1:nb_novel
        for i_subject = 1:nb_subject
            for i_correct = 1:nb_correct
                for i_choice = 1:nb_choice
                    for i_trial = 1:nb_trial
                        % frame
                        ii_resp    = (models.human.rt>0.2);
                        ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                        ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                        ii_FRAME   = (ii_resp & ii_novel & ii_subject);
                        % next trial
                        ii_nstart  =~(sdata.exp_start);
                        ii_nend    =~(sdata.exp_end);
                        ii_trial   = (sdata.exp_trial       == u_trial(i_trial));
                        ii_NEXT    = logical([0 ; ii_trial(1:end-1)]) & ii_nstart & ii_nend;
                        % choice & correct
                        ii_CORRECT = (models.human.correct  == u_correct(i_correct));
                        ii_CHOICE  = (models.human.choice   == u_choice(i_choice));
                        % value
                        rt_frame   = nanmean(models.human.rt(ii_FRAME & ii_NEXT));
                        rt_2       = models.human.rt(ii_CHOICE & ii_CORRECT & ii_FRAME & ii_NEXT);
                        rt(i_novel,i_subject,i_correct,i_choice,i_trial) = 1000*nanmean(rt_2 - rt_frame);
                    end
                end
            end
        end
    end

    %% plot
    % figure
    figure();
    
    % titles
    titles = {'WRONG & NOT','WRONG & CHOICE';'CORRECT & NOT','CORRECT & CHOICE'};
    
    % colour
    colour = [0,1,0;1,0,0];
    
    j_subplot = 0;
    for i_correct = 1:nb_correct
        for i_choice = 1:nb_choice
            
            % subplot
            j_subplot = j_subplot + 1;
            subplot(nb_correct,nb_choice,j_subplot);
            hold('on');
                
            for i_novel = 1:nb_novel
                % fig_plot
                y = nanmean(squeeze(rt(i_novel,:,i_correct,i_choice,:)));
                e = nanste(squeeze(rt(i_novel,:,i_correct,i_choice,:)));
                c = squeeze(colour(i_novel,:));
                fig_plot(u_trial,y,e,c);

                % axis
                sa.title   = titles{i_correct,i_choice};
                sa.xlabel  = 'trial';
                sa.ylabel  = 'reaction time (ms)';
                sa.xtick   = [4,8,12,16];
                sa.xlim    = [1,16];
                sa.ytick   = -300:100:+500;
                sa.ylim    = [-250,+450];
                fig_axis(sa);
            end
        end
    end
    
    % fig_figure
    fig_figure(gcf());
end