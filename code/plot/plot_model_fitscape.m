%#ok<*NODEF>
%#ok<*NASGU>

function plot_model_fitscape(model)
    %% load
    load(['data/models_',model,'.mat'],'greed_bic');
    load('data/sdata.mat','numbers','models');
    
    %% numbers
    switch(model)
        case 'ta2'
            dim_out   = 1;
            u_par1  = numbers.(model).u_tau;
            u_par2  = numbers.(model).u_alphar;
            lab1    = 'tau';
            lab2    = 'alpha_R';
        case 'ta3'
            dim_out   = 3;
            u_par1  = numbers.(model).u_alpham;
            u_par2  = numbers.(model).u_alphar;
            lab1    = 'alpha_M';
            lab2    = 'alpha_R';
        case 'co2'
            dim_out   = 1;
            u_par1  = numbers.(model).u_tau;
            u_par2  = numbers.(model).u_alphar;
            lab1    = 'tau';
            lab2    = 'alpha_R';
        case 'co3'
            dim_out   = 3;
            u_par1  = numbers.co3.u_alpham;
            u_par2  = numbers.(model).u_alphar;
            lab1    = 'alpha_M';
            lab2    = 'alpha_R';
        case 'taco4'
            dim_out   = 4;
            u_par1  = numbers.(model).u_alphart;
            u_par2  = numbers.(model).u_alpharc;
            lab1    = 'alpha_{RT}';
            lab2    = 'alpha_{RC}';
        otherwise
            error('plot_model_fitscape: error. unknown model "%s"',model);
    end
            
    nb_novel   = numbers.shared.nb_novel;
    
    %% compress greed_bic
    for dim = dim_out, greed_bic   = min(greed_bic,[],dim); end % max (free param)
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
        this_greedbic = greed_bic(:,:,i_novel);
        if length(unique(this_greedbic(:)))>1
            [c,h] = contourf(u_par1,u_par2,this_greedbic);
            clabel(c, h);
        else
            imagesc(this_greedbic,[0,255]);
            xlim([1,length(u_par1)]);
            ylim([1,length(u_par2)]);
        end
        colormap(fig_color('jet',50)./255);
        
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
