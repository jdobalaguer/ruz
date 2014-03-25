%#ok<*NODEF>
%#ok<*NASGU>

function plot_model_fitscape(model)
    %% load
    load(['data/models_',model,'.mat'],'greed_bic');
    load('data/sdata.mat','numbers','models');
    
    %% numbers
    switch(model)
        case 'ratio'
            dim_out   = 3;
            u_par1  = numbers.ratio.u_alpham;
            u_par2  = numbers.ratio.u_alphar;
            lab1    = 'alpha_M';
            lab2    = 'alpha_R';
        case 'ratio2'
            dim_out   = 1;
            u_par1  = numbers.ratio.u_tau;
            u_par2  = numbers.ratio.u_alphar;
            lab1    = 'tau';
            lab2    = 'alpha_R';
        otherwise
            error('plot_model_fitscape: unknown model "%s"',model);
    end
            
    nb_novel   = numbers.shared.nb_novel;
    
    %% compress greed_bic
    greed_bic   = max(greed_bic,[],dim_out); % max (free param)
    greed_bic   = mean(greed_bic,4); % mean (subject)
    greed_bic   = squeeze(greed_bic);

    %% plot
    % greed_bic = [nb_alphat,nb_alphan,nb_novel]
    
    % fig_figure
    fig_figure();
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % colours
    colours = 'rg';
    
    for i_novel = 1:nb_novel
        
        % subplot
        subplot(1,nb_novel,i_novel);
        hold on;
        
        % plot
        [c,h] = contourf(u_par1,u_par2,greed_bic(:,:,i_novel));%, [44,45,48,52,60,80,100,150]);
        clabel(c, h);
        colormap(fig_color('jet',9)./255);
        
        % fig_axis
        sa = struct();
        sa.title   = titles{i_novel};
        sa.xlabel  = lab1;
        sa.ylabel  = lab2;
        fig_axis(sa);
    end
    
    % name
    set(gcf(),'Name',['fittings on ',model]);
end
