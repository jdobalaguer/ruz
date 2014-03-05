
function plot_rtdiff_novelcorrect()
    if ~usejava('swing'); return; end
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_correct   = [0,1];
    u_subject   = numbers.shared.u_subject;
    
    nb_novel    = numbers.shared.nb_novel;
    nb_correct  = 2;
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
        rt = nan(nb_subject,nb_correct);
        for i_subject = 1:nb_subject
            for i_correct = 1:nb_correct
                % index
                ii_resp    = (models.human.rt>0.2);
                ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                ii_correct = (models.human.correct  == u_correct(i_correct));
                ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                ii_trial   = (sdata.exp_trial       <10);
                ii1        = (ii_resp & ii_subject & ii_novel & ii_correct & ii_trial);
                ii2        = logical([0 ; ii1(1:end-1)]);
                % value
                rt1 = models.human.rt(ii1);
                rt2 = models.human.rt(ii2);
                rt(i_subject,i_correct) = 1000*mean(rt2 - rt1);
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
                            [],...                                                 group names
                            titles{i_novel},...                                    title
                            [],...                                                 xlabel
                            'reaction time (ms)',...                               ylabel
                            c,...                                                  colour
                            [],...                                                 grid
                            {'wrong','correct'},...                                legend
                            [],...                                                 error sides (1, 2)
                            'axis'...                                              legend ('plot','axis')
                            );
        % axis
        sa.ytick      =    -100:10:+100;
        sa.yticklabel =    -100:10:+100;
        sa.ylim       =    [-100,   +100];
        fig_axis(sa);
        
    end
    
    fig_figure(f);
end