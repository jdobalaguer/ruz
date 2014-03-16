%#ok<*NODEF>

function plot_ruz_fitscape()
    %% load
    load('data/models_ruz.mat','greed_bic');
    load('data/sdata.mat','numbers','models');
    
    %% numbers
    nb_novel   = numbers.shared.nb_novel;
    
    %% compress greed_bic
    greed_bic   =  max(greed_bic,3); % max  (tau)
    greed_bic   = mean(greed_bic,4); % mean (subject)
    greed_bic   = squeeze(greed_bic);

    %% plot
    % greed_bic = [nb_alphat,nb_alphan,nb_novel]
    
    % fig_figure
    fig_figure();
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    % colours
    colours = 'gr';
    
    for i_novel = 1:nb_novel
        
        % subplot
        subplot(1,nb_novel,i_novel);
        hold on;
        
        % plot
        [c,h] = contour(greed_bic(:,:,i_novel), [44,45,48,52,60,80,100,150]);
        clabel(c, h);
        colormap(fig_color('jet',9)./255);
        
        % fig_axis
        sa = struct();
        sa.title   = titles{i_novel};
        sa.xlabel  = 'alpha_T';
        sa.ylabel  = 'alpha_N';
        fig_axis(sa);
    end
end
