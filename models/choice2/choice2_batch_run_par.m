
function [mkey,mdata] = choice2_batch_run_par(sdata,numbers,mdata_keys,alpha_t,alpha_n,tau)

    %% variables
    % model
    model.name         = 'choice2';
    model.alpha_t      = alpha_t;
    model.alpha_n      = alpha_n;
    model.tau          = tau;
    % key
    mkey = [alpha_t,alpha_n,tau];

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