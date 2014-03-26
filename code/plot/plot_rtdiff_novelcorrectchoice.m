
function rt = plot_rtdiff_novelcorrectchoice()
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
    
    %% plot
    % figure
    f_rt = figure();
    
    % colour
    colour        = fig_color('green')./255;
    colour(:,:,2) = fig_color('red')./255;
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % loop (novel)
    j_subplot = 0;
    for i_novel = 1:nb_novel
        %% values
%         rt = nan(nb_subject,nb_correct,nb_choice,nb_correct,nb_choice);
        rt = nan(nb_subject,nb_correct,nb_choice,nb_correct);
        for i_subject = 1:nb_subject
            for i_correct = 1:nb_correct
                for i_choice = 1:nb_choice
                    for j_correct = 1:nb_correct
%                         for j_choice = 1:nb_choice
                            % this
                            this_CH    = [0;models.human.choice(1:end-1)];
                            this_CO    = [0;models.human.correct(1:end-1)];
                            % next
                            next_RT    = [0;models.human.rt(1:end-1)];
                            next_CH    = [0;models.human.choice(1:end-1)];
                            next_CO    = [0;models.human.correct(1:end-1)];
                            % index
                            ii_choice  = (this_CH == u_choice(i_choice));
                            ii_correct = (this_CO == u_correct(i_correct));
%                             jj_choice  = (next_CH == u_choice(i_choice));
                            jj_correct = (next_CO == u_correct(i_correct));
                            % frame
                            ii_resp    = (models.human.rt>0.2);
                            ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                            ii_subject = (sdata.exp_subject     == u_subject(i_subject));
%                             ii_frame   = (ii_resp & ii_novel & ii_subject & jj_choice & jj_correct);
                            ii_frame   = (ii_resp & ii_novel & ii_subject & jj_correct);
                            % value
                            rt_frame   = nanmean(next_RT(ii_frame));
                            rt_2       = next_RT(ii_frame & ii_choice & ii_correct);
%                             rt(i_subject,i_correct,i_choice,j_correct,j_choice) = 1000*mean(rt_2 - rt_frame);
                            rt(i_subject,i_correct,i_choice,j_correct) = 1000*mean(rt_2 - rt_frame);
%                         end
                    end
                end
            end
        end
        
        %% average
%         rt = squeeze(nanmean(rt,5)); % over choice
        rt = squeeze(nanmean(rt,4)); % over correct
        
        %% figure rt
        figure(f_rt);
        
        % subplot
        j_subplot = j_subplot + 1;
        subplot(1,nb_novel,j_subplot);
        hold('on');
        
        % barweb (rt)
        y = squeeze(nanmean(rt));
        e = squeeze(nanste(rt));
        c = squeeze(colour(:,:,i_novel));
        web = fig_barweb(   y,e,...                                                height and error
                            [],...                                                 width
                            {'wrong','correct'},...                                group names
                            [],...                                                 title
                            [],...                                                 xlabel
                            'slow down (ms)',...                                   ylabel
                            c,...                                                  colour
                            [],...                                                 grid
                            {'not','choice'},...                                   legend
                            2,...                                                  error sides (1, 2)
                            'plot'...                                              legend ('plot','axis')
                            );
        % axis (rt)
        sa.title      =   titles{i_novel};
        sa.ytick      =    -200:50:+200;
        sa.yticklabel =    -200:50:+200;
        sa.ylim       =   [-200,   +200];
        fig_axis(sa);

    end
    
    fig_figure(f_rt);
end