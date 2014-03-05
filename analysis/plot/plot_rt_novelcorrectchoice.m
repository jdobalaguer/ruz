
function plot_rt_novelcorrectchoice()
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_correct   = [0,1];
    u_choice    = [0,1];
    u_subject   = numbers.shared.u_subject;
    
    nb_novel    = numbers.shared.nb_novel;
    nb_correct  = 2;
    nb_choice   = 2;
    nb_subject  = numbers.shared.nb_subject;
    
    %% plot
    % figure
    f = figure();
    
    % colour
    % colour
    colour        = fig_color('green')./255;
    colour(:,:,2) = fig_color('red')./255;
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % loop (novel)
    for i_novel = 1:nb_novel
        % values
        rt = nan(nb_subject,nb_correct,nb_choice);
        for i_subject = 1:nb_subject
            for i_correct = 1:nb_correct
                for i_choice = 1:nb_choice
                    % index
                    ii_resp    = (models.human.rt>0);
                    ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                    ii_correct = (models.human.correct  == u_correct(i_correct));
                    ii_choice  = (models.human.choice   == u_choice(i_choice));
                    ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                    ii_trial   = (sdata.exp_trial       <12);
                    % value
                    rt(i_subject,i_correct,i_choice) = -1000 + 1000*mean(models.human.rt(ii_resp & ii_subject & ii_novel & ii_correct & ii_choice & ii_trial));
                end
            end
        end
        
        % subplot
        subplot(1,nb_novel,i_novel);
        hold('on');
        
        % barweb
        y = squeeze(mean(rt));
        e = squeeze(tools_ste(rt));
        c = squeeze(colour(:,:,i_novel));
        web = fig_barweb(   y,e,...                                                height and error
                            [],...                                                 width
                            {'wrong','correct'},...                                group names
                            titles{i_novel},...                                    title
                            [],...                                                 xlabel
                            'reaction time (ms)',...                               ylabel
                            c,...                                                  colour
                            [],...                                                 grid
                            {'not','choice'},...                                   legend
                            [],...                                                 error sides (1, 2)
                            'axis'...                                              legend ('plot','axis')
                            );
        % axis
        sa.ytick      =    0:100: 400;
        sa.yticklabel = 1000:100:1400;
        fig_axis(sa);
        
    end
    
    fig_figure(f);
end