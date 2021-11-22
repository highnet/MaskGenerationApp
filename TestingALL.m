
img=imread('LandsatInput5.png');
grayscale=im2gray(img);

scaledImg=imread('LandsatInput5Downscaled.png');

%output: binary image with region growing applied
%Note: for now, a downscaled image is used, as the performance of the
%region growing algorithm has yet to be improved.
regionGrowingImg = regionGrowing(scaledImg, 0, 1);
imshow(regionGrowingImg);

%output: binary image with otsu applied
otsuImg=otsu(img, 1);
imshow(otsuImg);

%applying the morphological functions 
%///////////////////////////////////
openingElement = strel('disk',4);
openedImg=morph_operation(otsuImg, 'open',openingElement);

closingElement = strel('disk',4);
closedImg=morph_operation(otsuImg, 'close',closingElement);
%///////////////////////////////////


erodElement = strel('disk',3);
erodedImg=morph_operation(otsuImg, 'erode',erodElement);
%figure,imshow(erodedImg);

dilationElement = strel('disk',5);
dilatedImg=morph_operation(erodedImg, 'dilate',dilationElement);
figure,imshow(dilatedImg);

[label, N]=connected_component_labeling(~dilatedImg,8);

%imshow(label)


%finding the biggest region, the river
[r, c] = find(label==1);
maxRegion=[];
bigestN=1;
for n=1:N
    [r, c] = find(label==n);
    rc=[r c];
    maxRegion=cat(1, maxRegion, size(rc,1));
end

M = max(maxRegion(:));

for labelIndex=1:N
    if(maxRegion(labelIndex)==M)
        break;
    end
end
figure, imshow(label==labelIndex);



























