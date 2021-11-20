% Returns a cell containing multiple images in a given system directory

% outputs: 
% result: A [1xN] cell of images, taken from a system directory as chosen by the user, where N is the number of images loaded

function result = multi_load_images

dir = uigetdir; % prompt the user for a system directory on their computer
ds = imageDatastore(dir); % create a image data store with their chosen directory
numberOfImages = size(ds.Files); % count how many images hav been loaded in to the data store 1/2
numberOfImages = numberOfImages(1); % count how many images hav been loaded in to the data store 2/2

images = cell(1,numberOfImages); % create an empty [1xN] cell, where N is the number of images loaded

i = 1; % iteration variable
while hasdata(ds) % while the data store has data
    img = read(ds); % get the next image
    images{1,i} = img; % store the image in the output cell
    i = i + 1; % increase the iteration variable
end
result = images; % return the images cell

end
