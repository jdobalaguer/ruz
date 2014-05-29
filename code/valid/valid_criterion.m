
function criterion = valid_criterion()
    %criterion = @(ch,co) ch;            ... choice
    %criterion = @(ch,co) co;            ... correct
    criterion = @(ch,co) (ch+co)*0.5;   ... mix
end
