%
% find probabilities
% to see if we learn more from confirmatory or disconfirmatory evidence
%

numbers.max_count = 3;
using_average = 0;

%% use flags
if ~exist('using_model','var')
    using_model = 'sdata.Mfit_ch';
    using_model = 'sdata.Mhuman_ch';
    error('no using_model');
end

%% START ==================================================================
fprintf('\n#### run_janprobsinteraction ####\n');

%% LOAD ===================================================================
fprintf('\nload data');
if ~exist('sdata','var')
    error('run_janprobs: not sdata!');
else
    fprintf(['\n    skipping']);
end

%% FIND TARGETS ===========================================================

fprintf('\nfind targets');
%if ~isfield(sdata,'find_targets')

    nb_ttrials = length(sdata.sub);
    u_subject = unique(sdata.sub);
    nb_subjects = length(u_subject);
    nb_blocks = 48;
    nb_trials = 16;
    nb_sides = 4;
    nb_features = 3;

    % translate features appearing in each trial
    ii_features = zeros(nb_sides,nb_features,nb_ttrials);
    for i_side = 1:nb_sides
        for i_feature = 1:nb_features
            ii_features(i_side,i_feature,:) = (sdata.codez(i_side,:)==i_feature);
        end
    end

    % find trials in block which match with that feature
    % then store nb_target, nb_nontarget, targetchoice
    nb_target = nan(nb_sides,nb_ttrials);
    nb_nontgt = nan(nb_sides,nb_ttrials);
    fprintf(['\n    subject..']);
    for i_subject = 1:nb_subjects
        fprintf([num2str(u_subject(i_subject)),', ']);
        for i_block = 1:nb_blocks
            for i_trial = 1:nb_trials
                ii_block = (sdata.sub==u_subject(i_subject) & sdata.block==i_block & sdata.trial<i_trial);
                ii_trial = (sdata.sub==u_subject(i_subject) & sdata.block==i_block & sdata.trial==i_trial);
                for i_side = 1:nb_sides
                    i_feature = sdata.codez(i_side,ii_trial);
                    ii_match = (reshape(ii_block,[1,nb_ttrials]) & reshape(ii_features(i_side,i_feature,:),[1,nb_ttrials]));
                    nb_target(i_side,ii_trial) = sum( sdata.newtarget(ii_match));
                    nb_nontgt(i_side,ii_trial) = sum(~sdata.newtarget(ii_match));
                end
            end
        end
    end
%else
%    fprintf(['\n    skipping']);
%end
%sdata.find_targets = 1;

%% CHANGE MODEL ===========================================================
%if ~isfield(sdata,'using_model') || ~strcmp(sdata.using_model,using_model)
    tgtchoice = eval(using_model);
    sdata.using_model = using_model;
    if isfield(sdata,'probabilities'); sdata = rmfield(sdata,'probabilities'); end
%end

%% REORDER ================================================================
% reorder nb_target and nb_nontgt by relevant / irrelevant

fprintf('\nreorder');
%if ~isfield(sdata,'reorder')
    
    % relevant rows for this block in sdata.codez
    codekey =  [1 2;...    % CL CR
                3 4;...    % FL FR
                1 4;...    % CL FR
                2 3];      % FL CR

    % for each subject
    u_subject = unique(sdata.sub);
    nb_subjects = length(u_subject);
    nb_blocks = 48;
    
    fprintf(['\n    subject..']);
    for i_subject = 1:nb_subjects
        fprintf([num2str(u_subject(i_subject)),', ']);
        for i_block = 1:nb_blocks
            % indexes for this s/b
            ii_trial = (sdata.sub==u_subject(i_subject) & sdata.block==i_block);

            % kind of block
                %  1 == CC
                %  2 == FF
                %  3 == CF
                %  4 == FC
            blockcode = sdata.blockcode(ii_trial);
            blockcode = blockcode(1);

            % attention side. for cuenovelty=0, the first 2 rows should be dictated by codekey
            attside = nan(1,4);
            ncc = setdiff(1:4,codekey(blockcode,:)); % false codekeys
            attside(1)=codekey(blockcode,1);  % good feature in L
            attside(2)=codekey(blockcode,2);  % good feature in R
            attside(3)=ncc(1);                % bad  feature in L
            attside(4)=ncc(2);                % bad  feature in R

            % reorder
            nb_target(:,ii_trial) = nb_target(attside,ii_trial);
            nb_nontgt(:,ii_trial) = nb_nontgt(attside,ii_trial);
        end
    end
%else
%    fprintf(['\n    skipping']);
%end
%sdata.reorder = 1;

%% PROBABILITIES ==========================================================
% compute logistic regressions

