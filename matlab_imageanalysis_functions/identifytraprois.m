%This function takes an image,a trap template (bw), downward trap (bw)
%Coordinates of the polygon containing the cell relative to the upward trap
%template, Coordinates of the polygon containing the cell relatie to the
%downward trap template,



function [pgrois bwrois] = identifytraprois(image,upwardtrap,downwardtrap,uproicoord,downroicoord,cutofffactor,threshfactor)

    %Identifying all matches to upward traps and downward traps in
    %the image
    padl = 100;
    upwardtrap = im2double(upwardtrap);
    downwardtrap = im2double(downwardtrap);
    level = graythresh(image)*threshfactor;
    upmatchthresh = sum(sum(upwardtrap))*cutofffactor;
    downmatchthresh = sum(sum(downwardtrap))*cutofffactor;
    
    [downmatchloc downmatchstat] = locatetrap(image,downwardtrap,level,downmatchthresh,padl)
    [upmatchloc upmatchstat] = locatetrap(image,upwardtrap,level,upmatchthresh,padl)
    
    %Deciding whether traps face up or face down
    meandownmatch = mean(downmatchstat);
    meanupmatch = mean(upmatchstat);
    matchloc = 0;
    vertexcoord = 0; 
    
    if isnan(meanupmatch)
        matchloc = downmatchloc;
        vertexcoord = downroicoord;
    elseif isnan(meandownmatch)
        matchloc = upmatchloc;
        vertexcoord = uproicoord;
    elseif meanupmatch>meandownmatch
        matchloc = downmatchloc;
        vertexcoord = downroicoord;
    else
        matchloc = upmatchloc;
        vertexcoord = uproicoord;
    end
    
    %shift the matchlocations left by another 2 pixels
    matchloc = round(matchloc,0)-padl - repmat([1,0],size(matchloc,1),1);
    numtraps = size(matchloc,1);
    
    %Generating a phase G image in which roi locations have been overlaid 
    %on top of the original phase G image.
    numvertices = size(vertexcoord,2)/2;
    allvertexcoord = int32(repmat(matchloc,1,numvertices))+repmat(vertexcoord,numtraps,1);
    pgrois = insertShape(image,'FilledPolygon',allvertexcoord,'Color','yellow');
    pgrois = rgb2gray(pgrois);
    
    %Generating a mask corresponding to the roi locations
    
    bwrois = zeros(size(image));
    bwrois = insertShape(bwrois,'FilledPolygon',allvertexcoord,'Color','yellow');
    bwrois = rgb2gray(bwrois);
    bwrois = bwrois>0;
   
    
    
end