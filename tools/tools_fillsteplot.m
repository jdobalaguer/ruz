function h = fillsteplot(dat,linewid,linez,condnames,xrange,colorcycle)
% function h = fillsteplot(dat,linewid,linez,condnames,xrange,colorcycle)

%
% Plots a mean vector (mean of each column of dat)
% surrounded by a fill with standard err bars
%
% If dat has 3 dimensions, then
% the diff between dat(:,:,1) and dat(:,:,2) is
% used as the difference for computing standard err
% (as in repeated measures)
%
% if behavior is entered as optional argument, removes it before plotting
% lines.


if nargin<2;
    linewid=2;
end
if nargin<3;
    linez='-';
end
if nargin<4;
    for n=1:size(dat,2);
        condnames{n}=['v',num2str(n)];
    end
end

if nargin<5;
    xrange=1:size(dat,ndims(dat));
end

if nargin<6
colorcycle={'r','g','b','c','m','y','k','b','g','r','c','m','y','k'};
end

if ndims(dat)==3;
    
    
for c=1:size(dat,2);
    
    m=squeeze(mean(dat(:,c,:)));
    
    hold on; 
    h(c)=plot(xrange,m,colorcycle{c},'LineWidth',linewid,'linestyle',linez);
    
    d = squeeze(dat(:,c,:));
   
%    md = nanmean(d);
    tools_fillaroundline(m,tools_ste(d),colorcycle{c},xrange);
   
end
%legend(h,condnames,'location','best');
legend(h,condnames);
legend boxoff;

elseif ndims(dat)==2;
   m=squeeze(mean(dat));
    
    hold on; 
    plot(m,colorcycle{1},'LineWidth',2,'linestyle',linez);
       
%    md = nanmean(d);
    fill_around_line(m,ste(dat),colorcycle{1});
end
    
    

return