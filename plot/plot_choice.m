
function plot_correct()
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_subject   = numbers.shared.u_subject;
    u_block     = numbers.shared.u_block;
    u_trial     = numbers.shared.u_trial;
    u_model     = fieldnames(models);
    
    nb_novel    = numbers.shared.nb_novel;
    nb_subject  = numbers.shared.nb_subject;
    nb_block    = numbers.shared.nb_block;
    nb_trial    = numbers.shared.nb_trial;
    nb_model    = length(u_model);
    
    %% plot
    % figure
    fig_figure();
    
    % colour
    colour = fig_color('forever')./255;
    
    titles = {'familiar','novel'};
    % loop (novel)
    for i_novel = 1:nb_novel
        ii_novel = (sdata.vb_novel == u_novel(i_novel));
        
        % subplot
        subplot(1,numbers.shared.nb_novel,i_novel);
        hold('on');
        
        % loop (model)
        hdl = [];
        for i_model = 1:nb_model
            model = models.(u_model{i_model});
            
            % loop (subject, block, trial)
            choice = nan(nb_subject,nb_trial);
            for i_subject = 1:nb_subject
                ii_subject = (sdata.exp_subject == u_subject(i_subject));
                for i_trial = 1:nb_trial
                    ii_trial = (sdata.exp_trial == u_trial(i_trial));
                    choice(i_subject,i_trial) = mean(model.choice(ii_novel & ii_subject & ii_trial));
                end
            end
            
            % plot
            mean_choice = mean(choice);
            ster_choice = std(choice)./sqrt(nb_subject);
            hdl_plot = fig_plot(u_trial,mean_choice,ster_choice,colour(i_model,:));
            hdl(end+1) = hdl_plot.line;
        end
        
        % axis
        sa.ilegend = hdl;
        sa.tlegend = u_model;
        sa.title   = titles{i_novel};
        sa.xlabel  = 'trial';
        sa.ylabel  = 'response (% target)';
        sa.xtick   = [1,4,8,12,16];
        sa.xlim    = [1,16];
        sa.ytick   = 0:.25:1;
        sa.ylim    = [0,1];
        fig_axis(sa);
    end
    
end