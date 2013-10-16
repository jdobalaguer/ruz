%
% run fitting of the model
%


%% START ==================================================================
fprintf('\n#### run_fitting ####\n');

%% LOAD ===================================================================
fprintf('\nload data');
if ~exist('sdata','var')
    load_allran;
else
    fprintf(['\n    skipping']);
end

% clean
clearvars -except sdata numbers;

%% numbers
if ~exist('numbers','var')
    numbers = struct();
    numbers.u_subject = unique(sdata.sub);
    numbers.u_block = unique(sdata.block);
    numbers.u_trial = unique(sdata.trial);
    numbers.u_novelty = 0:1;

    numbers.u_propabs   = .6;
    numbers.u_propang   = 0:0.005:1;
    numbers.u_thresh    = 0:0.005:1;
    
    numbers.nb_subjects = length(numbers.u_subject);
    numbers.nb_blocks = length(numbers.u_block);
    numbers.nb_trials = length(numbers.u_trial);
    numbers.nb_novelties = length(numbers.u_novelty);
    numbers.nb_propabss = length(numbers.u_propabs);
    numbers.nb_propangs = length(numbers.u_propang);
    numbers.nb_threshs  = length(numbers.u_thresh);
end

%% calculate values
clearvars -except sdata numbers;
fprintf('\ncalculate values');
if ~isfield(sdata,'flag_calcvals') || ~sdata.flag_calcvals
    % xx_subject
    xx_subject = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    for i_subject = 1:numbers.nb_subjects
        xx_subject(i_subject,:,:,:,:) = numbers.u_subject(i_subject);
    end
    % xx_novelty
    xx_novelty = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    for i_novelty = 1:numbers.nb_novelties
        xx_novelty(:,i_novelty,:,:,:) = numbers.u_novelty(i_novelty);
    end
    % xx_propabs
    xx_propabs = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    for i_propabs = 1:numbers.nb_propabss
        xx_propabs(:,:,i_propabs,:,:) = numbers.u_propabs(i_propabs);
    end
    % xx_propang
    xx_propang = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    for i_propang = 1:numbers.nb_propangs
        xx_propang(:,:,:,i_propang,:) = numbers.u_propang(i_propang);
    end
    % xx_thresh
    xx_thresh  = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    for i_thresh = 1:numbers.nb_threshs
        xx_thresh(:,:,:,:,i_thresh)  = numbers.u_thresh(i_thresh);
    end

    % store
    numbers.xx_subject = xx_subject;
    numbers.xx_novelty = xx_novelty;
    numbers.xx_propabs = xx_propabs;
    numbers.xx_propang = xx_propang;
    numbers.xx_thresh  = xx_thresh;
else
    fprintf('\n  skipping');
end
sdata.flag_calcvals = 1;

