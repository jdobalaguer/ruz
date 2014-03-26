
nb_ttrials = length(sdata.sub);

% initialize
new_codez = nan(size(sdata.codez));

% sort
for i_trial = 1:nb_ttrials
    % get Ho for current cues
    codez = sdata.codez(:,i_trial);
    % current Ho
    Ho = nan(1,4);
    for i_side = 1:4
        Ho(i_side) = sdata.Mfit_Ho(i_trial,i_side,codez(i_side));
    end
    
    % sort relevant
    if Ho(1) > Ho(2)
        new_codez(1,i_trial) = codez(1);
        new_codez(2,i_trial) = codez(2);
    else
        new_codez(1,i_trial) = codez(2);
        new_codez(2,i_trial) = codez(1);
    end
    
    % sort irrelevant
    if Ho(3) > Ho(4)
        new_codez(3,i_trial) = codez(3);
        new_codez(4,i_trial) = codez(4);
    else
        new_codez(3,i_trial) = codez(4);
        new_codez(4,i_trial) = codez(3);
    end
end

sdata.codez = new_codez;

% clean
clearvars -except sdata numbers;
