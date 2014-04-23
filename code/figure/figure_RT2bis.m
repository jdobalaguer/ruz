
function figure_RT2bis()
    %% defaults
    fontname = 'Sans Serif';
    model = model_valid();
    n = 5;
    
    %% load
    load('data/sdata');
    [mmmaVc,q_mmm] = jb_discretize((models.(model).mmmaVc) , n);
    
    %% numbers
    u_subject   = numbers.shared.u_subject;
    u_mmm       = unique(mmmaVc);
    
    nb_subject  = numbers.shared.nb_subject;
    nb_mmm      = length(u_mmm);
    
    %% values
    rt = nan(nb_subject,nb_mmm);
    for i_subject = 1:nb_subject
        for i_mmm = 1:nb_mmm
            % index
            ii_resp    = (models.human.rt>0);
            ii_trial   = (sdata.exp_trial > 1);
            ii_subject = (sdata.exp_subject == u_subject(i_subject));
            ii_mmm     = (mmmaVc == u_mmm(i_mmm));
            % frame
            ii_frame = (ii_resp & ii_trial & ii_subject & ii_mmm);
            % value
            rt(i_subject,i_mmm) = nanmean(models.human.rt(ii_frame));
        end
    end
    
    %% plot
    set(0, 'DefaultAxesFontName', fontname);
    
    % figure
    figure();
    
    % colours
    colours = 'rg';

    % axis
    sa.title    = '';
    sa.ylabel   = 'reaction time (sec)';
    sa.ylim     = [1.0,1.4];
    sa.ytick    = (1.0:0.1:1.4) - sa.ylim(1);
    sa.yticklabel = num2leg(sa.ytick + sa.ylim(1));
    
    % values
    x = u_mmm';
    m = nanmean(rt,1) - sa.ylim(1);
    e =  nanste(rt,1);

    % fig_barweb
    leg = repmat({''},1,n);
    leg{1}   = 'min';
    leg{end} = 'max';
    web = fig_barweb(m,e,...
                        [],...                                                 width
                        {''},...                                               group names
                        'RT PREDICTION',...                                    title
                        'mmmaVc',...                                           xlabel
                        [],...                                                 ylabel
                        fig_color('w',nb_mmm)./255,...                         colour
                        [],...                                                 grid
                        leg,...                                                legend
                        [],...                                                 error sides (1, 2)
                        'axis'...                                              legend ('plot','axis')
                        );
    
    % fig_axis
    sa.ylim     = sa.ylim - sa.ylim(1);
    fig_axis(sa);


    % fig_figure
    fig_figure(gcf());
    
    % font
    fig_fontsize([],18);
    
    %% smaller figure
    % paper size
    set(gcf(),'PaperPositionMode','auto');
    psi = get(gcf(),'PaperSize');
    psi(2) = 0.6*psi(2);
    set(gcf(),'PaperSize',psi);
    
    %% export
    mkdirp('docs/figures');
    fig_export('docs/figures/figure_RT2bis.pdf');
    
end