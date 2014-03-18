
function plot_mchoice2_alphas()
    %% figure 1
    % load
    load('data/sdata.mat','numbers','models');
    
    % numbers
    nb_novel   = numbers.shared.nb_novel;
    nb_subject = numbers.shared.nb_subject;
    
    % get fittings
    fittings = models.choice2.fittings;
    alpha_t  = fittings(:,:,1);
    alpha_n  = fittings(:,:,2);
    tau      = fittings(:,:,3);
    
    %% plot mean
    
    y = [mean(alpha_t) ; mean(alpha_n) ; mean(tau)];
    e = [ste(alpha_t)  ; ste(alpha_n)  ; ste(tau) ];
    
    % figure
    figure();
    
    % colours
    colours = [0,1,0;1,0,0];
    
    fig_barweb(         y,e,...                                                height and error
                        [],...                                                 width
                        {'alpha_T','alpha_N','tau'},...                        group names
                        [],...                                                 title
                        [],...                                                 xlabel
                        [],...                                                 ylabel
                        colours,...                                            colour
                        [],...                                                 grid
                        {'familiar','novel'},...                               legend
                        [],...                                                 error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    
    % fig_axis
    sa = struct();
    sa.title   = 'AVERAGE FITTING PARAMETERS';
    fig_axis(sa);
        
    % fig_figure
    fig_figure(gcf());
    
    %% figure 2
    load('data/models_choice2.mat','mdata');
    mdata_keys = mdata.keys();

    %% plot landscape
    
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
        for i_subject = 1:nb_subject
            plotmark = [colours(i_novel),'o'];
            plot(alpha_t(i_subject,i_novel),alpha_n(i_subject,i_novel),plotmark);
        end
        
        % fig_axis
        sa = struct();
        sa.title   = titles{i_novel};
        sa.xlabel  = 'alpha_T';
        sa.ylabel  = 'alpha_N';
        sa.xtick   = 0:0.2:1;
        sa.xlim    = [0,1];
        sa.ytick   = 0:0.2:1;
        sa.ylim    = [0,1];
        fig_axis(sa);
    end
    
end
