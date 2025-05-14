% Author: Sergej Keser 11727255
%PLots the data
function plot_areas(data)

numberOfAreas = max(size(data)); % count how many areas are in the input cell
x = 1:numberOfAreas; % the x axis is a simple linear scale.
plot(x,data); % plot the x and y axis
xlabel("Image"); % add the x axis label
ylabel("Water body area (squared meters)"); % add the y axis label

end