%% run models
clearvars -except sdata numbers;
fprintf('\nrun models\n');
if ~isfield(sdata,'flag_runmodels') || ~sdata.flag_runmodels
    % relevant rows for this block in sdata.codez
    codekey = [1,2;3,4;1,4;2,3];

    % store results
    subcr   = cell(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    subch   = cell(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    modcr   = cell(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    modch   = cell(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    
    % parallel set-up
    if exist('matlabpool','builtin'); use_parallel = 1; else use_parallel = 0; end
    if use_parallel && ~matlabpool('size')
        pctconfig('portrange', [31000,32000]);
        matlabpool('janmanager');
    end
    
    t = tic;
    nb_cases = numbers.nb_subjects*numbers.nb_novelties*numbers.nb_propabss*numbers.nb_propangs*numbers.nb_threshs;
    tools_parforprogress(nb_cases);
    parfor i_case = 1:nb_cases
        % case indexes
        i_subject = find(numbers.u_subject == numbers.xx_subject(i_case));
        i_novelty = find(numbers.u_novelty == numbers.xx_novelty(i_case));
        i_propabs = find(numbers.u_propabs == numbers.xx_propabs(i_case));
        i_propang = find(numbers.u_propang == numbers.xx_propang(i_case));
        i_thresh  = find(numbers.u_thresh  == numbers.xx_thresh(i_case));
        
        this_ublock = unique(sdata.block(sdata.sub==numbers.u_subject(i_subject) & sdata.cuenovelty==numbers.u_novelty(i_novelty)));
        this_nbblocks = length(this_ublock);

        % for each block
        this_modcr = nan(this_nbblocks,numbers.nb_trials);
        this_modch = nan(this_nbblocks,numbers.nb_trials);

        for this_iblock = 1:this_nbblocks
            % indexes for this s/b
            indx = find(sdata.sub==numbers.u_subject(i_subject) & sdata.block==this_ublock(this_iblock));
            % kind of block
            blockcode = sdata.blockcode(indx(1));
            % cue novelty
            cuenovelty = sdata.cuenovelty(indx(1));
            % stimulus
            codez = sdata.codez(:,indx);
            % is target
            target = sdata.newtarget(indx);
            % answers
            targetchoice = sdata.targetchoice(indx);
            % performance
            cor = sdata.cor(indx);
            % capacity
            k = 2*(cuenovelty+1);
            % attention side. for cuenovelty=0, the first 2 rows should be dictated by codekey
            attside=zeros(4,length(indx));
            ncc = setdiff(1:4,codekey(blockcode,:)); % false codekeys
            attside(1,:)=ones(1,length(indx))*codekey(blockcode,1);  % good feature in L
            attside(2,:)=ones(1,length(indx))*codekey(blockcode,2);  % good feature in R
            attside(3,:)=ones(1,length(indx))*ncc(1);                % bad  feature in L
            attside(4,:)=ones(1,length(indx))*ncc(2);                % bad  feature in R
            % model
            mdata = model(codez,attside,target,k,numbers.u_propabs(i_propabs),numbers.u_propang(i_propang),numbers.u_thresh(i_thresh));
            % store it
            this_modcr(this_iblock,:) = double(mdata.modelcor);
            this_modch(this_iblock,:) = double(mdata.modelchoice);
        end

        % store model average across blocks
        modcr{i_case} = reshape(mean(this_modcr),[1,numbers.nb_trials]);
        modch{i_case} = reshape(mean(this_modch),[1,numbers.nb_trials]);

        % store human average across blocks
        subcr{i_case} = nan(1,numbers.nb_trials);
        subch{i_case} = nan(1,numbers.nb_trials);
        for i_trial = 1:numbers.nb_trials
            indx = find(sdata.sub==numbers.u_subject(i_subject) & sdata.trial==i_trial & sdata.cuenovelty==numbers.u_novelty(i_novelty));
            subcr{i_case}(i_trial) = mean(sdata.cor(indx));
            subch{i_case}(i_trial) = mean(sdata.targetchoice(indx));
        end
        tools_parforprogress();
    end
    tools_parforprogress(0);

    % save results
    sdata.subcr = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs,numbers.nb_trials);
    sdata.subch = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs,numbers.nb_trials);
    sdata.modcr = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs,numbers.nb_trials);
    sdata.modch = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs,numbers.nb_trials);
    for i_case = 1:nb_cases
        % case indexes
        i_subject = find(numbers.u_subject == numbers.xx_subject(i_case));
        i_novelty = find(numbers.u_novelty == numbers.xx_novelty(i_case));
        i_propabs = find(numbers.u_propabs == numbers.xx_propabs(i_case));
        i_propang = find(numbers.u_propang == numbers.xx_propang(i_case));
        i_thresh  = find(numbers.u_thresh  == numbers.xx_thresh(i_case));
        
        sdata.subcr(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:) = subcr{i_subject,i_novelty,i_propabs,i_propang,i_thresh};
        sdata.subch(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:) = subch{i_subject,i_novelty,i_propabs,i_propang,i_thresh};
        sdata.modcr(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:) = modcr{i_subject,i_novelty,i_propabs,i_propang,i_thresh};
        sdata.modch(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:) = modch{i_subject,i_novelty,i_propabs,i_propang,i_thresh};
    end
    
    toc(t)
else
    fprintf('  skipping');
end
sdata.flag_runmodels = 1;

%% select criteria
criteria = 'ch';
switch criteria
    case 'cor'
        sdata.subdata     = sdata.subcr;
        sdata.moddata     = sdata.modcr;
        sdata.subother    = sdata.subch;
        sdata.modother    = sdata.modch;
    case 'ch'
        sdata.subdata     = sdata.subch;
        sdata.moddata     = sdata.modch;
        sdata.subother    = sdata.subcr;
        sdata.modother    = sdata.modcr;
end

