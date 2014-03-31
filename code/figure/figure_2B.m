%% 
% FIGURE_2B
% 
% Best-fitting (circles) and reward-maximising (diamonds) values
% of "alpha" and "tau" in the familiar (red) and novel (green)
% cues condition.
% 

function figure_2B()
    %% defaults
    fontname = 'Sans Serif';
    model = model_valid();
    
    %% model
    switch model
        case 'ta2'
            dim_out = 1;
            labels  = {'alpha','tau'};
            max_par = [2,1,1]';
        case 'ta3'
            dim_out = [];
            labels  = {'alpha_M','alpha_R','tau'};
            max_par = [2,1,1]';
        case 'co2'
            dim_out = 1;
            labels  = {'alpha','tau'};
            max_par = [2,1,1]';
        case 'co3'
            dim_out = [];
            labels  = {'alpha_M','alpha_R','tau'};
            max_par = [2,1,1]';
        case 'taco4'
            dim_out = [];
            labels  = {'alpha_M','alpha_RT','alpha_RC','tau'};
            max_par = [4,1,1,1]';
        otherwise
            error('figure_2B: error. model "%s" does not exist',model);
    end
    
    %% load
    load('data/sdata.mat','numbers','models');
    
    %% numbers
    nb_novel = numbers.shared.nb_novel;
    nb_pars  = length(labels);
    
    %% values
    fittings = models.(model).fittings;
    fittings(:,:,dim_out) = [];
    mean_fit = squeeze(mean(fittings,1))' ./ repmat(max_par,1,2);
    ste_fit  = squeeze( ste(fittings,1))' ./ repmat(max_par,1,2);
    
    optimals = models.(model).optimals;
    optimals(:,:,dim_out) = [];
    mean_opt = squeeze(mean(optimals,1))' ./ repmat(max_par,1,2);
    ste_opt  = squeeze( ste(optimals,1))' ./ repmat(max_par,1,2);
    
    %% plot
    set(0, 'DefaultAxesFontName', fontname);
    
    % fig_figure
    figure();
    hold('on');
    
    % colours
    colour = {[1,0,0] , [0,1,0]};
    
    for i_novel = 1:nb_novel
        for i_pars = 1:nb_pars
            % fittings
            m = mean_fit(i_pars,i_novel);
            e =  ste_fit(i_pars,i_novel);
            plot([i_pars,i_pars,],[m-e,m+e],'color',colour{i_novel},'linestyle','-','marker','none',                'linewidth',2.0                                  );
            plot(i_pars,m,                  'color',colour{i_novel},'linestyle','none','marker','o','markersize',10,'linewidth',1.5,'markerfacecolor',colour{i_novel});
            % optimals
            m = mean_opt(i_pars,i_novel);
            e =  ste_opt(i_pars,i_novel);
            plot([i_pars,i_pars,],[m-e,m+e],'color',[0,0,0],'linestyle','-','marker','none',                'linewidth',2.0                                  );
            plot(i_pars,m,                  'color',[0,0,0],'linestyle','none','marker','o','markersize',10,'linewidth',1.5,'markerfacecolor',colour{i_novel});
        end
    end
    
    % fig_axis
    sa = struct();
    sa.xlim       = [0,nb_pars+1];
    sa.xtick      = 1:nb_pars;
    sa.xminor     = 'off';
    sa.xticklabel = labels;
    sa.ylim       = [0,1];
    sa.ytick      = 0:0.5:1;
    sa.ygrid      = 'on';
    fig_axis(sa);
        
    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],18);
    
    % name
    set(gcf(),'Name',['parameters on ',model]);    
    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_2B.pdf');
    
end
