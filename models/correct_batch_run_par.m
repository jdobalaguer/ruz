
function [mkey,mdata] = correct_batch_run_par(sdata,numbers,mdata_keys,alpha_c,alpha_w,tau)

    %% variables
    % model
    model.name         = 'correct';
    model.alpha_c      = alpha_c;
    model.alpha_w      = alpha_w;
    model.tau          = tau;
    % key
    mkey = [alpha_c,alpha_w,tau];

    %% mkey, mdata
    if isempty(mdata_keys) || ~ismember(mkey,cell2mat(mdata_keys),'rows')
        %% run
        mdata = run_model(model,sdata,numbers);
    else
        %% already exists
        mdata = struct();
        mkey  = [nan,nan,nan];
    end

    %% progress
    tools_parforprogress();

end