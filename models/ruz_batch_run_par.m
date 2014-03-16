
function [mkey,mdata] = ruz_batch_run_par(sdata,numbers,mdata_keys,alpha_t,alpha_n,tau)

    % set model
    model.name         = 'ruz';
    model.alpha_t      = alpha_t;
    model.alpha_n      = alpha_n;
    model.tau          = tau;

    % set key
    model.key = [alpha_t,alpha_n,tau];

    % run & save
    if isempty(cell2mat(mdata_keys)) || ~ismember(model.key,cell2mat(mdata_keys),'rows')
        mdata = run_model(model,sdata,numbers);
        mkey  = model.key;
    else
        mdata = struct();
        mkey  = [nan,nan,nan];
    end

    % progress
    tools_parforprogress();

end