
function rts = plot_rtdiff_noveltrialcorrectchoice()
    if ~usejava('swing'); return; end
    
    %% load
    load('data/sdata');
    sdata.exp_trial = tools_discretize(sdata.exp_trial,4);
    numbers.shared.u_trial  = unique(sdata.exp_trial);
    numbers.shared.nb_trial = length(numbers.shared.u_trial);
    
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
%     f_ss = figure();
    
    % colour
    % colour
    colour        = fig_color('green')./255;
    colour(:,:,2) = fig_color('red')./255;
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % loop (novel)
    j_subplot = 0;
    rts = cell(nb_novel,nb_trial);
    for i_novel = 1:nb_novel
    for i_trial = 1:nb_trial
        %% values
        ss = nan(nb_subject,nb_correct,nb_choice);
        rt = nan(nb_subject,nb_correct,nb_choice);
        for i_subject = 1:nb_subject
            for i_correct = 1:nb_correct
                for i_choice = 1:nb_choice
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
                    ss(i_subject,i_correct,i_choice) = length(rt_2);
                    rt(i_subject,i_correct,i_choice) = 1000*mean(rt_2 - rt_frame);
                end
            end
        end
        
        %% figure rt
        figure(f_rt);
        
        % subplot
        j_subplot = j_subplot + 1;
        subplot(nb_novel,nb_trial,j_subplot);
        hold('on');
        
        % barweb (rt)
        y = squeeze(nanmean(rt));
        e = squeeze(nanste(rt));
        c = squeeze(colour(:,:,i_novel));
        web = fig_barweb(   y,e,...                                                height and error
                            [],...                                                 width
                            {'wrong','correct'},...                                group names
                            titles{i_novel},...                                    title
                            [],...                                                 xlabel
                            'slow down (ms)',...                                   ylabel
                            c,...                                                  colour
                            [],...                                                 grid
                            {'not','choice'},...                                   legend
                            2,...                                                  error sides (1, 2)
                            'plot'...                                              legend ('plot','axis')
                            );
        % axis (rt)
        sa.ytick      =    -500:50:+500;
        sa.yticklabel =    -500:50:+500;
        sa.ylim       =   [-500,   +500];
        fig_axis(sa);
        
        %% figure ss
%         figure(f_ss);
%         
%         % subplot
%         subplot(nb_novel,nb_trial,j_subplot);
%         hold('on');
%         
%         % barweb (rt)
%         y = squeeze(mean(ss));
%         e = squeeze(tools_ste(rt));
%         c = squeeze(colour(:,:,i_novel));
%         web = fig_barweb(   y,e,...                                                height and error
%                             [],...                                                 width
%                             {'wrong','correct'},...                                group names
%                             titles{i_novel},...                                    title
%                             [],...                                                 xlabel
%                             '# samples',...                                        ylabel
%                             c,...                                                  colour
%                             [],...                                                 grid
%                             {'not','choice'},...                                   legend
%                             1,...                                                   error sides (1, 2)
%                             'plot'...                                              legend ('plot','axis')
%                             );
%         % axis (rt)
%         sa.ytick      =    0:20:+80;
%         sa.yticklabel =    0:20:+80;
%         sa.ylim       =    [0,+80];
%         fig_axis(sa);
        
        %% return
        rts{i_novel,i_trial} = rt;
    end
    end
    
    fig_figure(f_rt);
%     fig_figure(f_ss);
end