%#ok<*NODEF>
%#ok<*NASGU>

function plot_model_fitline(model)
    %% load
    load(['data/models_',model,'.mat'],'greed_bic');
    load('data/sdata.mat','numbers','models');
    
    %% numbers
    switch(model)
        case 'ta2'
            dim_out   = 1;
            pars = {numbers.(model).u_alphar,numbers.(model).u_tau};
            labs = {'alpha_R','tau'};
        case 'ta3'
            dim_out   = [];
            pars = {numbers.(model).u_alpham,numbers.(model).u_alphar,numbers.(model).u_tau};
            labs = {'alpha_M','alpha_R','tau'};
        case 'co2'
            dim_out   = 1;
            pars = {numbers.(model).u_alphar,numbers.(model).u_tau};
            labs = {'alpha_R','tau'};
        case 'co3'
            dim_out   = [];
            pars = {numbers.(model).u_alpham,numbers.(model).u_alphar,numbers.(model).u_tau};
            labs = {'alpha_M','alpha_R','tau'};
        otherwise
            error('plot_model_fitscape: unknown model "%s"',model);
    end
            
    nb_novel   = numbers.shared.nb_novel;
    nb_pars    = length(pars);
    
    %% assert
    assert(length(pars)==length(labs),'plot_model_fitline: error. pars and labs have different length');
    
    %% compress greed_bic
    if ~isempty(dim_out)
        greed_bic   = max(greed_bic,[],dim_out); % max  (dim_out)
    end
    greed_bic   = mean(greed_bic,4);         % mean (subject)
    greed_bic   = squeeze(greed_bic);
    
    %% plot
    % greed_bic = [nb_alphat,nb_alphan,nb_novel]
    
    % fig_figure
    fig_figure();
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % colours
    colours = {fig_color('red',20)./255 , fig_color('green',20)./255};
    
    j_subplot = 0;
    for i_novel = 1:nb_novel
    for i_pars  = 1:nb_pars
        
        % value
        line_bic = greed_bic;
        not_pars = 1:nb_pars;
        not_pars(i_pars) = [];
        for i_not = length(not_pars)
            line_bic = max(line_bic,[],not_pars(i_not));
        end
        line_bic = squeeze(line_bic);
        line_bic = line_bic(:,i_novel);
        line_bic = repmat(line_bic,[1,2]);
        
        % subplot
        j_subplot = j_subplot + 1;
        subplot(nb_novel,nb_pars,j_subplot);
        hold on;
        
        % plot
        imagesc(pars{i_pars},1,line_bic);
        %[c,h] = contourf(pars{i_pars},0:1,line_bic');
        %clabel(c, h);
        %colormap(colours{i_novel});
        
        % fig_axis
        sa = struct();
        sa.title   = labs{i_pars};
        sa.xlim    = [0,2];
        sa.xtick   = [];
        sa.ytick   = 1:5:length(pars{i_pars});
        sa.yticklabel = num2leg(pars{i_pars}(1:5:end));
        fig_axis(sa);
    end
    end
    
    % name
    set(gcf(),'Name',['fittings on ',model]);
end
