function percent = tools_parforprogress(N)
%tools_parforprogress Progress monitor (progress bar) that works with parfor.
%   tools_parforprogress works by creating a file called .progress in
%   your working directory, and then keeping track of the parfor loop's
%   progress within that file. This workaround is necessary because parfor
%   workers cannot communicate with one another so there is no simple way
%   to know which iterations have finished and which haven't.
%
%   tools_parforprogress(N) initializes the progress monitor for a set of N
%   upcoming calculations.
%
%   tools_parforprogress updates the progress inside your parfor loop and
%   displays an updated progress bar.
%
%   tools_parforprogress(0) deletes .progress and finalizes progress
%   bar.
%
%   To suppress output from any of these functions, just ask for a return
%   variable from the function calls, like PERCENT = tools_parforprogress which
%   returns the percentage of completion.
%
%   Example:
%
%      N = 100;
%      tools_parforprogress(N);
%      parfor i=1:N
%         pause(rand); % Replace with real code
%         tools_parforprogress;
%      end
%      tools_parforprogress(0);
%
%   See also PARFOR.

% By Jeremy Scheff - jdscheff@gmail.com - http://www.jeremyscheff.com/

error(nargchk(0, 1, nargin, 'struct'));

if nargin < 1
    N = -1;
end

percent = 0;
w = 50; % Width of progress bar

if N > 0
    f = fopen('.progress', 'w');
    if f<0
        error('Do you have write permissions for %s?', pwd);
    end
    fprintf(f, '%d\n', N); % Save N at the top of progress.txt
    fclose(f);
    
    if nargout == 0
        fprintf(['  0%%[>', repmat(' ', 1, w), ']\n']);
    end
elseif N == 0
    delete('.progress');
    percent = 100;
    
    if nargout == 0
        fprintf([repmat(char(8), 1, (w+8)), '100%%[', repmat('=', 1, w+1), ']\n']);
    end
else
    if ~exist('.progress', 'file')
        error('.progress not found. Run tools_parforprogress(N) before tools_parforprogress to initialize .progress.');
    end
    
    f = fopen('.progress', 'a');
    fprintf(f, '1\n');
    fclose(f);
    
    f = fopen('.progress', 'r');
    progress = fscanf(f, '%d');
    fclose(f);
    percent = (length(progress)-1)/progress(1)*100;
    
    if nargout == 0
        perc = sprintf('%3.0f%%%%', percent); % 4 characters wide, percentage
        fprintf([repmat('\b', 1, (w+8)), perc, '[', repmat('=', 1, round(percent*w/100)), '>', repmat(' ', 1, w - round(percent*w/100)), ']\n']);
        drawnow('update');
    end
end
