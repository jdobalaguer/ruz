function stp(in,varargin)

% function stp(in,[linespecs],[barspecs],[xspecs],[condnames],[barwidth],[alph]) 
%
% this is the new and improved version of 'steplot'.
% stp  takes a subjects*conditions (or subjects*conditions*another
% level) variable and plots each condition as a separate line, with
% standard error bars and stats if required.  It should be fully backwards
% compatible with steplot.
%
% in its most basic form it will plot following the matlab colour cycle
% (see 'doc colorspec') with 1 point black standard error bars on each
% condition, for example: figure;stp(rand(10,4,16))
%
% however, stp now allows you to dynamically enter line and colour
% properties, as well as changing the x-axis. These entries are variable
% input arguments 'linespecs','barspecs' and 'xspecs'.
%
% linespecs - a cell vector with the optional inputs to matlab's figure(),
% e.g. linespecs={'color','b','linewidth',2};
%
% barspecs - a cell vector of optional inputs to matlab's line()
% e.g. barspecs={'color',[0.8 0.8 0.8],'linewidth',20};
%
% xspecs - a cell by cell vector of optional inputs to gca, for example:
% xspecs={{'Xtick',[4:4:16]},{'Xticklabel',[100:100:400]}};
%
% and then...
% figure;stp(rand(10,4,16),linespecs,barspecs,xspecs);
%
% however, this also allows you to plot different conditions in different 
% linespecs, without being forced to used matlab's color cycle. so for
% example 
%
% clear linespecs;
% linespecs{1}={'color','b','linewidth',2,'linestyle',':'}
% linespecs{2}={'color','b','linewidth',2,'linestyle','-'}
% linespecs{3}={'color','g','linewidth',2,'linestyle',':'}
% linespecs{4}={'color','g','linewidth',2,'linestyle','-'}
%
% figure;stp(rand(10,4,16),linespecs);
%
% another optional input is 'barwid' (which allows you to change the width
% of the crossbar on the SE bar
%

% defaults
%if exist('colormaker','file');
%    colors=colormaker(size(in,2));
%    for n=1:size(in,2);
%        colorcycle{n}=colors(n,:);
%    end
%close;
%else
colorcycle={'r','g','b','c','m','y','k','b','g','r','c','m','y','k'};
%end
linespecs=[];
barspecs=[];
xspecs=[];
alph=[];
barwid=[];
condnames=[];
hold on;


% get variable arguments
if length(varargin)>0,linespecs=varargin{1};,end
if length(varargin)>1,barspecs=varargin{2};,end
if length(varargin)>2,xspecs=varargin{3};,end
if length(varargin)>3,condnames=varargin{4};,end
if length(varargin)>4,barwid=varargin{5};,end
if length(varargin)>5,alph=varargin{6};,end

if isempty(barwid),barwid=20;,end
if isempty(barspecs),barspecs={'color','k','linewidth',1};,end
if isempty(linespecs)
    linespecs={};   
end
if isempty(condnames)
    %for n=1:size(in,2);
    %condnames{n}=['cond ',num2str(n)];
    %end
end
if isempty(linespecs)
    x=iscell(in);
    for n=1:size(in,2-x);
    linespecs{n}={'color',colorcycle{n},'linewidth',2};
    end
end

if ~iscell(in)
    
    if ndims(in)==2 | size(in,2)==1;
        for n=1:2;
        in1(:,n,:)=in;
        end
        in=in1;
    end

    stein=squeeze(std(in,[],1))/sqrt(size(in,1));     %standard error is std/root n
    meanin=squeeze(mean(in));

    np=size(in,3);    %number of conditions      
    nc=size(in,2);
    
else % if in is cell variable;

    if ndims(in)==1;
    for n=1:length(in);
        meanin(n,:)=mean(in{n});
        stein(n,:)=squeeze(std(in{n},[],1))/sqrt(size(in{n},1));     %standard error is std/root n
    end
    
      meanin=[meanin';meanin'];    
      stein=[stein';stein'];
    
    nc=1;
    np=length(in);

    
    elseif ndims(in)==2;
     for n=1:size(in,1);
         for m=1:size(in,2);
        meanin(n,m)=mean(in{n,m});
        stein(n,m)=squeeze(std(in{n,m},[],1))/sqrt(size(in{n,m},1));     %standard error is std/root n
         end
    end 
   
    np=size(in,2);    %number of conditions      
    nc=size(in,1);

    end
end
    
    %disp([num2str(nc),' conditions, ',num2str(np), ' points']);  %debugging


    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% do stats %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ytick=ranger(meanin);
    
    if ~isempty(alph)
            if size(in,2)>1 & size(in,3)>1;
                [F1 F2 F12 p1 p2 p12]=pti(in);
                if p1<alph | p2<alph | p12<alph
                    disp(['omnibus: p1=',num2str(p1),', p2=',num2str(p2),', p12=',num2str(p12)]);                    
                    if nc==2; % if 2 conditiions, do t-test
                        for n=1:size(in,3);
                            [ho pval(n) rci stats]=ttest_t(in(:,1,n)-in(:,2,n),0,alph);                           
                            if ho>0;
                                line([n,n],[ytick(1),ytick(end)],'linewidth',barwid,'color',[0.9 0.9 0.9]);
                            end
                        end
                        disp(['min p val:',num2str(min(pval))]);
                    else  %if >2 conditiions, do anova
                        for n=1:size(in,3);
                            [f1 f2 f12 p1 p2 p12]=pti(in(:,:,n));
                            if p1<alph;
                                line([n,n],[ytick(1),ytick(end)],'linewidth',barwid,'color',[0.9 0.9 0.9]);
                            end
                        end
                    end
                else
                    disp(['n.s. p1=',num2str(p1),', p2=',num2str(p2),', p12=',num2str(p12)]);
                end
            end
          
    end
       
       
    
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% insert barspecs info %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    toeval{1}='line([p,p],[meanin(c,p)-(stein(c,p)/2),meanin(c,p)+(stein(c,p)/2)]';
    toeval{2}='line([p-1/barwid,p+1/barwid],[meanin(c,p)-(stein(c,p)/2),meanin(c,p)-(stein(c,p)/2)]';
    toeval{3}='line([p-1/barwid,p+1/barwid],[meanin(c,p)+(stein(c,p)/2),meanin(c,p)+(stein(c,p)/2)]';
    
    for statement=1:length(toeval);
        
        for e=1:length(barspecs);
            if ischar(barspecs{e});
                toeval{statement}=[toeval{statement},',','''',barspecs{e},''''];
            elseif isnumeric(barspecs{e});
                if length(barspecs{e})>1;
                toeval{statement}=[toeval{statement},',[',num2str(barspecs{e}),']'];
                else
                toeval{statement}=[toeval{statement},',',num2str(barspecs{e})];
                end
            end
        end
        toeval{statement}=[toeval{statement},');'];
        %disp(toeval{statement})    %debugging
    end
    
    longeval='for c=1:nc;for p=1:np;';
    for statement=1:length(toeval);
        longeval=[longeval toeval{statement} ';'];
    end

    longeval=[longeval ';end;end'];

    
    try
    eval(longeval);  
    catch
        disp('bars didnt work');
        disp(longeval);    %debugging
    end
    
    if ~isempty(linespecs);
    if ~iscell(linespecs{1});
        for c=1:nc;
            linespecs1{c}=linespecs;
        end
        linespecs=linespecs1;
    end
    end

    
 
    for c=1:nc;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% insert linespecs info %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    meanin_t=meanin';
    
    lineeval=['hog=plot(meanin_t(:,c)'];
    if ~isempty(linespecs);
        for e=1:length(linespecs{c});
            if ischar(linespecs{c}{e});
                lineeval=[lineeval,',','''',linespecs{c}{e},''''];
            elseif isnumeric(linespecs{c}{e})
                 if length(linespecs{c}{e})>1;
                 lineeval=[lineeval,',[',num2str(linespecs{c}{e}),']'];                     
                 else                     
                 lineeval=[lineeval,',',num2str(linespecs{c}{e})];
                 end
            end
        end
    end
    
        lineeval=[lineeval,');'];
       
        
        try
        eval(lineeval);
        catch
         disp(lineeval)       %debugging            
         disp('line didnt work');
        end
    
        handies(c)=hog;
    end   
        
    if ~isempty(condnames);
    legend(handies,condnames,'location','northeast');legend boxoff;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% set xaxis info %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for statements=1:length(xspecs);
        if isnumeric(xspecs{statements}{2})
        xeval=['set(gca,''',xspecs{statements}{1},'''',',[','',num2str(xspecs{statements}{2}),']);'];            
        else
       % xeval=['set(gca,''',xspecs{statements}{1},''',{''',xspecs{statements}{2}{1},'''});'];
        xeval=['set(gca,''',xspecs{statements}{1},''',{''',xspecs{statements}{2}{1},''',''',xspecs{statements}{2}{2},'''});'];       
        end

        try
            eval(xeval);
        catch
            disp('xaxis didnt work');
            disp(xeval);
        end
    end
    



end