%% calculate error
clearvars -except sdata numbers;
fprintf(['\ncalculate error']);
if ~isfield(sdata,'flag_minfits') || ~sdata.flag_minfits
    % error for each parameter combination
    minfits = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    fprintf(['\n  subject..']);
    for i_subject = 1:numbers.nb_subjects
        fprintf([num2str(numbers.u_subject(i_subject)),', ']);
        for i_novelty = 1:numbers.nb_novelties
            for i_propabs = 1:numbers.nb_propabss
                for i_propang = 1:numbers.nb_propangs
                    for i_thresh = 1:numbers.nb_threshs
                        dc1 =   reshape(sdata.moddata(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:),[1,numbers.nb_trials]) ...
                             - reshape(sdata.subdata(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:),[1,numbers.nb_trials]);
                        dc2 =   reshape(sdata.modother(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:),[1,numbers.nb_trials]) ...
                             - reshape(sdata.subother(i_subject,i_novelty,i_propabs,i_propang,i_thresh,:),[1,numbers.nb_trials]);
                        minfits(i_subject,i_novelty,i_propabs,i_propang,i_thresh) = sqrt(sum(dc1.*dc1)) + sqrt(sum(dc2.*dc2));
                    end
                end
            end
        end
    end
    sdata.minfits = minfits;

    % find minimum
    clearvars -except sdata numbers;
    fprintf('\nfind minima');
    minminfits = nan(numbers.nb_subjects,numbers.nb_novelties);
    minpropabs = nan(numbers.nb_subjects,numbers.nb_novelties);
    minpropang = nan(numbers.nb_subjects,numbers.nb_novelties);
    minthresh  = nan(numbers.nb_subjects,numbers.nb_novelties);
    fprintf(['\n  subject..']);
    for i_subject = 1:numbers.nb_subjects
        fprintf([num2str(numbers.u_subject(i_subject)),', ']);
        for i_novelty = 1:numbers.nb_novelties
            this_minfits = sdata.minfits(i_subject,i_novelty,:,:,:);
            this_propabs = numbers.xx_propabs(i_subject,i_novelty,:,:,:);
            this_propang = numbers.xx_propang(i_subject,i_novelty,:,:,:);
            this_thresh  = numbers.xx_thresh(i_subject,i_novelty,:,:,:);
            [~,i_min] = min(this_minfits(:));
            minminfits(i_subject,i_novelty) = this_minfits(i_min);
            minpropabs(i_subject,i_novelty) = this_propabs(i_min);
            minpropang(i_subject,i_novelty) = this_propang(i_min);
            minthresh(i_subject,i_novelty)  = this_thresh(i_min);
        end
    end
    sdata.minminfits = minminfits;
    sdata.minpropabs = minpropabs;
    sdata.minpropang = minpropang;
    sdata.minthresh  = minthresh;
end
sdata.flag_minfits = 1;


%% run fit
clearvars -except sdata numbers;
fprintf('\nrun fit');

% relevant rows for this block in sdata.codez
codekey = [1,2;3,4;1,4;2,3];

% for each subject
sdata.Mfit_ch       = nan(0,1);
sdata.Mfit_cor      = nan(0,1);
sdata.Mfit_Ho       = nan(0,4,3);
sdata.Mfit_aVc      = nan(0,4);
sdata.Mfit_maxaVcAS = nan(0,4);
sdata.Mfit_minaVcAS = nan(0,4);
sdata.Mfit_mmaVcAS = nan(0,4);
fprintf(['\n  subject..']);
for i_subject = 1:numbers.nb_subjects
    fprintf([num2str(numbers.u_subject(i_subject)),', ']);
    % for each block
    for i_block = 1:numbers.nb_blocks
        % indexes for this s/b
        indx = find(sdata.sub==numbers.u_subject(i_subject) & sdata.block==i_block);
        % kind of block
        blockcode = sdata.blockcode(indx(1));
        % cue novelty
        cuenovelty = sdata.cuenovelty(indx(1));
        % stimulus
        codez = sdata.codez(:,indx);
        % is target
        target = sdata.newtarget(indx);
        % answers
        targetchoice = sdata.targetchoice(indx);
        % performance
        cor = sdata.cor(indx);
        % capacity
        k = 2*(cuenovelty+1);
        % attention side. for cuenovelty=0, the first 2 rows should be dictated by codekey
        attside=zeros(4,length(indx));
        ncc = setdiff(1:4,codekey(blockcode,:)); % false codekeys
        attside(1,:)=ones(1,length(indx))*codekey(blockcode,1);  % good feature in L
        attside(2,:)=ones(1,length(indx))*codekey(blockcode,2);  % good feature in R
        attside(3,:)=ones(1,length(indx))*ncc(1);                % bad  feature in L
        attside(4,:)=ones(1,length(indx))*ncc(2);                % bad  feature in R
        % run and log models
        mdata = model(codez,attside,target,k,...
                                        sdata.minpropabs(i_subject,cuenovelty+1),...
                                        sdata.minpropang(i_subject,cuenovelty+1),...
                                        sdata.minthresh(i_subject,cuenovelty+1));
        sdata.Mfit_ch(indx)         = double(mdata.modelchoice);
        sdata.Mfit_cor(indx)        = double(mdata.modelcor);
        sdata.Mfit_aVc(indx,:)      = double(mdata.aVc);
        sdata.Mfit_aVcAS(indx,:)    = double(mdata.aVcAS);
        sdata.Mfit_Ho(indx,:,:)     = double(mdata.Ho);
        sdata.Mfit_maxaVcAS(indx)   = double(mdata.maxaVcAS);
        sdata.Mfit_minaVcAS(indx)   = double(mdata.minaVcAS);
        sdata.Mfit_mmaVcAS(indx)    = double(mdata.mmaVcAS);
    end
