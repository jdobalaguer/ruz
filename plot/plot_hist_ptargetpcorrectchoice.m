%#ok<*NODEF>

function plot_hist_ptargetpcorrectchoice(u_model)
    
    %% load
    load('data/sdata');
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_subject   = numbers.shared.u_subject;
    if ~exist('u_model','var'); u_model = fieldnames(models); end
    u_choice    = [0,1];
    u_pcorrect  = [0,1];
    u_ptarget   = [0,1];
    
    nb_novel    = numbers.shared.nb_novel;
    nb_subject  = numbers.shared.nb_subject;
    nb_model    = length(u_model);
    nb_choice   = 2;
    nb_pcorrect = 2;
    nb_ptarget  = 2;
    
    %% set data
    % previous target
    sdata.vb_ptarget = [nan; sdata.vb_target(1:end-1)];
    sdata.vb_ptarget(sdata.exp_start) = nan;
    % previous correct
    for i_model = 1:nb_model
        models.(u_model{i_model}).pcorrect = [nan; models.(u_model{i_model}).correct(1:end-1)];
        models.(u_model{i_model}).pcorrect(sdata.exp_start) = nan;
    end
    
    
    
    for i_novel = 1:nb_novel
        %% plot
        % figure
        fig_figure();

        % colour
        colour = fig_color('forever')./255;

        % title
        titles = {'NOT','CHOICE'};

        % loop (model,choice)
        j_subplot = 0;
        for i_model = 1:nb_model
            model = models.(u_model{i_model});
            for i_choice = 1:nb_choice

                % subplot
                j_subplot = j_subplot + 1;
                subplot(nb_model,nb_choice,j_subplot);
                hold('on');

                % loop (subject, trial)
                histogram = nan(nb_subject,nb_pcorrect,nb_ptarget);
                for i_ptarget = 1:nb_ptarget
                    for i_pcorrect = 1:nb_pcorrect
                        for i_subject = 1:nb_subject
                            % index
                            ii_resp    = (models.human.rt>0);
                            ii_trial   = (sdata.exp_trial   == 2);
                            ii_novel   = (sdata.vb_novel    == u_novel(i_novel));
                            ii_choice  = (model.choice      == u_choice(i_choice));
                            ii_subject = (sdata.exp_subject == u_subject(i_subject));
                            ii_pcorrect= (model.pcorrect    == u_pcorrect(i_pcorrect));
                            ii_ptarget = (sdata.vb_ptarget  == u_ptarget(i_ptarget));
                            % value
                            histogram(i_subject,i_pcorrect,i_ptarget) = nanmean(nansum(ii_resp & ii_trial & ii_novel & ii_choice & ii_subject & ii_pcorrect & ii_ptarget));
                        end
                    end
                end

                % plot
                y = squeeze(nanmean(histogram));
                e = squeeze(tools_ste(histogram));
                if(~any(e)); e(:) = 0.001; end
                web = fig_barweb(   y,...                                                  height
                                    e,...                                                  error
                                    [],...                                                 width
                                    {'prev wrong','prev correct'},...                      group names
                                    titles{i_choice},...                                   title
                                    [],...                                                 xlabel
                                    'performance (% correct)',...                          ylabel
                                    colour(i_model,:),...                                  colour
                                    'y',...                                                grid
                                    {'prev not','prev target'},...                         legend
                                    [],...                                                 error sides (1, 2)
                                    'axis'...                                              legend ('plot','axis')
                                    );
                % axis
                sa.ylabel  = 'histogram';
                sa.ytick   = 0:5:10;
                sa.ylim    = [0,10];
                fig_axis(sa);
            end
        end
    end
end
