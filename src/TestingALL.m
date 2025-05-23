%This script represents the main testing script for running our program and
%for showcasing all the functions without the using the GUI.

%////////////////////MAIN CODE////////////////////////////

%The images are being loaded into appropriate arrays containing multiple images
%representing the time spam at which we want to examine the data. 
% 
% To select the diferent input data, simply un-comment the desired
% initialization of the input images


I=imread('Lago1.jpg');
[r,n,p]=size(I);
m=8;
Manifold=zeros(r,n,p,m);
for x=1:m
    filename=strcat('Lago',num2str(x),'.jpg');
    Manifold(:,:,:,x)=imread(filename);
end
imshow(Manifold(1));
%img=imread('LandsatInput6.png');
%img=imread('LandsatInput7.png');
%img=imread('LandsatInput8.png');
%imshow(img);

%----Creating a binary image using Otsu's threshold-----
otsuImg=otsu(img, 1);
imshow(otsuImg);

%------Apply the morphological operations------
%For this we use the disk-shape kernels since they tend to preserve the
%shape of rivers the best
%We apply erosion and dilation to remove any loose and stranded pixels that
%might be miss-enterpeted as a body of water or land
%
%NOTE: some of the images like LandsatInput2 will require larger kernels
%in order to get rid of unwanted artifacts that may be missenterpeted 
%as rivers/land.


erodElement = strel('disk',2);
erodedImg=morph_operation(otsuImg, 'erode',erodElement);
%figure,imshow(erodedImg);

dilationElement = strel('disk',3);
dilatedImg=morph_operation(erodedImg, 'dilate',dilationElement);
figure,imshow(dilatedImg), label('Dilated Image');

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
[label, N]=connected_component_labeling(~dilatedImg);
%[label]=bwlabel(~dilatedImg);

figure, imshow(label2rgb(label,'jet','k','shuffle'));


%Gettign the coordinates in order to visualise the data
imshow(img); hold on; 
try seed = ginput(1); % wait for one mouse click
catch
end
%Getting the max width of the river and a distance to edge at user coords
x=int16(seed(1));
y=int16(seed(2));
[maxDistance, dAtCords, riverSize, distances]=distance_transform(label,N,x,y);
maxWIdth=2*sqrt(maxDistance);

%coordinates of the pixel with the max width.
[point1X,point1Y,point2X,point2Y] = widthAtPoint(maxDistance, distances, ~dilatedImg);
%Surface area of the river as numvber of pixels times spacial resolution of
%30m^2 per pixel
area=riverSize*30;

%formating the output:
p1 = [point1X,point1Y];
p2 = [point2X,point2Y];
text(10,20,['Total surface area of the river: ' num2str(area) ' m^2'],'color', 'yellow', 'FontSize',20);
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','blue','LineWidth',1)
text(p1(2),p1(1),['Widest point: ' num2str(sqrt(maxDistance)*5.47) ' m'],'color', 'blue', 'FontSize',11);
text(x,y,['Width: ' num2str(dAtCords*2*5.47) ' m'],'color', 'red', 'FontSize',11);



































