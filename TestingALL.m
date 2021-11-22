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

%----Conversion to the grayscale image----
grayscale=im2gray(img);

%----Creating a set of binary images using Otsu's threshold-----
otsuImg=otsu(img, 1);
imshow(otsuImg);

%------Apply the morphological operations------
%For this we use the disk-shape kernels since they tend to preserve the
%shape of rivers the best
%We apply erosion and dilation to remove any loose and stranded pixels that
%might be miss-enterpeted as a body of water or land

erodElement = strel('disk',3);
erodedImg=morph_operation(otsuImg, 'erode',erodElement);
%figure,imshow(erodedImg);

dilationElement = strel('disk',5);
dilatedImg=morph_operation(erodedImg, 'dilate',dilationElement);
figure,imshow(dilatedImg);

%----Conected Component Labeling----
%
%the goal is to group all the regions so that we can single out the bigest
%ones representing our body of water
[label, N]=connected_component_labeling(~dilatedImg,8);

%Gettign the coordinates in order to visualise the data
imshow(img); 
try seed = ginput(1); % wait for one mouse click
catch
end
%Getting the max width of the river and a distance to edge at user coords
imshow(label);
x=int16(seed(1));
y=int16(seed(2));
[maxDistance, dAtCords]=distance_transform(img,label,N,x,y);

maxWIdth=2*maxDistance;



























