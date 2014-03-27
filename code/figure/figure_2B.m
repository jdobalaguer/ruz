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
    switch model
        case 'ta2'
            dim_out = 1;
            labels  = {'alpha','tau'};
        case 'ta3'
            dim_out = [];
            labels  = {'alpha_M','alpha_R','tau'};
        case 'co2'
            dim_out = 1;
            labels  = {'alpha','tau'};
        case 'co3'
            dim_out = [];
            labels  = {'alpha_M','alpha_R','tau'};
        case 'taco4'
            dim_out = [];
            labels  = {'alpha_M','alpha_RT','alpha_RC','tau'};
        otherwise
            error('figure_2B: error. model "%s" does not exist',model);
    end
    
    %% load
    load('data/sdata.mat','numbers','models');
    
    %% values
    fittings = models.(model).fittings;
    fittings(:,:,dim_out) = [];
    mean_fit = squeeze(mean(fittings,1))';
    ste_fit  = squeeze( ste(fittings,1))';
    
    %% plot
    set(0, 'DefaultAxesFontName', fontname);
    
    % figure
    figure();
    
    % colours
    colours = [1,0,0 ; 0,1,0];
    
    fig_barweb(         mean_fit,... height
                        ste_fit,...  error
                        [],...       width
                        labels,...   group names
                        [],...       title
                        [],...       xlabel
                        [],...       ylabel
                        colours,...  colour
                        [],...       grid
                        [],...       legend
                        [],...       error sides (1, 2)
                        []...        legend ('plot','axis')
                        );
    
    % fig_axis
    sa = struct();
    sa.ylim = [0,1];
    sa.ytick = 0:0.2:1;
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
