

if exist('matlabpool','file') && ~matlabpool('size')
    
    % profiles
    [~,profiles] = defaultParallelConfig();
    
    % janmanager
    if ismember('janmanager',profiles)
        matlabpool('janmanager');
        pctconfig('portrange', [31000,32000]);
    % local
    else
        matlabpool();
    end
    
    % clean
    clear('profiles');
end
