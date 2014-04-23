%%
% FIGURE_2D
%
% proportion choose target responses as a function of the number of
% previous times the rule-relevant feature (top panels) and rule-
% irrelevant feature (bottom panels) was associated with
% confirmatory (filled circles) or disconfirmatory (open circles)
% feedback. Data are shown separately for familiar (left panels) and
% novel (right panels) cues conditions
%

%% warnings
%#ok<*NODEF>

%% figure 2D
function v = figure_2D()
    fig = ~nargout;
    fontname = 'Sans Serif';                                % defaults
    model = model_valid();
    if fig,
        fig_figure();                                       % figure
        set(0, 'DefaultAxesFontName', fontname);            % font
    end
    v{1} = run_janprobs(model, fig);                        % plot model
    v{2} = run_janprobs('human', fig);                      % plot humans
    if fig,
        fig_figure(gcf());                                  % figure
        fig_fontsize([],18);                                % font
        mkdirp('docs/figures');                             % export
        fig_export('docs/figures/figure_2D.pdf');
        v = [];
    end
end

%% run janprobs
function allvalues = run_janprobs(model,fig)
    %% default
    max_count       = 4;
    using_average   = true;
    
    %% load
    sdata = struct(); numbers = struct(); models = struct();
    load('data/sdata.mat');
    choice = eval(['models.',model,'.choice']);
    
    %% numbers
    if using_average, u_side = [1,1,2,2]; else u_side = 1:4; end
    u_dimension  = numbers.shared.u_dimension;
    u_target     = numbers.shared.u_target;
    u_novel      = numbers.shared.u_novel;
    u_trial      = numbers.shared.u_trial;
    u_block      = numbers.shared.u_block;
    u_subject    = numbers.shared.u_subject;
    u_count      = 1:max_count;
    
    nb_side      = length(unique(u_side));
    nb_dimension = numbers.shared.nb_dimension;
    nb_feature   = numbers.shared.nb_value;
    nb_target    = numbers.shared.nb_target;
    nb_novel     = numbers.shared.nb_novel;
    nb_trial     = numbers.shared.nb_trial;
    nb_block     = numbers.shared.nb_block;
    nb_subject   = numbers.shared.nb_subject;
    nb_total     = nb_subject * nb_block * nb_trial;
    nb_count     = length(u_count);
    
    %% find targets
    % translate features appearing in each trial
    ii_features = nan(nb_dimension,nb_feature,nb_total);
    for i_dimension = 1:nb_dimension
        for i_feature = 1:nb_feature
            ii_features(i_dimension,i_feature,:) = (sdata.vb_stimord(:,i_dimension)==i_feature);
        end
    end

    % find trials in block which match with that feature then store nb_target, nb_nontarget, targetchoice
    nb_yestgt = nan(4,nb_total);
    nb_nontgt = nan(4,nb_total);
    tools_parforprogress(nb_subject);
    for i_subject = 1:nb_subject
        tools_parforprogress();
        for i_block = 1:nb_block
            for i_trial = 1:nb_trial
                ii_block = (sdata.exp_subject==u_subject(i_subject) & sdata.exp_block==u_block(i_block) & sdata.exp_trial <u_trial(i_trial));
                ii_trial = (sdata.exp_subject==u_subject(i_subject) & sdata.exp_block==u_block(i_block) & sdata.exp_trial==u_trial(i_trial));
                for i_dimension = 1:nb_dimension
                    i_feature = sdata.vb_stimord(ii_trial,i_dimension);
                    ii_match = (reshape(ii_block,[1,nb_total]) & reshape(ii_features(i_dimension,i_feature,:),[1,nb_total]));
                    nb_yestgt(i_dimension,ii_trial) = sum( sdata.vb_target(ii_match));
                    nb_nontgt(i_dimension,ii_trial) = sum(~sdata.vb_target(ii_match));
                end
            end
        end
    end
    tools_parforprogress(0);
    

    %% probabilities
    count = zeros(nb_subject,nb_novel,nb_side,nb_target,nb_count);
    total = zeros(nb_subject,nb_novel,nb_side,nb_target,nb_count);

    tools_parforprogress(nb_subject);
    for i_subject = 1:nb_subject
        tools_parforprogress();
        for i_novel = 1:nb_novel
            
            % indexes
            ii_subject = (sdata.exp_subject == u_subject(i_subject));
            ii_novelty = (sdata.vb_novel    == u_novel(i_novel));
            ii_index   = (ii_subject & ii_novelty);
            
            % values
            nbt = nb_yestgt(:,ii_index);
            nbn = nb_nontgt(:,ii_index);
            cht = choice(ii_index);
            chn = choice(ii_index);

            for i_dimension = 1:nb_dimension
                for i_target = 1:nb_target
                    
                    % set x value
                    switch i_target
                        case 1
                            nb_things = nbt(i_dimension,:);
                            ch_things = cht';

                        case 2
                            nb_things = nbn(i_dimension,:);
                            ch_things = chn';
                    end
                    
                    % set probabilities
                    for i_count = 1:nb_count
                        count(i_subject,i_novel,u_side(i_dimension),i_target,i_count) = count(i_subject,i_novel,u_side(i_dimension),i_target,i_count) + nansum(ch_things & nb_things==u_count(i_count));
                        total(i_subject,i_novel,u_side(i_dimension),i_target,i_count) = total(i_subject,i_novel,u_side(i_dimension),i_target,i_count) + nansum(            nb_things==u_count(i_count));
                    end
                    count(i_subject,i_novel,u_side(i_dimension),i_target,nb_count) = count(i_subject,i_novel,u_side(i_dimension),i_target,nb_count) + nansum(ch_things & nb_things>u_count(nb_count));
                    total(i_subject,i_novel,u_side(i_dimension),i_target,nb_count) = total(i_subject,i_novel,u_side(i_dimension),i_target,nb_count) + nansum(            nb_things>u_count(nb_count));
                end
            end
        end
    end
    tools_parforprogress(0);
    probs = count ./ total;
    probs(~total(:)) = nan;

    %% plot
    x_sides = {'relevant','irrelevant'};
    if ~using_average, x_sides = repmat(x_sides,1,2); end

    % details
    colour = {{[1,0,0],[1,1,1]} , {[0,1,0],[1,1,1]}};
    style  = {'-','--'};
    
    % plot
    j_subplot = 0;
    allvalues = nan(nb_side,nb_novel,nb_subject,nb_target,nb_count);
    for i_side = 1:nb_side
        for i_novel = 1:nb_novel

            values = nan(nb_subject,nb_target,nb_count);
            for i_target = 1:nb_target
                values(:,i_target,:) = squeeze(probs(:,i_novel,i_side,i_target,:));
            end
            allvalues(i_side,i_novel,:,:,:) = values;
            
            if fig
                % subplot
                j_subplot = j_subplot+1;
                subplot(nb_novel,nb_side,j_subplot);
                hold('on');

                % plot human
                if strcmp(model,'human')
                    for i_target = 1:nb_target
                        for i_count = 1:nb_count
                            m = squeeze(nanmean(values(:,i_target,i_count)));
                            e = squeeze( nanste(values(:,i_target,i_count)));
                            c = colour{i_novel}{i_target};
                            plot(i_count,m,                  'color','k','linestyle','none','marker','o','markersize',10,'linewidth',1.0,'markerfacecolor',c);
                            plot([i_count,i_count],m+[-e,+e],'color','k','linestyle','-',   'marker','none',             'linewidth',1.0);
                        end
                    end


                % plot hbm
                elseif strcmp(model,'hbm')
                    for i_target = 1:nb_target
                        s = style{i_target};
                        plot(squeeze(mean(values(:,i_target,:),1)),'color','k','linestyle',s,'LineWidth',2);
                    end

                % plot other
                else
                    for i_target = 1:nb_target
                        c = colour{i_novel}{1};
                        s = style{i_target};
                        plot(squeeze(mean(values(:,i_target,:),1)),'color',c,'linestyle',s,'LineWidth',2);
                    end
                end

                % fig_axis
                sa.xlim         = [0.5 , nb_count+0.5];
                sa.xtick        = 1:nb_count;
                sa.xticklabel   = num2leg(u_count);
                sa.ytick        = 0:.5:1;
                sa.ylim         = [0,1];
                sa.xlabel       = x_sides{i_side};
                fig_axis(sa);
            end
        end
    end
end