fprintf('\nprobabilities');
%if ~isfield(sdata,'probabilities')
    
    nb_ttrials  = length(sdata.sub);
    u_subject   = unique(sdata.sub);
    nb_subjects = length(u_subject);
    nb_blocks   = 48;
    nb_trials   = 16;
    
    u_novelty   = 0:1;
    nb_novelties = length(u_novelty);
    
    u_tnt    = 0:1;
    nb_tnts  = 2;

    u_count     = 0:numbers.max_count;
    nb_counts   = length(u_count);
    
    if using_average
        u_side = [1,1,2,2];
    else
        u_side = 1:4;
    end
    nb_sides = length(unique(u_side));
    
    count = zeros(nb_subjects,nb_novelties,nb_sides,nb_tnts,nb_counts);
    total = zeros(nb_subjects,nb_novelties,nb_sides,nb_tnts,nb_counts);

    fprintf(['\n    subject..']);
    for i_subject = 1:nb_subjects
        fprintf([num2str(u_subject(i_subject)),', ']);
        
        for i_novelty = 1:nb_novelties
            % indexes
            ii_subject = (sdata.sub==u_subject(i_subject));
            ii_novelty = (sdata.cuenovelty==u_novelty(i_novelty));
            ii_index = (ii_subject & ii_novelty);
            
            % values
            nbt = nb_target(:,ii_index);
            nbn = nb_nontgt(:,ii_index);
            tch = tgtchoice(ii_index);
            
            for i_side = 1:4
                for i_tnt = 1:nb_tnts
                    % set x value
                    switch i_tnt
                        case 1
                            nb_things = nbt(i_side,:);
                        case 2
                            nb_things = nbn(i_side,:);
                    end
                    
                    % set probabilities
                    for i_count = 1:nb_counts
                        count(i_subject,i_novelty,u_side(i_side),i_tnt,i_count) = count(i_subject,i_novelty,u_side(i_side),i_tnt,i_count) ...
                                                                                    + sum(tch & nb_things==u_count(i_count));
                        total(i_subject,i_novelty,u_side(i_side),i_tnt,i_count) = total(i_subject,i_novelty,u_side(i_side),i_tnt,i_count) ...
                                                                                    + sum(      nb_things==u_count(i_count));
                    end
                    count(i_subject,i_novelty,u_side(i_side),i_tnt,nb_counts) = count(i_subject,i_novelty,u_side(i_side),i_tnt,nb_counts) ...
                                                                                + nansum(tch & nb_things>u_count(nb_counts));
                    total(i_subject,i_novelty,u_side(i_side),i_tnt,nb_counts) = total(i_subject,i_novelty,u_side(i_side),i_tnt,nb_counts) ...
                                                                                + nansum(      nb_things>u_count(nb_counts));
                end
            end
        end
    end
    probs = count ./ total;
    probs(~total(:)) = nan;
%else
%    fprintf(['\n    skipping']);
%end
%sdata.probabilities = 1;

%% PLOT ===================================================================

    nb_ttrials  = length(sdata.sub);
    u_subject   = unique(sdata.sub);
    nb_subjects = length(u_subject);
    nb_blocks   = 48;
    nb_trials   = 16;
    
    u_novelty   = 0:1;
    nb_novelties = length(u_novelty);
    
    u_tnt    = 0:1;
    nb_tnts  = 2;

    u_count     = 0:numbers.max_count;
    nb_counts   = length(u_count);
    
    if using_average
        u_side = [1,2];
    else
        u_side = 1:4;
    end
    nb_sides = length(unique(u_side));

    x_novelty = {'familiar','novel'};
    if using_average
        x_sides = {'relevant','irrelevant'};
    else
        x_sides = {'relevant 1','relevant 2','irrelevant 1','irrelevant 2'};
    end
    
    x_tnt = {'nontgt','target'};

    i_plot = 0;
    
    
    for i_novelty = 1:nb_novelties
        for i_side = 1:nb_sides
            
            % i_plot
            i_plot = i_plot+1;
            subplot(nb_novelties,nb_sides,i_plot);
            hold on;
            
            % values(i_subject,i_tnt,i_count)
            values = squeeze(probs(:,i_novelty,i_side,:,:));
            
            % plot
            switch i_novelty
                case 1
                    c = [1,0,0];
                case 2
                    c = [0,1,0];
            end
            c = {c,c};
            s = {'-','--'};
            m = {'s','o'};
            
            if strcmp(using_model,'sdata.Mhuman_ch')
                %sdata.plots.fig2e_human(i_novelty,i_side,:,:,:) = values;
                tools_dotplot(values,{'familiar','novel'},m,c);
                set(gca,'FontSize',16);
                xlim([0.5 u_count(end)+.5]);
                set(gca,'xtick',1:nb_counts);
                set(gca,'xticklabel',u_count);
            elseif strcmp(using_model,'sdata.Mfit_ch')
                %sdata.plots.fig2e_model(i_novelty,i_side,:,:,:) = values;
                for i_tnt = 1:nb_tnts
                    plot(squeeze(mean(values(:,i_tnt,:),1)),'color',c{i_tnt},'linestyle',s{i_tnt},'LineWidth',2);
                end
                xlim([0.5 u_count(end)+.5]);
                set(gca,'xtick',1:nb_counts);
                set(gca,'xticklabel',u_count);
            elseif strcmp(using_model,'sdata.Mopt_ch')
                %sdata.plots.fig2e_optim(i_novelty,i_side,:,:,:) = values;
                for i_tnt = 1:nb_tnts
                    plot(squeeze(mean(values(:,i_tnt,:),1)),'color','k','linestyle',s{i_tnt},'LineWidth',2);
                end
                xlim([0.5 u_count(end)+.5]);
                set(gca,'xtick',1:nb_counts);
                set(gca,'xticklabel',u_count);
            else
                error(['run_janprobs: error. using_model is ''',using_model,''' unknown.']);
            end
            set(gca,'ytick',0:.25:1);
            ylim([0,1]);
            xlabel = ['(',x_novelty{i_novelty},', ',x_sides{i_side},')'];
            set(get(gca,'xlabel'),'string',xlabel,'fontsize',16,'fontname','Arial');
            set(gca,'fontsize',16,'fontname','Arial');
        end
    end


%% END ====================================================================
fprintf('\n\n#### /run_janprobs ####\n\n');
