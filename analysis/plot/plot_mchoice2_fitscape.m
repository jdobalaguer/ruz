%#ok<*NODEF>

function plot_mchoice_fitscape()
    %% load
    load('data/models_choice2.mat','greed_bic');
    load('data/sdata.mat','numbers','models');
    
    %% numbers
    nb_novel   = numbers.shared.nb_novel;
    
    %% compress greed_bic
    size(greed_bic)
    greed_bic   = mean(greed_bic,4); % mean (subject)
    greed_bic   = squeeze(greed_bic);

    %% plot
    % greed_bic = [nb_alphat,nb_tau,nb_novel]
    
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
        [c,h] = contour(greed_bic(:,:,i_novel), [40,41,43,45,50,70,100,150]);
        clabel(c, h);
        colormap(fig_color('jet',9)./255);
        
        % fig_axis
        sa = struct();
        sa.title   = titles{i_novel};
        sa.xlabel  = 'alpha_T';
        sa.ylabel  = 'tau';
        fig_axis(sa);
    end
end
