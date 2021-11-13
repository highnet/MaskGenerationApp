function plot_areas(areas,location)

numberOfAreas = size(areas);
numberOfAreas = numberOfAreas(2);

x = [];
y = [];

x = [1:numberOfAreas];

for i = 1:numberOfAreas
    y = [y areas{1,i}];
end

plot(x,y);
title(location);
xlabel("Year");
ylabel("Water body area (squared meters)");

end
