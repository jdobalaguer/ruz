
%% START ==================================================================
fprintf('\n#### run_fixthresh ####\n');

%% LOAD ===================================================================
fprintf('\nload data');
if ~exist('sdata','var')
    load_allran;
else
    fprintf(['\n    skipping']);
end

%% FIX ====================================================================
fprintf('\nfix data');
if numbers.nb_threshs > 1

    %% numbers
    % numbers
    numbers.u_thresh   = 1;
    numbers.nb_threshs = 1;
    % xx_thresh
    xx_thresh  = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    for i_thresh = 1:numbers.nb_threshs
        xx_thresh(:,:,:,:,i_thresh)  = numbers.u_thresh(i_thresh);
    end
    numbers.xx_thresh  = xx_thresh;

    %% sdata
    sdata.modch(:,:,:,:,:,1:end-1) = [];
    sdata.modcr(:,:,:,:,:,1:end-1) = [];
    sdata.moddata(:,:,:,:,:,1:end-1)  = [];
    sdata.modother(:,:,:,:,:,1:end-1) = [];
    sdata.minfits(:,:,:,:,1:end-1) = [];

    %% flags
    sdata.flag_runmodels = 1;
    sdata.flag_calcvals = 0;
    sdata.flag_minfits = 0;
else
    fprintf(['\n    skipping']);
end

%% END ====================================================================
clearvars -except sdata numbers;
fprintf('\n\n#### /run_fixthresh ####\n\n');

%% FITTING ================================================================
run_fitting;

return;