end

%% run optimal
clearvars -except sdata numbers;
fprintf('\nrun optimal');

% relevant rows for this block in sdata.codez
codekey = [1,2;3,4;1,4;2,3];

% for each subject
sdata.Mopt_ch       = nan(0,1);
sdata.Mopt_cor      = nan(0,1);
sdata.Mopt_Ho       = nan(0,4,3);
sdata.Mopt_aVc      = nan(0,4);
sdata.Mopt_maxaVcAS = nan(0,4);
sdata.Mopt_minaVcAS = nan(0,4);
sdata.Mopt_mmaVcAS = nan(0,4);
fprintf(['\n  subject..']);
for i_subject = 1:numbers.nb_subjects
    fprintf([num2str(numbers.u_subject(i_subject)),', ']);
    % for each block
    for i_block = 1:numbers.nb_blocks
        % indexes for this s/b
        indx = find(sdata.sub==numbers.u_subject(i_subject) & sdata.block==i_block);
        % kind of block
        blockcode = sdata.blockcode(indx(1));
        % cue novelty
        cuenovelty = sdata.cuenovelty(indx(1));
        % stimulus
        codez = sdata.codez(:,indx);
        % is target
        target = sdata.newtarget(indx);
        % answers
        targetchoice = sdata.targetchoice(indx);
        % performance
        cor = sdata.cor(indx);
        % capacity
        k = 2*(cuenovelty+1);
        % attention side. for cuenovelty=0, the first 2 rows should be dictated by codekey
        attside=zeros(4,length(indx));
        ncc = setdiff(1:4,codekey(blockcode,:)); % false codekeys
        attside(1,:)=ones(1,length(indx))*codekey(blockcode,1);  % good feature in L
        attside(2,:)=ones(1,length(indx))*codekey(blockcode,2);  % good feature in R
        attside(3,:)=ones(1,length(indx))*ncc(1);                % bad  feature in L
        attside(4,:)=ones(1,length(indx))*ncc(2);                % bad  feature in R
        % run and log models
        odata = model(codez,attside,target,k,...
                                        sdata.minpropabs(i_subject,cuenovelty+1),...
                                        max(numbers.u_propang),...
                                        min(numbers.u_thresh));
        sdata.Mopt_ch(indx)         = double(odata.modelchoice);
        sdata.Mopt_cor(indx)        = double(odata.modelcor);
        sdata.Mopt_aVc(indx,:)      = double(odata.aVc);
        sdata.Mopt_aVcAS(indx,:)    = double(odata.aVcAS);
        sdata.Mopt_Ho(indx,:,:)     = double(odata.Ho);
        sdata.Mopt_maxaVcAS(indx)   = double(odata.maxaVcAS);
        sdata.Mopt_minaVcAS(indx)   = double(odata.minaVcAS);
        sdata.Mopt_mmaVcAS(indx)    = double(odata.mmaVcAS);
    end
end

%% optimal model

%% end
clearvars -except sdata numbers;
fprintf('\n\n#### /run_fitting ####\n\n');

return;

% ======================================================================= %
% ======================================================================= %

