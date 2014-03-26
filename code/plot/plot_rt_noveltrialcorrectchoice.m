
function plot_rt_noveltrialcorrectchoice()
    if ~usejava('swing'); return; end
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_correct   = [0,1];
    u_choice    = [0,1];
    u_subject   = numbers.shared.u_subject;
    u_trial     = numbers.shared.u_trial;
    
    nb_novel    = numbers.shared.nb_novel;
    nb_correct  = 2;
    nb_choice   = 2;
    nb_subject  = numbers.shared.nb_subject;
    nb_trial    = numbers.shared.nb_trial;
    
    %% plot
    % figure
    f = figure();
    
    % titles
    titles = {'WRONG & NOT','WRONG & CHOICE';'CORRECT & NOT','CORRECT & CHOICE'};
    
    % colour
    colour = [0,1,0;1,0,0];
    
    % plot
    j_subplot = 0;
    rt = nan(nb_subject,nb_trial,nb_novel,nb_correct,nb_choice);
    for i_correct = 1:nb_correct
        for i_choice = 1:nb_choice
            
            % subplot
            j_subplot = j_subplot + 1;
            subplot(nb_correct,nb_choice,j_subplot);
            hold('on');

            for i_novel = 1:nb_novel
                for i_subject = 1:nb_subject
                    for i_trial = 1:nb_trial
                        % index
                        ii_resp    = (models.human.rt>0);
                        ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                        ii_trial   = (sdata.exp_trial       == u_trial(i_trial));
                        ii_novel = (sdata.vb_novel == u_novel(i_novel));
                        ii_correct = (models.human.correct  == u_correct(i_correct));
                        ii_choice  = (models.human.choice   == u_choice(i_choice));
                        % value
                        rt(i_subject,i_trial,i_novel,i_correct,i_choice) = 1000*mean(models.human.rt(ii_resp & ii_subject & ii_trial & ii_novel & ii_correct & ii_choice));
                    end
                end

                % plot
                mean_rt = nanmean(rt(:,:,i_novel,i_correct,i_choice));
                ster_rt = tools_ste(rt(:,:,i_novel,i_correct,i_choice));
                fig_plot(u_trial,mean_rt,ster_rt,colour(i_novel,:));

                % axis
                sa.title   = titles{i_correct,i_choice};
                sa.xlabel  = 'trial';
                sa.ylabel  = 'reaction time (ms)';
                sa.xtick   = [4,8,12,16];
                sa.xlim    = [1,16];
                sa.ytick   = 800:200:1600;
                sa.ylim    = [800,1600];
                fig_axis(sa);
                            
            end
        end
    end

    fig_figure(f);
end