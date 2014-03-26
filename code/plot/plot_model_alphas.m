
function plot_model_alphas(model)
    %% load
    load('data/sdata.mat','numbers','models');
    if exist(['data/models_',model,'.mat'],'file')
        load(['data/models_',model,'.mat'],'mdata');
    end
    
    %% model
    switch(model)
        case 'ta2'
            dim_out = 1;
            lab1        = 'alpha_R';
            lab2        = 'tau';
            group_names = {'alpha_M','alpha_R','tau'};
        case 'ta3'
            dim_out = 3;
            lab1        = 'alpha_M';
            lab2        = 'alpha_R';
            group_names = {'alpha_M','alpha_R','tau'};
        case 'co2'
            dim_out = 1;
            lab1        = 'alpha_R';
            lab2        = 'tau';
            group_names = {'alpha_M','alpha_R','tau'};
        case 'co3'
            dim_out = 3;
            lab1        = 'alpha_M';
            lab2        = 'alpha_R';
            group_names = {'alpha_M','alpha_R','tau'};
        otherwise
            error('plot_model_fitscape: unknown model "%s"',model);
    end
    
    
    %% figure 1
    % numbers
    nb_novel   = numbers.shared.nb_novel;
    nb_subject = numbers.shared.nb_subject;
    
    % get fittings
    fittings = models.(model).fittings;
    y = squeeze(mean(fittings,1))';
    e = squeeze(ste(fittings,1))';
    
    % figure
    figure();
    
    % colours
    colours = [1,0,0 ; 0,1,0];
    
    fig_barweb(         y,e,...                                                height and error
                        [],...                                                 width
                        group_names,...                                        group names
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
    
    % name
    set(gcf(),'Name',['parameters on ',model]);
    
    %% figure 2
    mdata_keys = mdata.keys();
    fittings(:,:,dim_out) = [];

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
        par1 = fittings(:,:,1);
        par2 = fittings(:,:,2);
        for i_subject = 1:nb_subject
            plotmark = [colours(i_novel),'o'];
            plot(par1(i_subject,i_novel),par2(i_subject,i_novel),plotmark);
        end
        
        % fig_axis
        sa = struct();
        sa.title   = titles{i_novel};
        sa.xlabel  = lab1;
        sa.ylabel  = lab2;
        sa.xtick   = 0:0.2:1;
        sa.xlim    = [0,1];
        sa.ytick   = 0:0.2:1;
        sa.ylim    = [0,1];
        fig_axis(sa);
    end
    
    % name
    set(gcf(),'Name',['alphas on ',model]);
end
