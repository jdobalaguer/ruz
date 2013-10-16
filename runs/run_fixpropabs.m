
%% START ==================================================================
fprintf('\n#### run_fixpropabs ####\n');

%% LOAD ===================================================================
fprintf('\nload data');
if ~exist('sdata','var')
    load_allran;
else
    fprintf(['\n    skipping']);
end

%% FIX ====================================================================
fprintf('\nfix data');

setvalue = 0.5;

if numbers.nb_propabss > 1

    %% numbers
    % numbers
    u_propabs = numbers.u_propabs;
    numbers.u_propabs   = setvalue;
    numbers.nb_propabss = 1;
    % xx_propabs
    xx_propabs  = nan(numbers.nb_subjects,numbers.nb_novelties,numbers.nb_propabss,numbers.nb_propangs,numbers.nb_threshs);
    for i_propabs = 1:numbers.nb_propabss
        xx_propabs(:,:,i_propabs,:,:)  = numbers.u_propabs(i_propabs);
    end
    numbers.xx_propabs = xx_propabs;

    %% sdata
    sdata.subch(:,:,u_propabs~=setvalue,:,:,:) = [];
    sdata.subcr(:,:,u_propabs~=setvalue,:,:,:) = [];
    sdata.subdata(:,:,u_propabs~=setvalue,:,:,:)  = [];
    sdata.subother(:,:,u_propabs~=setvalue,:,:,:) = [];
    
    sdata.modch(:,:,u_propabs~=setvalue,:,:,:) = [];
    sdata.modcr(:,:,u_propabs~=setvalue,:,:,:) = [];
    sdata.moddata(:,:,u_propabs~=setvalue,:,:,:)  = [];
    sdata.modother(:,:,u_propabs~=setvalue,:,:,:) = [];
    
    sdata.minfits(:,:,u_propabs~=setvalue,:,:) = [];

    %% flags
    sdata.flag_runmodels = 1;
    sdata.flag_calcvals = 0;
    sdata.flag_minfits = 0;
else
    fprintf(['\n    skipping']);
end

%% END ====================================================================
clearvars -except sdata numbers;
fprintf('\n\n#### /run_fixpropabs ####\n\n');

%% FITTING ================================================================
run_fitting;

return;
