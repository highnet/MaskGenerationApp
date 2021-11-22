%This script represents the main script for running our program and
%for showcasing all the work and functions implemented so far without the
%need for using the GUI.
% 
% The GUI will be implemented fully for the final
%project, since a lot of its functionalities are related to the special
%modifications that we need to have in our own implementations of the
%functions such as conected_component_labeling, distance_transform, etc
%
%The input images are located in the 'input' folder, and are named 
%'LandsatInput1,2...n'.
%
%They represented the cropped out and alligned version of the original
%landsat8 satelite images.

%////////////////////MAIN CODE////////////////////////////

%The images are being loaded into appropriate arrays containing 10 images
%representing the time spam at which we want to examine the data. 
% 
% To select the diferent input data, simply un-comment the desired
% initialization of the input images


%img=imread('LandsatInput1.png');
%img=imread('LandsatInput2.png');
img=imread('LandsatInput5.png');
%img=imread('LandsatInput6.png');
%img=imread('LandsatInput7.png');
%img=imread('LandsatInput8.png');
%imshow(img);

%----Creating a binary image using Otsu's threshold-----
otsuImg=otsu(img, 1);
%imshow(otsuImg);

%------Apply the morphological operations------
%For this we use the disk-shape kernels since they tend to preserve the
%shape of rivers the best
%We apply erosion and dilation to remove any loose and stranded pixels that
%might be miss-enterpeted as a body of water or land

erodElement = strel('disk',2);
erodedImg=morph_operation(otsuImg, 'erode',erodElement);
%figure,imshow(erodedImg);

dilationElement = strel('disk',3);
dilatedImg=morph_operation(erodedImg, 'dilate',dilationElement);
%figure,imshow(dilatedImg), label('Dilated Image');

%///////////--Region Growing--/////////////////////////////////////////////
%doing the region growing for the area that represents the river
%Note: for now, a downscaled image is used, as the performance of the
%region growing algorithm has yet to be improved.
%output: binary image with region growing applied
%scaledImg=imread('LandsatInput5Downscaled.png');
%regionGrowingImg = regionGrowing(scaledImg, 0, 1);
%figure, imshow(regionGrowingImg), title('Region Grown Image');
%//////////////////////////////////////////////////////////////////////////

%----Conected Component Labeling----
%
%the goal is to group all the regions so that we can single out the bigest
%ones representing our body of water
[label, N]=connected_component_labeling(~dilatedImg,8);
%imshow(label2rgb(label,'jet','k','shuffle'));


%Gettign the coordinates in order to visualise the data
imshow(img); hold on; 
try seed = ginput(1); % wait for one mouse click
catch
end
%Getting the max width of the river and a distance to edge at user coords
x=int16(seed(1));
y=int16(seed(2));
[maxDistance, dAtCords, riverSize, distances]=distance_transform(dilatedImg,label,N,x,y);
maxWIdth=2*maxDistance;

%coordinates of the pixel with the max width.
[xMax,yMax] = find(distances==maxDistance);
%Surface area of the river as numvber of pixels times spacial resolution of
%30m^2 per pixel
area=riverSize*30;

%formating the output:
p1 = [xMax,yMax-int16(maxDistance)];
p2 = [xMax,yMax+int16(maxDistance)];
text(10,20,['Total surface area of the river: ' num2str(area) ' m^2'],'color', 'yellow', 'FontSize',20);
plot([p1(2),p2(2)],[p1(1)+15,p2(1)],'Color','blue','LineWidth',1)
text(p1(2)-220,p1(1)+15,['Widest point: ' num2str(maxDistance*5.47) ' m'],'color', 'blue', 'FontSize',11);
text(x,y,['Width: ' num2str(dAtCords*2*5.47) ' m'],'color', 'red', 'FontSize',11);



































