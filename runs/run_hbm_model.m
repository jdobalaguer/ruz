%
% run a hierarchical bayesian model
%

clc;
clear all;

%% sdata
load_alldata;

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

%% run models
% relevant rows for this block in sdata.codez
codekey = [1,2;3,4;1,4;2,3];
fprintf(['\n  subject..']);
for i_subject = 1:numbers.nb_subjects
    fprintf([num2str(numbers.u_subject(i_subject)),', ']);
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
        % run model
        odata = model_hbm(codez,attside,target,k);
        % log model
        sdata.Mbayes_nc(indx) = odata.modelcands;
        sdata.Mbayes_pr(indx) = odata.modelprobs;
        sdata.Mbayes_ch(indx) = odata.modelchoice;
        sdata.Mbayes_cr(indx) = odata.modelcor;
        sdata.Mbayes_hl(indx) = odata.modelhleft;
        sdata.Mbayes_hr(indx) = odata.modelhright;
    end
end
fprintf(['\n']);

clearvars -except sdata numbers;
