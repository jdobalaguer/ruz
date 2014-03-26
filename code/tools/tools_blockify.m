
function numbers = tools_blockify(numbers)
    % xx_subject
    numbers.shared.xx_subject = nan(numbers.shared.nb_subject,numbers.shared.nb_block);
    for i_subject = 1:numbers.shared.nb_subject
        numbers.shared.xx_subject(i_subject,:) = i_subject;
    end
    % xx_block
    numbers.shared.xx_block   = nan(numbers.shared.nb_subject,numbers.shared.nb_block);
    for i_block = 1:numbers.shared.nb_block
        numbers.shared.xx_block(:,i_block)     = i_block;
    end
end