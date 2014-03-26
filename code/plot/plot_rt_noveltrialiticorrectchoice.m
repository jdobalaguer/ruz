
function plot_rt_noveltrialiticorrectchoice()
    if ~usejava('swing'); return; end
    
    %% load
    load('data/sdata');
    sdata.vb_slowiti = tools_discretize(sdata.time_iti,3);
    
    %% numbers
    u_slowiti   = unique(sdata.vb_slowiti);
    u_novel     = numbers.shared.u_novel;
    u_correct   = [0,1];
    u_choice    = [0,1];
    u_trial     = numbers.shared.u_trial;
    u_subject   = numbers.shared.u_subject;
    
    nb_slowiti  = length(u_slowiti);
    nb_novel    = numbers.shared.nb_novel;
    nb_correct  = 2;
    nb_choice   = 2;
    nb_trial    = numbers.shared.nb_trial;
    nb_subject  = numbers.shared.nb_subject;
    
    %% plot
    % figure
    f = figure();
    
    % colour
    colour        = fig_color('g')./255;
    colour(:,:,2) = fig_color('r')./255;
    
    % titles
    titles = {'NOT & WRONG','CHOICE & WRONG';'NOT & CORRECT','CHOICE & CORRECT'};
    
    % loop (novel, slow)
    j_subplot = 0;
    rt = nan(nb_subject,nb_trial,nb_novel,nb_slowiti,nb_correct,nb_choice);
    for i_slowiti = 1:nb_slowiti
        for i_choice = 1:nb_choice
            for i_correct = 1:nb_correct
                
                % subplot
                j_subplot = j_subplot + 1;
                subplot(nb_slowiti,nb_correct*nb_choice,j_subplot);
                hold('on');
                
                for i_novel = 1:nb_novel
                    for i_subject = 1:nb_subject
                        for i_trial = 1:nb_trial
                            % index
                            ii_resp    = (models.human.rt>0);
                            ii_slowiti = (sdata.vb_slowiti      == u_slowiti(i_slowiti));
                            ii_correct = (models.human.correct  == u_correct(i_correct));
                            ii_choice  = (models.human.choice   == u_choice(i_choice));
                            ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                            ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                            ii_trial   = (sdata.exp_trial       == u_trial(i_trial));
                            % value
                            rt(i_subject,i_trial,i_novel,i_slowiti,i_correct,i_choice) = 1000*nanmean(models.human.rt(ii_resp & ii_trial & ii_subject & ii_novel & ii_slowiti & ii_correct & ii_choice));
                        end
                    end
                    
                    % plot
                    mean_rt = nanmean(rt(:,:,i_novel,i_slowiti,i_correct,i_choice));
                    ster_rt = tools_ste(rt(:,:,i_novel,i_slowiti,i_correct,i_choice));
                    mean_rt(isnan(mean_rt)) = 0;
                    ster_rt(isnan(ster_rt)) = 0;
                    fig_plot(u_trial,mean_rt,ster_rt,colour(:,:,i_novel));
                    
                    % axis
                    sa.title   = titles{i_correct,i_choice};
                    sa.xlabel  = 'trial';
                    sa.ylabel  = 'reaction time (ms)';
                    sa.xtick   = [4,8,12,16];
                    sa.xlim    = [1,16];
                    sa.ytick   = 800:200:1700;
                    sa.ylim    = [800,1700];
                    fig_axis(sa);
                    
                    
                end
            end
        end
    end
    
    fig_figure(f);
end