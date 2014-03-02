
function plot_rt_noveliticorrectchoice()
    
    %% load
    load('data/sdata');
    sdata.vb_slowiti = tools_discretize(sdata.time_iti,5);
    sdata.vb_slowiti(sdata.vb_slowiti>3) = 3;
    
    %% numbers
    u_slowiti   = unique(sdata.vb_slowiti);
    u_novel     = numbers.shared.u_novel;
    u_correct   = [0,1];
    u_choice    = [0,1];
    u_subject   = numbers.shared.u_subject;
    
    nb_slowiti  = length(u_slowiti);
    nb_novel    = numbers.shared.nb_novel;
    nb_correct  = 2;
    nb_choice   = 2;
    nb_subject  = numbers.shared.nb_subject;
    
    %% plot
    % figure
    f = figure();
    
    % colour
    colour        = fig_color('green')./255;
    colour(:,:,2) = fig_color('red')./255;
    
    % titles
    titles = {'FAMILIAR QUICK','NOVEL QUICK';'','';'','';'FAMILIAR SLOW','NOVEL SLOW'};
    
    % loop (novel, slow)
    j_subplot = 0;
    for i_slowiti = 1:nb_slowiti
        for i_novel = 1:nb_novel
        
            % values
            rt = nan(nb_subject,nb_correct,nb_choice);
            for i_subject = 1:nb_subject
                for i_correct = 1:nb_correct
                    for i_choice = 1:nb_choice
                        % index
                        ii_resp    = (models.human.rt>0);
                        ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                        ii_slowiti = (sdata.vb_slowiti      == u_slowiti(i_slowiti));
                        ii_correct = (models.human.correct  == u_correct(i_correct));
                        ii_choice  = (models.human.choice   == u_choice(i_choice));
                        ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                        ii_trial   = (sdata.exp_trial       >1);
                        % value
                        rt(i_subject,i_correct,i_choice) = -1000 + 1000*mean(models.human.rt(ii_resp & ii_novel & ii_slowiti & ii_correct & ii_choice & ii_subject & ii_trial));
                    end
                end
            end

            % subplot
            j_subplot = j_subplot + 1;
            subplot(nb_slowiti,nb_novel,j_subplot);
            hold('on');

            % barweb
            y = squeeze(nanmean(rt));
            e = squeeze(tools_ste(rt));
            c = squeeze(colour(:,:,i_novel));
            
            web = fig_barweb(   y,...                                                  height
                                e,...                                                  error
                                [],...                                                 width
                                {'wrong','correct'},...                                group names
                                titles{i_slowiti,i_novel},...                          title
                                [],...                                                 xlabel
                                'reaction time (ms)',...                               ylabel
                                c,...                                                  colour
                                'y',...                                                 grid
                                {'not','choice'},...                                   legend
                                [],...                                                 error sides (1, 2)
                                'axis'...                                              legend ('plot','axis')
                                );
            % axis
            sa.ytick      =    0:100: 500;
            sa.yticklabel = 1000:100:1500;
            sa.ylim       = [0,500];
            fig_axis(sa);
        end
    end
    
    fig_figure(f);
end