
if exist('matlabpool','file') && ~matlabpool('size')
    pctconfig('portrange', [31000,32000]);
    matlabpool('janmanager');
end