%% t-test parameters

    fprintf('\n\nt-test novel/familiar\n');
    [h,p] = ttest2(sdata.minpropabs(:,1),sdata.minpropabs(:,2));
    fprintf('propabs: h=%d , p<%.3f\n',h,p);
    [h,p] = ttest2(sdata.minpropang(:,1),sdata.minpropang(:,2));
    fprintf('propang: h=%d , p<%.3f\n',h,p);
    [h,p] = ttest2(sdata.minthresh(:,1),sdata.minthresh(:,2));
    fprintf('thresh:  h=%d , p<%.3f\n',h,p);
    % clean
    clearvars -except sdata numbers;
    
%% t-test .5 parameters
    
    fprintf('\n\nt-test against 0.50\n');
    [h,p] = ttest(sdata.minpropabs(:,1)-0.5);
    fprintf('propabs: h=%d , p<%.3f\n',h,p);
    [h,p] = ttest(sdata.minpropabs(:,2)-0.5);
    fprintf('       : h=%d , p<%.3f\n',h,p);
    [h,p] = ttest(sdata.minpropang(:,1)-0.5);
    fprintf('propang: h=%d , p<%.3f\n',h,p);
    [h,p] = ttest(sdata.minpropang(:,2)-0.5);
    fprintf('       : h=%d , p<%.3f\n',h,p);
    [h,p] = ttest(sdata.minthresh(:,1)-0.5);
    fprintf('thresh : h=%d , p<%.3f\n',h,p);
    [h,p] = ttest(sdata.minthresh(:,2)-0.5);
    fprintf('       : h=%d , p<%.3f\n',h,p);
    % clean
    clearvars -except sdata numbers;
    
%% anova all
    tools_repanova([sdata.minpropabs,sdata.minpropang,sdata.minthresh],[3,2]);
    
%% anova ang/thresh
    tools_repanova([sdata.minpropang,sdata.minthresh],[2,2]);


% ======================================================================= %
% ======================================================================= %

%% plot errors
    figure('color',[1 1 1]);
    colormap([.7,0,0]);
    hold on;
    bar(mean(sdata.minminfits));
    tools_dotplot(sdata.minminfits);
    set(gca,'xtick',1:2);
    set(gca,'xticklabel',{'familiar','novel'});
    % clean
    clearvars -except sdata numbers;

%% plot parameters
    figure('color',[1 1 1]);
    minparams = nan(numbers.nb_subjects,numbers.nb_novelties,3);
    minparams(:,:,1) = sdata.minpropabs;
    minparams(:,:,2) = sdata.minpropang;
    minparams(:,:,3) = sdata.minthresh;
    tools_dotplot(minparams);
    hold on; plot([0:4],0.5*ones(1,5),'k--');
    set(gca,'xtick',1:3);
    set(gca,'xticklabel',{'propabs','propang','thresh'});
    ylim([0,1]);
    set(gca,'fontsize',16,'fontname','Arial');
    % clean
    clearvars -except sdata numbers;

%% fitting plot
    figure('color',[1 1 1]);
    i_plot = 0;
    for i_propabs = 1:numbers.nb_propabss
        for i_propang = 1:numbers.nb_propangs
            i_plot = i_plot+1;
            subplot(numbers.nb_propabss,numbers.nb_propangs,i_plot);
            tools_dotplot(squeeze(sdata.minfits(:,:,i_propabs,i_propang,:)));
            xlim([0,numbers.nb_threshs+1]);
            set(gca,'xtick',1:numbers.nb_threshs);
            xticklabels = cell(1,numbers.nb_threshs);
            for i_xticklabel = 1:numbers.nb_threshs
                xticklabels{i_xticklabel} = num2str(numbers.u_thresh(i_xticklabel));
            end
            set(gca,'xticklabel',xticklabels);
            set(get(gca,'xlabel'),'string',['(',num2str(numbers.u_propabs(i_propabs)),',',num2str(numbers.u_propang(i_propang)),')'],'fontsize',16,'fontname','Arial');
            ylim([min(sdata.minfits(:)),max(sdata.minfits(:))]);
        end
    end
    % clean
    clearvars -except sdata numbers;
    
