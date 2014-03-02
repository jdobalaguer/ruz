
function s = tools_cell2struct(c)
    s = c{1};
    f = fieldnames(s);
    for i_c = 2:numel(c)
        for i_f = 1:length(f)
            s.(f{i_f}) = cat(1,s.(f{i_f}),c{i_c}.(f{i_f}));
        end
    end
end