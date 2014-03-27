
function figure_RT2()
    %% defaults
    fontname = 'Sans Serif';
    
    %% load
    load('data/sdata');
    [mmmaVc,q_mmm] = jb_discretize(abs(models.taco4.mmmaVc) , 6);
    
    %% numbers
    u_novel       = numbers.shared.u_novel;
    u_mmm = unique(mmmaVc);
    
    nb_novel    = numbers.shared.nb_novel;
    nb_mmm      = length(u_mmm);
    
    %% values
    m_rt = nan(nb_novel,nb_mmm);
    e_rt = nan(nb_novel,nb_mmm);
    for i_novel = 1:nb_novel
        for i_mmm = 1:nb_mmm
            % index
            ii_resp  = (models.human.rt>0);
            ii_trial = (sdata.exp_trial > 1);
            ii_novel = (sdata.vb_novel == u_novel(i_novel));
            ii_mmm   = (mmmaVc == u_mmm(i_mmm));
            % frame
            ii_frame = (ii_resp & ii_trial & ii_novel & ii_mmm);
            % value
            m_rt(i_novel,i_mmm) = mean(models.human.rt(ii_frame));
            e_rt(i_novel,i_mmm) =  ste(models.human.rt(ii_frame));
        end
    end
    
    %% plot
    set(0, 'DefaultAxesFontName', fontname);
    
    % figure
    figure();
    
    % colours
    colours = 'rg';
    
    for i_novel = 1:nb_novel
        % subplot
        subplot(1,nb_novel,i_novel);
        
        % values
        x = u_mmm';
        m = squeeze(m_rt(i_novel,:));
        e = squeeze(e_rt(i_novel,:));
        
        % fig_plot
        fig_plot(x,m,e,colours(i_novel));
        
        % axis
        sa.title    = 'RT PREDICTION';
        sa.xlabel   = 'mmmaVc';
        sa.ylabel   = 'reaction time (sec)';
        sa.xtick    = [1,nb_mmm];
        sa.xticklabel = {'null','max'};
        sa.xlim     = [1,nb_mmm];
        sa.ytick    = 1.1:0.1:1.4;
        sa.ylim     = [1.1,1.4];
        fig_axis(sa);
    end

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
    fig_export('docs/figures/figure_RT2.pdf');
    
end