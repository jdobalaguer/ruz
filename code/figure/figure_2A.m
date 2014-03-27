%% 
% FIGURE_2A
% 
% Model performance as a function of model parameters "alpha"
% (steepness of disconfirmatory vs. confirmatory learning) and
% "tau" (decisions based on max vs. min target value) on blocks
% with familiar cues (left panel) and novel cues (right panel).
% Darker grey indicates higher performance (% correct). Red and
% green dots show individual humans subjects in the novel and
% familiar cues conditions respectively.
% 

function figure_2A()
    %% defaults
    fontname = 'Sans Serif';
    model = model_valid();
    switch model
        case 'ta2'
            dim_out = 1;
            s_par1  = 'u_alphar';       s_par2  = 'u_tau';
            t_par1  = 'ALPHA';          t_par2  = 'TAU';
            l_par1  = {'not','target'}; l_par2  = {'max','min'};
        case 'ta3'
            dim_out = 3;
            s_par1  = 'u_alpham'; s_par2  = 'u_alphar';
            t_par1  = 'alpha_M';  t_par2  = 'alpha_R';
            l_par1  = {'not','target'}; l_par2  = {'not','target'};
        case 'co2'
            dim_out = 1;
            s_par1  = 'u_alphar';       s_par2  = 'u_tau';
            t_par1  = 'ALPHA';          t_par2  = 'TAU';
            l_par1  = {'not','target'}; l_par2  = {'max','min'};
        case 'co3'
            dim_out = 3;
            s_par1  = 'u_alpham'; s_par2  = 'u_alphar';
            t_par1  = 'alpha_M';  t_par2  = 'alpha_R';
            l_par1  = {'not','target'}; l_par2  = {'not','target'};
        case 'taco3'
    end
    
    %% load
    models  = struct();
    numbers = struct();
    greed_cor = [];
    load(['data/models_',model,'.mat'],'greed_cor');
    load('data/sdata.mat','numbers','models');
    % fitting parameters
    fittings = models.(model).fittings;
    fittings(:,:,dim_out) = [];
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_par1     = numbers.(model).(s_par1);
    u_par2     = numbers.(model).(s_par2);
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    
    %% compress greed_bic
    greed_cor   = double(greed_cor) ./ 255;  % uint rescaling
    greed_cor   = max(greed_cor,[],dim_out); % max (free param)
    greed_cor   = mean(greed_cor,4);         % mean (subject)
    greed_cor   = squeeze(greed_cor);

    %% plot
    % greed_cor = [nb_alphat,nb_alphan,nb_novel]
    % feetings  = [nb_subject,nb_novel,nb_par]
    set(0, 'DefaultAxesFontName', fontname);
    
    % fig_figure
    fig_figure();
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % colours
    colours = {[1,0,0] , [0,1,0]};
    
    for i_novel = 1:nb_novel
        
        % subplot
        subplot(1, 2*nb_novel-1, 2*(i_novel-1)+1);
        hold on;
        
        % plot cor
        %imagesc(u_par1,u_par2,greed_cor(:,:,i_novel));
        [c,h] = contourf(u_par1,u_par2,greed_cor(:,:,i_novel)',0.5:0.05:1.0);
        [c,h] = contour(u_par1,u_par2,greed_cor(:,:,i_novel)',...
                        0.5:0.05:1.0, ...
                        'linewidth',2,'linecolor',[0,0,0]);
        %clabel(c, h);
        colormap(fig_color('gray',21)./255);
        xlim([0,1]);
        ylim([0,1]);
        caxis([0.4,1]);
        
        % plot parameters
        for i_subject = 1:nb_subject
            plot(fittings(i_subject,i_novel,1),fittings(i_subject,i_novel,2),'color',colours{i_novel},'linestyle','none','marker','o','markersize',10,'markerfacecolor',colours{i_novel});
        end
        
        % fig_axis
        sa = struct();
        sa.title   = titles{i_novel};
        sa.xlabel  = t_par1;
        sa.xtick   = [0,1];
        sa.xticklabel = l_par1;
        sa.ylabel  = t_par2;
        sa.ytick   = [0,1];
        sa.yticklabel = l_par2;
        fig_axis(sa);
    end
    
    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],18);
    
    %% smaller figure
    % window position
    pos = get(gcf(),'Position');
    pos(3) = 1.7 .* pos(3);
    pos(4) = 0.6 .* pos(4);
    set(gcf(),'Position',pos);
    % paper size
    set(gcf(),'PaperPositionMode','auto');
    psi = 4 * pos(3:4) ./ pos(4);
    set(gcf(),'PaperSize',psi);
   
    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_2A.pdf');
    
end