%% individual plots
    figure('color',[1 1 1]);
    i_plot = 0;
    for i_novelty = 1:numbers.nb_novelties
        for i_subject = 1:numbers.nb_subjects
            % figure
            i_plot = i_plot+1;
            subplot(numbers.nb_subjects,numbers.nb_novelties,i_plot);
            hold on;
            % subject
            this_subdata = sdata.subdata( ...
                                        i_subject,...
                                        i_novelty, ...
                                        find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)),...
                                        find(numbers.u_propang == sdata.minpropang(i_subject,i_novelty)),...
                                        find(numbers.u_thresh  == sdata.minthresh(i_subject,i_novelty)),...
                                        :...
                                      );
            % model
            this_modeldata = sdata.moddata( ...
                                        i_subject,...
                                        i_novelty, ...
                                        find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)),...
                                        find(numbers.u_propang == sdata.minpropang(i_subject,i_novelty)),...
                                        find(numbers.u_thresh  == sdata.minthresh(i_subject,i_novelty)),...
                                        :...
                                      );
            % plot
            plot(squeeze(this_subdata),'o','markerfacecolor','k','markeredgecolor','k','markersize',10);
            plot(squeeze(this_modeldata),'linewidth',2,'linestyle','-','color','r');
            ylim([0 1]);
            xlim([1 numbers.nb_trials]);
        end
    end
    % clean
    clearvars -except sdata numbers;

%% data plot
    figure('color',[1 1 1]);
    c = 'rg';
    for i_novelty = 1:numbers.nb_novelties
        subplot(1,numbers.nb_novelties,i_novelty);
        hold on;
        this_subdata = nan(numbers.nb_subjects,numbers.nb_trials);
        this_modeldata = nan(numbers.nb_subjects,numbers.nb_trials);
        for i_subject = 1:numbers.nb_subjects
            % subject
            this_subdata(i_subject,:) = sdata.subdata(...
                                                    i_subject,...
                                                    i_novelty,...
                                                    find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)),...
                                                    find(numbers.u_propang == sdata.minpropang(i_subject,i_novelty)),...
                                                    find(numbers.u_thresh  == sdata.minthresh(i_subject,i_novelty)),...
                                                    :...
                                                );
            % model
            this_modeldata(i_subject,:) = sdata.moddata(...
                                                    i_subject,...
                                                    i_novelty,...
                                                    find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)),...
                                                    find(numbers.u_propang == sdata.minpropang(i_subject,i_novelty)),...
                                                    find(numbers.u_thresh  == sdata.minthresh(i_subject,i_novelty)),...
                                                    :...
                                                );
        end
        plot(squeeze(mean(this_subdata)), 'o','markerfacecolor','k','markeredgecolor','k','markersize',10);
        plot(squeeze(mean(this_modeldata)),'linewidth',2,'linestyle','-','color',c(i_novelty));
        ylim([0 1]);
        xlim([1 numbers.nb_trials]);
        set(gca,'fontsize',16,'fontname','Arial');
    end
    % clean
    clearvars -except sdata numbers;

%% other plot
    figure('color',[1 1 1]);
    c = 'rg';
    for i_novelty = 1:numbers.nb_novelties
        subplot(1,numbers.nb_novelties,i_novelty);
        hold on;
        this_subdata = nan(numbers.nb_subjects,numbers.nb_trials);
        this_modeldata = nan(numbers.nb_subjects,numbers.nb_trials);
        for i_subject = 1:numbers.nb_subjects
            % subject
            this_subdata(i_subject,:) = sdata.subother(...
                                                    i_subject,...
                                                    i_novelty,...
                                                    find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)),...
                                                    find(numbers.u_propang == sdata.minpropang(i_subject,i_novelty)),...
                                                    find(numbers.u_thresh  == sdata.minthresh(i_subject,i_novelty)),...
                                                    :...
                                                );
            % model
            this_modeldata(i_subject,:) = sdata.modother(...
                                                    i_subject,...
                                                    i_novelty,...
                                                    find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)),...
                                                    find(numbers.u_propang == sdata.minpropang(i_subject,i_novelty)),...
                                                    find(numbers.u_thresh  == sdata.minthresh(i_subject,i_novelty)),...
                                                    :...
                                                );
        end
        plot(squeeze(mean(this_subdata)), 'o','markerfacecolor','k','markeredgecolor','k','markersize',10);
        plot(squeeze(mean(this_modeldata)),'linewidth',2,'linestyle','-','color',c(i_novelty));
        ylim([0 1]);
        xlim([1 numbers.nb_trials]);
        set(gca,'fontsize',16,'fontname','Arial');
    end
    % clean
    clearvars -except sdata numbers;
