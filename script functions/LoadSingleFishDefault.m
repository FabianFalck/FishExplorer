function [cIX,gIX,M] = LoadSingleFishDefault(i_fish,hfig)

setappdata(hfig,'i_fish',i_fish);

%% load fish data
isFullData = true;
LoadFullFish(hfig,i_fish,isFullData);

%% load the auto-clustering indices
i_ClusGroup = 6; % master-thres 0.7
i_Cluster = 1;

[cIX,gIX] = LoadCluster_Direct(i_fish,i_ClusGroup,i_Cluster);

setappdata(hfig,'cIX',cIX);
setappdata(hfig,'gIX',gIX);

[~,stimrange] = GetStimRange([],i_fish);
setappdata(hfig,'stimrange',stimrange); % need to UpdateTimeIndex if changed
UpdateTimeIndex(hfig);

M = getappdata(hfig,'M');

end