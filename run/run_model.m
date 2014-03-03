
function mdata = run_model(model)
    %% assert model
    model_assert(model);

    %% load
    sdata   = struct();
    numbers = struct();
    load('data/sdata.mat','sdata','numbers');

    %% run
    % parallel toolbox
    tools_startparallel;

    % store results
    mdata = cell(numbers.shared.nb_subject,numbers.shared.nb_block);

    % parallel loop
    nb_cases = numel(numbers.shared.xx_subject);
    parfor i_case = 1:nb_cases
        % case indexes
        i_subject  = numbers.shared.xx_subject(i_case);
        i_block    = numbers.shared.xx_block(i_case);
        ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
        ii_block   = (sdata.exp_block   == numbers.shared.u_block(i_block));
        ii_case    = (ii_subject & ii_block);
        % block variables
        vb_novel   = unique(sdata.vb_novel(ii_case));
        vb_stimord = sdata.vb_stimord(ii_case,:);
        vb_target  = sdata.vb_target(ii_case);
        vb_rules   = sdata.vb_rules(ii_case,:);
        % model
        mdata{i_case} = model_block(model,vb_stimord,vb_novel,vb_target,vb_rules);
    end
    
    %% unify data
    mdata = mdata';
    mdata = mdata(:);
    mdata = tools_cell2struct(mdata);
end
