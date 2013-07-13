function Region = RegionGrowing(I,T)

Visited = zeros(size(I));
Region = zeros(size(I));

% Location of the 8 neighbors
neigb=[-1 0; 1 0; 0 -1;0 1; 1 1; -1 -1; -1 1; 1 -1];
[s1, s2] = size(I);
t = tic;

% Select and add the seed point to tho the queue of pixel to visist "list"
figure; imagesc(I);axis image; axis xy; title('Select the seed point');...
    colormap gray;axis off
[y x] = ginput(1);
x = round(x); 
y = round(y);
Im = I(x,y);
list = [x, y];

% Grow until no more pixel can be added to the FIFO list
Im = I(x,y); % Inintuialize the mean Intensity inside the region
list = [x, y];
while(size(list,1)~=0)
    
    % Pick up and remove the first pixel from the list
    pix = list(1,:);
    list = list(2:size(list,1),:);
    
    % Check if pixel is homogeneous
    % By comparing it to the mean Intensity inside the region
    
    if abs(I(pix(1),pix(2))-Im) <= T
        Region(pix(1), pix(2))=1;
        for k = 1:8
            pneigh = pix+neigb(k,:);
            %check if neighbouring cells are in the boundaries
            if pneigh(1)>0 && pneigh(2)>0 && pneigh(1)<=s1 && pneigh(2)<=s2
                if Visited(pneigh(1),pneigh(2))~=1
                    list=[list; pneigh];
                    Visited(pneigh(1),pneigh(2))=1;
                end
            end
        end
    end
    Im = mean(I(Region==1));
    
    if toc(t)>1/23
        imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
        drawnow;
        t = tic;
    end
    
end

%% Display
imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
drawnow;

