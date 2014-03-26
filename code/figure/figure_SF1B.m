
function figure_SF1B()
    %% defaults
    hbm   = 'hbm';
    
    %% load
    sdata   = struct();
    models  = struct();
    numbers = struct();
    mdata   = struct();
    load('data/sdata.mat');
    load('data/models_hbm.mat');
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_trial    = numbers.shared.u_trial;
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_trial   = numbers.shared.nb_trial;
    
    %% values
    candidates = nan(nb_subject,nb_novel,nb_trial);
    
    for i_subject = 1:nb_subject
    for i_novel = 1:nb_novel
    for i_trial = 1:nb_trial
        
        ii_subject  = (sdata.exp_subject == u_subject(i_subject));
        ii_novel    = (sdata.vb_novel == u_novel(i_novel));
        ii_trial    = (sdata.exp_trial == u_trial(i_trial));
        ii = (ii_subject & ii_novel & ii_trial);
        
        candidates(i_subject,i_novel,i_trial)    = mean(mdata.nb_candidates(ii));
        
    end
    end
    end
    
    %% plot
    
    % fig_figure
    figure();
    
    % colours
    colours = {[1,0,0] , [0,1,0]};
    
    j_subplot = 0;
    for i_novel = 1:2
        
        % correct
        j_subplot = j_subplot + 1;
        subplot(1,2,j_subplot);
        hold('on');
        
        plot(squeeze(mean(candidates(:,i_novel,:),1)),'color',colours{i_novel},'linestyle',  '--','linewidth', 2);
        
        sa.xlim    = [1,16];
        sa.xtick   = 5:5:15;
        sa.ylim    = [0,40];
        sa.ytick   = 0:10:40;
        fig_axis(sa);
        
    end
    
    % fig_figure
    fig_figure(gcf());
    
    %% smaller figure
    % window position
    pos = get(gcf(),'Position');
    pos(4) = 0.6 .* pos(4);
    set(gcf(),'Position',pos);
    % paper size
    set(gcf(),'PaperPositionMode','auto');
    psi = 4 * pos(3:4) ./ pos(4);
    set(gcf(),'PaperSize',psi);
    
    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_SF1B.pdf');
    
end
