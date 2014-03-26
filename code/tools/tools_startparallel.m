
function tools_startparallel()
    if exist('matlabpool','file') && ~matlabpool('size')
        % profiles
        if verLessThan('matlab','8.0.0')
            [~,profiles] = defaultParallelConfig();
        else
            profiles = parallel.clusterProfiles();
        end

        % janmanager
        if ismember('janmanager',profiles)
            pctconfig('portrange', [31000,32000]);
            matlabpool('janmanager');
        else
            matlabpool();
        end
    end
end
