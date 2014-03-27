
function [mkey,mdata] = taco4_batch_run_par(sdata,numbers,mdata_keys,alpha_m,alpha_rt,alpha_rc,tau,choc)

    %% variables
    % model
    model.name         = 'taco4';
    model.alpha_m      = alpha_m;
    model.alpha_rt     = alpha_rt;
    model.alpha_rc     = alpha_rc;
    model.tau          = tau;
    % key
    mkey = [alpha_m,alpha_rt,alpha_rc,tau];

    %% mkey, mdata
    if isempty(mdata_keys) || ~ismember(mkey,cell2mat(mdata_keys),'rows')
        %% run
        mdata = run_model(model,sdata,numbers);
        
        %% choc
        if choc
            tdata = struct();
            tdata.choice  = mdata.choice;
            tdata.correct = mdata.correct;
            mdata = tdata;
        end
    else
        %% already exists
        mdata = struct();
        mkey  = [nan,nan,nan,nan];
    end

    %% progress
    tools_parforprogress();
    
end