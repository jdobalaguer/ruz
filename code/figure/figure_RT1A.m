
function figure_RT1A()
    %% defaults
    fontname = 'Sans Serif';
    
    %% load
    load('data/sdata');
    models.human.rt = 1000*models.human.rt;
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_subject   = numbers.shared.u_subject;
    u_trial     = numbers.shared.u_trial;
    
    nb_novel    = numbers.shared.nb_novel;
    nb_subject  = numbers.shared.nb_subject;
    nb_trial    = numbers.shared.nb_trial;
    
    %% plot
    set(0, 'DefaultAxesFontName', fontname);
    
    % figure
    figure();
    hdl = [];
    hold('on');
    
    % colour
    rgb_colour = [1,0,0;0,1,0];
    str_colour = 'rg';
    
    % loop (novel)
    for i_novel = 1:nb_novel
        
        % loop (subject, trial)
        rt = nan(nb_subject,nb_trial);
        for i_subject = 1:nb_subject
            for i_trial = 1:nb_trial
                % index
                ii_resp    = (models.human.rt>0);
                ii_novel = (sdata.vb_novel == u_novel(i_novel));
                ii_subject = (sdata.exp_subject == u_subject(i_subject));
                ii_trial = (sdata.exp_trial == u_trial(i_trial));
                % value
                rt(i_subject,i_trial) = mean(models.human.rt(ii_resp & ii_novel & ii_subject & ii_trial));
            end
        end

        % plot
        mean_rt = mean(rt);
        ster_rt = tools_ste(rt);
        hdl_plot    = fig_plot(u_trial,mean_rt,ster_rt,rgb_colour(i_novel,:));
        hdl(end+1)  = hdl_plot.line;
        plot(u_trial,mean_rt,[str_colour(i_novel),'x']);
    end
    
    % axis
    sa.title    = 'REACTION TIME OVER TRIALS';
    sa.xlabel   = 'trial';
    sa.ylabel   = 'reaction time (msec)';
    sa.xtick    = [4,8,12,16];
    sa.xlim     = [1,16];
    sa.ytick    = 1000:100:1500;
    sa.ylim     = [1000,1500];
    fig_axis(sa);
    
    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],18);
    
    %% smaller figure
    % paper size
    set(gcf(),'PaperPositionMode','auto');
    psi = get(gcf(),'PaperSize');
    psi(2) = 0.6*psi(2);
    set(gcf(),'PaperSize',psi);
    
    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_RT1A.pdf');
    
end