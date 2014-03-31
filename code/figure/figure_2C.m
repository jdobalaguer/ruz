%% 
% FIGURE_2C
% 
% Correlations between ? (left panel) and ? (right panel) and
% performance (% correct) for each subject. The line shows the
% best-fitting linear trend.
% 

function figure_2C()
    %% defaults
    fontname = 'Sans Serif';
    model = model_valid();
    
    %% model
    fontname = 'Sans Serif';
    model = model_valid();
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
            error('figure_2C: error. model "%s" does not exist',model);
    end
    
    
    %% load
    load('data/sdata.mat');
    
    %% numbers
    u_subject   = numbers.shared.u_subject;
    u_novel     = numbers.shared.u_novel;
    
    nb_subject  = numbers.shared.nb_subject;
    nb_novel    = numbers.shared.nb_novel;
    nb_pars     = length(labels);
    
    %% values
    performance = nan(nb_subject,nb_novel);
    for i_subject = 1:nb_subject
        for i_novel = 1:nb_novel
            ii_subject  = (sdata.exp_subject == u_subject(i_subject));
            ii_novel    = (sdata.vb_novel    == u_novel(i_novel));
            performance(i_subject,i_novel) = mean(models.human.correct(ii_subject & ii_novel));
        end
    end
    
    fittings = models.(model).fittings;
    fittings(:,:,dim_out) = [];
    
    %% plot
    set(0, 'DefaultAxesFontName', fontname);
    
    % fig_figure
    figure();
    hold('on');
    
    % colours
    colour = {[1,0,0] , [0,1,0]};
    
    j_subplot = 0;
    corrs = nan(nb_novel,nb_pars);
    for i_novel = 1:nb_novel
        for i_pars = 1:nb_pars
            % subplot
            j_subplot = j_subplot + 1;
            subplot(nb_novel,nb_pars,j_subplot);
            hold('on');
            
            % linear regression
            y = performance(:,i_novel);
            x = fittings(:,i_novel,i_pars) ./ max_par(i_pars);
            u = [linspace(0,1,11) ; ones(1,11)]';
            v = [x , ones(size(x))];
            b = pinv(v) * y;
            z = u * b;
            
            % plot
            plot(u(:,1),z,'color','k','linestyle','--','marker','none','markersize',10,'linewidth',1.5);
            
            % plot
            plot(x,y,'color',colour{i_novel},'linestyle','none','marker','.','markersize',10,'linewidth',1.5);
            
            % correlation
            corrs(i_novel,i_pars) = corr(x,y);
            
            % fig_axis
            sa = struct();
            sa.ylim       = [0,1];
            sa.ytick      = 0:0.5:1;
            sa.ygrid      = 'on';
            fig_axis(sa);
        end
    end
    
    corrs
    
        
    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],18);

    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_2C.pdf');
    
end
