function [traptemplate,rect] = definetrap(image)
    image = im2double(image);
    level = graythresh(image);
    figure();
    imshow(image<level*0.95);
     imshow(image<level*1.05);
    [traptemplate,rect] = imcrop()
end
