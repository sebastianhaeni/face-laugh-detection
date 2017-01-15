function result = local_threshold(image)
% variables
window = [15 15];
T = 10;
padding = 'replicate';

image = double(image);
mean = averagefilter(image, window, padding);

result = true(size(image));
% apply threshold, set black pixels
condition = image <= mean*(1-T/100);
result(condition) = 0;

