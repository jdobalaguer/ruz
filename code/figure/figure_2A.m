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
    model = valid_model();
    
    %% model
    switch model
        case 'ta2'
            dim_out = 1;
            dim_sub = 4;
            max_par = [1,1]';
            s_par1  = 'u_alphar';       s_par2  = 'u_tau';
            t_par1  = 'ALPHA';          t_par2  = 'TAU';
            l_par1  = {'nontarget','target'}; l_par2  = {'max','min'};
        case 'ta3'
            dim_out = 3;
            dim_sub = 4;
            max_par = [2,1]';
            s_par1  = 'u_alpham';       s_par2  = 'u_alphar';
            t_par1  = 'ALPHA_M';        t_par2  = 'ALPHA_R';
            l_par1  = {'dont','learn'}; l_par2  = {'nontarget','target'};
        case 'ch2'
            dim_out = 1;
            dim_sub = 4;
            max_par = [1,1]';
            s_par1  = 'u_alphar';       s_par2  = 'u_tau';
            t_par1  = 'ALPHA';          t_par2  = 'TAU';
            l_par1  = {'nonchoice','choice'}; l_par2  = {'max','min'};
        case 'ch3'
            dim_out = 3;
            dim_sub = 4;
            max_par = [2,1]';
            s_par1  = 'u_alpham';       s_par2  = 'u_alphar';
            t_par1  = 'ALPHA_M';        t_par2  = 'ALPHA_R';
            l_par1  = {'dont','learn'}; l_par2  = {'nonchoice','choice'};
        case 'co2'
            dim_out = 1;
            dim_sub = 4;
            max_par = [1,1]';
            s_par1  = 'u_alphar';       s_par2  = 'u_tau';
            t_par1  = 'ALPHA';          t_par2  = 'TAU';
        case 'co3'
            dim_out = 3;
            dim_sub = 4;
            max_par = [2,1]';
            s_par1  = 'u_alpham';       s_par2  = 'u_alphar';
            t_par1  = 'ALPHA_M';        t_par2  = 'ALPHA_R';
            l_par1  = {'dont','learn'}; l_par2  = {'nontarget','target'};
        case 'taco4'
            dim_out = [1,1];
            dim_sub = 5;
            max_par = [1,1]';
            s_par1  = 'u_alphart';      s_par2  = 'u_alpharc';
            t_par1  = 'ALPHA_{RT}';     t_par2  = 'ALPHA_{RC}';
            l_par1  = {'nontarget','target'}; l_par2  = {'wrong','correct'};
        otherwise
            error('figure_2A: error. model "%s" does not exist',model);
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
    for i = 1:length(max_par), fittings(:,:,i) = fittings(:,:,i)/max_par(i); end
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_par1     = numbers.(model).(s_par1);
    u_par2     = numbers.(model).(s_par2);
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    
    %% compress greed_bic
    rescaling   = nan;
    switch(class(greed_cor))
        case 'uint8'
            rescaling = 1./255;
        otherwise
            rescaling = 1;
    end
    greed_cor   = double(greed_cor) * rescaling;  % rescaling
    for dim = dim_out, greed_cor   = max(greed_cor,[],dim); end % max (free param)
    greed_cor   = mean(greed_cor,dim_sub);   % mean (subject)
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
        subplot(1, nb_novel, i_novel);
        hold on;
        
        % plot cor
        imagesc(u_par1,u_par2,greed_cor(:,:,i_novel)');
%         [c,h] = contourf(u_par1,u_par2,greed_cor(:,:,i_novel)',0.5:0.03:1.0);
%         [c,h] = contour( u_par1,u_par2,greed_cor(:,:,i_novel)',0.5:0.03:1.0,'linewidth',1.8,'linecolor',[0,0,0]);
        [c,h] = contourf(u_par1,u_par2,greed_cor(:,:,i_novel)');
        [c,h] = contour( u_par1,u_par2,greed_cor(:,:,i_novel)','linewidth',1.2,'linecolor',[0,0,0]);
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
        %sa.xtick   = [0,1];
        %sa.xticklabel = l_par1;
        %if i_novel==1; sa.ylabel  = t_par2; end
        %sa.ytick   = [0,1];
        if i_novel==1; %sa.yticklabel = l_par2;
        else           sa.yticklabel = {}; end
        fig_axis(sa);
    end
    
    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],24);
    
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
    fig_export('docs/figures/figure_2A.pdf');
    
end
