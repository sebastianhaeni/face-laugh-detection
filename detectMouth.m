function [bbox,bbI,faces,bbfaces] = detectMouth(detectors, I, thick)

% First find face on the image
bbox = step(detectors.detector{1}, I);

bbsize = size(bbox);
% partsNum: for each found face, howmany face parts are there (eyes, mouth,
% nose)
partsNum = zeros(size(bbox,1),1);

% detect mouth
stdsize = detectors.stdsize;

for k=2:4
    
    if( k == 2 ) % Mouth
        region = [1,stdsize; int32(stdsize/3), stdsize];
    elseif( k == 3 ) % Left Eye
        region = [1,int32(stdsize*2/3); 1, int32(stdsize*2/3)];
    elseif( k == 4 ) % Right Eye
        region = [int32(stdsize/3),stdsize; 1, int32(stdsize*2/3)];
    end
    
    bb = zeros(bbsize);
    for i=1:size(bbox,1)
        candidate = I(bbox(i,2):bbox(i,2)+bbox(i,4)-1,bbox(i,1):bbox(i,1)+bbox(i,3)-1,:);
        candidate = imresize(candidate,[stdsize, stdsize]);
        candidate = candidate(region(2,1):region(2,2),region(1,1):region(1,2),:);
        
        candidateBB = step(detectors.detector{k},candidate);
        
        if( size(candidateBB,1) > 0 )
            partsNum(i) = partsNum(i) + 1;
            
            % select lowest bounding box
            if( k == 2 )
                candidateBB = flipud(sortrows(candidateBB,2));
            elseif( k == 3 )
                candidateBB = sortrows(candidateBB,1);
            elseif( k == 4 )
                candidateBB = flipud(sortrows(candidateBB,1));
            end 
            
            ratio = double(bbox(i,3)) / double(stdsize);
            candidateBB(1,1) = int32( ( candidateBB(1,1)-1 + region(1,1)-1 ) * ratio + 0.5 ) + bbox(i,1); % set x
            candidateBB(1,2) = int32( ( candidateBB(1,2)-1 + region(2,1)-1 ) * ratio + 0.5 ) + bbox(i,2); % set y
            candidateBB(1,3) = int32( candidateBB(1,3) * ratio + 0.5 ); % set width
            candidateBB(1,4) = int32( candidateBB(1,4) * ratio + 0.5 ); % set heigth
            
            bb(i,:) = candidateBB(1,:);
        end
    end
    bbox = [bbox,bb];
    
    % delete empty rows
    p = ( sum(bb') == 0 );
    bb(p,:) = [];
end
 
% draw faces
bbox = [bbox,partsNum];
bbox(partsNum < 2,:)=[];

if( thick >= 0 )
 t = (thick-1)/2;
 t0 = -int32(ceil(t));
 t1 = int32(floor(t));
else
 t0 = 0;
 t1 = 0;
end

bbI = I;
boxColor = [[0,255,0]; [255,0,255]];
for k=2:-1:1
 shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',boxColor(k,:)); 
 for i=t0:t1
  bb = int32(bbox(:,(k-1)*4+1:k*4));
  bb(:,1:2) = bb(:,1:2)-i;
  bb(:,3:4) = bb(:,3:4)+i*2;
  bbI = step(shapeInserter, bbI, bb);
 end
end


% faces
faces = cell(size(bbox,1),1);
bbfaces = cell(size(bbox,1),1);
for i=1:size(bbox,1)
    faces{i,1} = I(bbox(i,2):bbox(i,2)+bbox(i,4)-1,bbox(i,1):bbox(i,1)+bbox(i,3)-1,:);
    bbfaces{i,1} = bbI(bbox(i,2):bbox(i,2)+bbox(i,4)-1,bbox(i,1):bbox(i,1)+bbox(i,3)-1,:);
end

