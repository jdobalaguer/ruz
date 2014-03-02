
function plot_rt()
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_subject   = numbers.shared.u_subject;
    u_trial     = numbers.shared.u_trial;
    
    nb_novel    = numbers.shared.nb_novel;
    nb_subject  = numbers.shared.nb_subject;
    nb_trial    = numbers.shared.nb_trial;
    
    %% plot
    % figure
    fig_figure();
    hdl = [];
    hold('on');
    
    % colour
    colour = jet(2);
    
    % loop (novel)
    for i_novel = 1:nb_novel
        ii_novel = (sdata.vb_novel == u_novel(i_novel));
        
        % subplot
        
        % loop (subject, trial)
        choice = nan(nb_subject,nb_trial);
        for i_subject = 1:nb_subject
            ii_subject = (sdata.exp_subject == u_subject(i_subject));
            for i_trial = 1:nb_trial
                ii_trial = (sdata.exp_trial == u_trial(i_trial));
                choice(i_subject,i_trial) = mean(models.human.rt(ii_novel & ii_subject & ii_trial));
            end
        end

        % plot
        mean_choice = mean(choice);
        ster_choice = std(choice)./sqrt(nb_subject);
        hdl_plot    = fig_plot(u_trial,mean_choice,ster_choice,colour(i_novel,:));
        hdl(end+1)  = hdl_plot.line;
    end
    
    % axis
    sa.title    = 'REACTION TIME FOR FAMILIAR/NOVEL';
    sa.ilegend  = hdl;
    sa.tlegend  = {'familiar','novel'};
    sa.xlabel   = 'trial';
    sa.ylabel   = 'reaction time (sec)';
    sa.xtick    = [1,4,8,12,16];
    sa.xlim     = [1,16];
    sa.ytick    = 1:.1:1.5;
    sa.ylim     = [1,1.5];
    fig_axis(sa);
    
end