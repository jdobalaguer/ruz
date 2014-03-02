
function run_model(model)
    %% assert model
    model_assert(model);

    %% load
    load('data/sdata.mat','sdata','numbers');

    %% run
    % parallel toolbox
    if exist('matlabpool','builtin') && ~matlabpool('size')
        pctconfig('portrange', [31000,32000]);
        matlabpool('janmanager');
    end

    % store results
    mdata = cell(numbers.shared.nb_subject,numbers.shared.nb_block);

    % parallel loop
    nb_cases = numel(numbers.shared.xx_subject);
    for i_case = 1:nb_cases
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
        % model
        mdata{i_case} = model_block(model,vb_stimord,vb_novel,vb_target);
    end
    
    %% unify data
    mdata = mdata';
    mdata = mdata(:);
    mdata = tools_cell2struct(mdata);
    
    %% save
    model_save(model,mdata);

end