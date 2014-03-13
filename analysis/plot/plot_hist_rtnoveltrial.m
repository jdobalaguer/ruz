
function plot_hist_rtnoveltrial()
    if ~usejava('swing'); return; end
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_subject   = numbers.shared.u_subject;
    u_trial     = numbers.shared.u_trial;
    u_novel     = numbers.shared.u_novel;
    
    nb_subject  = numbers.shared.nb_subject;
    nb_trial    = numbers.shared.nb_trial;
    nb_novel    = numbers.shared.nb_novel;
    
    %% plot
    % figure
    f = figure();
    
    % titles
    titles = num2leg(u_trial);
    
    % colours
    colours = 'gr';
    
    % plot
    j_subplot = 0;
    for i_novel = 1:nb_novel
        for i_trial = 1:nb_trial
            % index
            ii_resp     = (models.human.rt>0);
            ii_novel    = (sdata.vb_novel  == u_novel(i_novel));
            ii_trial    = (sdata.exp_trial == u_trial(i_trial));
            ii          = ii_resp & ii_novel & ii_trial;
            % value
            rt = models.human.rt(ii);
            % subplot
            j_subplot = j_subplot + 1;
            subplot(nb_novel,nb_trial,j_subplot);
            hold('on');
            % histogram
            x_hist = 0.0:0.2:3.0;
            y_hist = hist(rt,x_hist);
            y_hist = y_hist ./ sum(y_hist);
            bar(x_hist,y_hist,'FaceColor',colours(i_novel));
            % axis
            sa.title   = titles{i_trial};
            sa.xlabel  = 'rt (s)';
            sa.ylabel  = 'histogram';
            sa.xtick  = 0:1:3;
            sa.xlim    = [0,3];
            sa.ytick   = 0:0.05:0.25;
            sa.ylim    = [0,0.25];
            fig_axis(sa);
        end
    end

    fig_figure(f);
end