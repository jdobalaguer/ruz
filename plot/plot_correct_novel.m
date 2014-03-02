
function plot_correct_novel()
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_subject   = numbers.shared.u_subject;
    u_trial     = numbers.shared.u_trial;
    u_model     = fieldnames(models);
    
    nb_novel    = numbers.shared.nb_novel;
    nb_subject  = numbers.shared.nb_subject;
    nb_trial    = numbers.shared.nb_trial;
    nb_model    = length(u_model);
    
    %% plot
    % figure
    fig_figure();
    
    % colour
    colour = fig_color('forever')./255;
    
    % title
    titles = {'familiar','novel'};
    
    % loop (novel)
    for i_novel = 1:nb_novel
        
        % subplot
        subplot(1,numbers.shared.nb_novel,i_novel);
        hold('on');
        
        % loop (model, subject, trial)
        hdl = [];
        for i_model = 1:nb_model
            model = models.(u_model{i_model});
            correct = nan(nb_subject,nb_trial);
            for i_subject = 1:nb_subject
                for i_trial = 1:nb_trial
                    % index
                    ii_resp    = (models.human.rt>0);
                    ii_novel   = (sdata.vb_novel == u_novel(i_novel));
                    ii_subject = (sdata.exp_subject == u_subject(i_subject));
                    ii_trial   = (sdata.exp_trial == u_trial(i_trial));
                    % value
                    correct(i_subject,i_trial) = mean(model.correct(ii_resp & ii_novel & ii_subject & ii_trial));
                end
            end
            
            % plot
            mean_correct = mean(correct);
            ster_correct = tools_ste(correct);
            hdl_plot     = fig_plot(u_trial,mean_correct,ster_correct,colour(i_model,:));
            hdl(end+1)   = hdl_plot.line;
        end
        
        % axis
        sa.ilegend = hdl;
        sa.tlegend = u_model;
        sa.title   = titles{i_novel};
        sa.xlabel  = 'trial';
        sa.ylabel  = 'performance (% correct)';
        sa.xtick   = [4,8,12,16];
        sa.xlim    = [1,16];
        sa.ytick   = 0.5:.25:1;
        sa.ylim    = [0.5,1];
        fig_axis(sa);
    end
    
end