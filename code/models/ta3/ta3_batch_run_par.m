
function [mkey,mdata] = ta3_batch_run_par(sdata,numbers,mdata_keys,alpha_m,alpha_r,tau,choc)

    %% variables
    % model
    model.name         = 'ta3';
    model.alpha_m      = alpha_m;
    model.alpha_r      = alpha_r;
    model.tau          = tau;
    % key
    mkey = [alpha_m,alpha_r,tau];

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
    
    %% choc
    if choc
        tdata = struct();
        tdata.choice  = mdata.choice;
        tdata.correct = mdata.correct;
        mdata = tdata;
    end

end