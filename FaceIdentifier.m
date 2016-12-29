clear all; close all; clc; %clear matrices, close figures & clear cmd wnd.

% filename = '/Users/rlaubscher/Dropbox/BFH/CPVR2-3-CP/Exercises/Images/cpvr_faces_160/0000/01.JPG';

for f=1:13
searchFacePath = sprintf('./images/search/%d.png', f);
SI = imread(searchFacePath);
SI = imresize(SI, [160 120], 'bilinear');
searchFace = rgb2gray(SI);
searchFace = double(searchFace)/255; % matrix
meanSearch = mean2(searchFace); % number
% searchFace = searchFace - meanSearch + 0.5;
% figure;
% figure('Color',[1 1 1]);
subplot(3, 3, 2);
imshow(searchFace);
title('Search Face');
pause;

%% Step 1: Load face images & convert each image into a vector of a matrix
k = 0;
for i=23:1:36
    for j=1:1:10
        filename  = sprintf('./images/cpvr_faces_160/00%2.2d/%2.2d.JPG',i,j);
        I = imread(filename);
        image_data = rgb2gray(I);
        image_data = double(image_data)/255;
        meanImg = mean2(image_data);
        image_data = image_data + (meanSearch - meanImg);
%         image_data = imhistmatch(image_data, searchFace);
        %         imshow(image_data);
        %         pause;
        k = k + 1;
        faces(:,k) = image_data(:);
    end;
end;
nImages = k;                     %total number of images
imsize = size(image_data);       %size of image (they all should have the same size)
nPixels = imsize(1)*imsize(2);   %number of pixels in image
% faces = double(faces)/255;       %convert to double and normalize

%% Step 2: Calculate & show the mean image and shift all faces by it
mn = mean(faces, 2);
for i=1:nImages
    faces(:,i) = faces(:,i)-mn;          % substruct the mean
end;
% figure('Color',[1 1 1]);
% imshow(reshape(mn, imsize)); title('mean face');
% pause;

%% Step 3: Calculate Eigenvectors & Eigenvalues
% Create covariance matrix faster by using
% Turk and Pentland's trick to get the eigenvectors of faces*faces' from
% the eigenvectors of faces'*faces
% tic;
C = faces'*faces;
[eigvec,eigval] = eig(C);
eigvec = faces * eigvec;                        % Convert eigenvectors back as if they came from A'*A
eigvec = eigvec / (sqrt(abs(eigval)));          % Normalize eigenvectors
% eigvec & eigval are in fact sorted but in the wrong order
eigval = diag(eigval);                          % Get the eigenvalue from the diagonal
eigval = eigval / nImages;                      % Normalize eigenvalues
[eigval, indices] = sort(eigval, 'descend');    % Sort the eigenvalues
eigvec = eigvec(:, indices);                    % Sort the eigenvectors accordingly
% toc;

% Display the 10 first eigenvectors as eigenfaces
% figure('Color',[1 1 1]);
% for n = 1:10
%     subplot(4, 3, n);
%     eigvecImg = reshape(eigvec(:,n), imsize);   % Reshape vector to image
%     imshow(eigvecImg, []);                      % Show eigenface image with max. contrast
% end
% pause;
%% Step 4: Transform the mean shifted faces into the faces2 space

%########################
faces2 = eigvec' * faces;
%########################

%% Step 6: Select an face to search in the PC space
% i = 41;                                         %index of face to be searched
% searchFace = reshape(mn+faces(:,i), imsize);    %reshape from vector image

search = eigvec' * (searchFace(:) - mn);        %transform into PC space

% Calculate the squared euclidean distances to all faces in the PC space
% We use the dot product to square the vector difference.
for i=1:nImages
    distPC(i) = dot(faces2(:,i)-search, faces2(:,i)-search);
end;

% Sort the distances and show the nearest 14 faces
[sortedDistPC, sortIndex] = sort(distPC); % sort distances
% figure('Color',[1 1 1]);
for i=1:6
    subplot(3,3,i+3);
    imshow((reshape(mn+faces(:,sortIndex(i)), imsize)));
    %     winner = floor(sortIndex(i) / 10) + 23;
    winner = sortIndex(i);
    winner = floor(winner / 10) + 23;
    title(sprintf('Dist=%2.2f, index %d',sortedDistPC(i), winner));
end;
pause;
end;