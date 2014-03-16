
function tools_stopparallel()
    if exist('matlabpool','file') && matlabpool('size')
        matlabpool('close');
    end
end