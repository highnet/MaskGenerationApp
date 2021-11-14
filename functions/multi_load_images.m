function result = multi_load_images

dir = uigetdir;
ds = imageDatastore(dir);
numberOfImages = size(ds.Files);
numberOfImages = numberOfImages(1);

images = cell(1,numberOfImages);
a
i = 1;
while hasdata(ds)
    img = read(ds);
    images{1,i} = img;
    i = i + 1;
end
result = images;

end
