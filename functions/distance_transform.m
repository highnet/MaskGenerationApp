function [thickness] = distance_transform(img)
% Find all unique river channels and assign them an ID
Img=img;
bwImg=im2bw(Img, 0.45);
[label,N] = bwlabel(bwImg);

% Initialize an array that determines the width
thickness = zeros(N,1);

% For each "channel"
for index = 1 : N

    countour = label == index; % Get a mask that segments out the parts of the river flow (channels)
    d = bwdist(~countour); % apply distance transform on the inverse of that img


    maxDistance = max(d(:)); % Get the maximum distance to the edge
    distances = d(abs(d - maxDistance) <= 1); % Collect those distances within a tolerance, in this case lower than 1
    thickness(index) = 2*mean(distances);  % Find the average width and multiply by 2 for full width


    % the following bit is me testing the code, it should show thw width at
    % each point, cant figure it out quite good enough for now
% imshow(bwImg); hold on;
% for index = 1 : N
%     [y,x]= find(label == index);
%     center = mean([x y]);
%     text(center(1), center(2), ['T = ' num2str(thickness(index))], 'color', 'red');
% end
end

