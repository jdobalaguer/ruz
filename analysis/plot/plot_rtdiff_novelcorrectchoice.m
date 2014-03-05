
function plot_rtdiff_novelcorrectchoice()
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
    f_ss = figure();
    
    % colour
    % colour
    colour        = fig_color('green')./255;
    colour(:,:,2) = fig_color('red')./255;
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % loop (novel)
    j_subplot = 0;
    for i_novel = 1:nb_novel
    for i_trial = 1:nb_trial
        %% values
        ss = nan(nb_subject,nb_correct,nb_choice);
        rt = nan(nb_subject,nb_correct,nb_choice);
        for i_subject = 1:nb_subject
            for i_correct = 1:nb_correct
                for i_choice = 1:nb_choice
                    % index
                    ii_resp    = (models.human.rt>0.2);
                    ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                    ii_correct = (models.human.correct  == u_correct(i_correct));
                    ii_choice  = (models.human.choice   == u_choice(i_choice));
                    ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                    ii_trial   = (sdata.exp_trial       == u_trial(i_trial));
                    ii_nstart  =~(sdata.exp_start);
                    ii_nend    =~(sdata.exp_end);
                    ii1        = (ii_resp & ii_subject & ii_novel & ii_correct & ii_choice & ii_trial);
                    ii2        = logical([0 ; ii1(1:end-1)]);
                    % value
                    rt1 = models.human.rt(ii1 & ii_nend);
                    rt2 = models.human.rt(ii2 & ii_nstart);
                    ss(i_subject,i_correct,i_choice) = sum(ii1);
                    rt(i_subject,i_correct,i_choice) = 1000*mean(rt2 - rt1);
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
        y = squeeze(mean(rt));
        e = squeeze(tools_ste(rt));
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
                            [],...                                                 error sides (1, 2)
                            'plot'...                                              legend ('plot','axis')
                            );
        % axis (rt)
        sa.ytick      =    -500:100:+500;
        sa.yticklabel =    -500:100:+500;
        sa.ylim       =    [-500,   +500];
        fig_axis(sa);
        
        %% figure ss
        figure(f_ss);
        
        % subplot
        subplot(nb_novel,nb_trial,j_subplot);
        hold('on');
        
        % barweb (rt)
        y = squeeze(mean(ss));
        e = squeeze(tools_ste(rt));
        c = squeeze(colour(:,:,i_novel));
        web = fig_barweb(   y,e,...                                                height and error
                            [],...                                                 width
                            {'wrong','correct'},...                                group names
                            titles{i_novel},...                                    title
                            [],...                                                 xlabel
                            '# samples',...                                        ylabel
                            c,...                                                  colour
                            [],...                                                 grid
                            {'not','choice'},...                                   legend
                            [],...                                                 error sides (1, 2)
                            'plot'...                                              legend ('plot','axis')
                            );
        % axis (rt)
        sa.ytick      =    0:20:+100;
        sa.yticklabel =    0:20:+100;
        sa.ylim       =    [0,+100];
        fig_axis(sa);
        
    end
    end
    
    fig_figure(f_rt);
    fig_figure(f_ss);
end