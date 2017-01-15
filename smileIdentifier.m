clear all; close all; clc; %clear matrices, close figures & clear cmd wnd.

% filename = './images/mouth/positive/scaled/1.jpg';
% filename = './images/mouth/positive/scaled/2.jpg';
% filename = './images/mouth/positive/scaled/3.jpg';

% filename = './images/mouth/negative/scaled/1.jpg';
% filename = './images/mouth/negative/scaled/2.jpg';
% filename = './images/mouth/negative/scaled/3.jpg';

% filename = './images/mouth/test/no-smile1.jpg';
filename = './images/mouth/test/smile5.jpg';

SI = imread(filename);
searchMouth = double(SI)/255;
% subplot(3, 3, 2);
imshow(searchMouth);
title('Search Image');
pause;

%% Step 1: Load mouth images & convert each image into a vector of a matrix
k = 0;
for i=4:14
    filename  = sprintf('./images/mouth/positive/scaled/%d.jpg',i);
    I = imread(filename);
    image_data = double(I)/255;
    k = k + 1;
    mouth(:,k) = image_data(:);
end;
for i=4:44
    filename  = sprintf('./images/mouth/negative/scaled/%d.jpg',i);
    I = imread(filename);
    image_data = double(I)/255;
    k = k + 1;
    mouth(:,k) = image_data(:);
end;
nImages = k;
imsize = size(image_data);
nPixels = imsize(1)*imsize(2);

%% Step 2: Calculate the mean image and shift all mouth by it
mn = mean(mouth, 2);
for i=1:nImages
    mouth(:,i) = mouth(:,i)-mn;          % substruct the mean
end;
 figure('Color',[1 1 1]);
 imshow(reshape(mn, imsize)); title('mean mouth');
 pause;

%% Step 3: Calculate Eigenvectors & Eigenvalues
% Create covariance matrix faster by using
% Turk and Pentland's trick to get the eigenvectors of mouth*mouth' from
% the eigenvectors of mouth'*mouth
% tic;
C = mouth'*mouth;
[eigvec,eigval] = eig(C);
eigvec = mouth * eigvec;                        % Convert eigenvectors back as if they came from A'*A
eigvec = eigvec / (sqrt(abs(eigval)));          % Normalize eigenvectors
% eigvec & eigval are in fact sorted but in the wrong order
eigval = diag(eigval);                          % Get the eigenvalue from the diagonal
eigval = eigval / nImages;                      % Normalize eigenvalues
[eigval, indices] = sort(eigval, 'descend');    % Sort the eigenvalues
eigvec = eigvec(:, indices);                    % Sort the eigenvectors accordingly
% toc;

% Display the 10 first eigenvectors as eigenmouth
 figure('Color',[1 1 1]);
 for n = 1:10
     subplot(4, 3, n);
     eigvecImg = reshape(eigvec(:,n), imsize);   % Reshape vector to image
     imshow(eigvecImg, []);                      % Show eigenmouth image with max. contrast
 end
 pause;
%% Step 4: Transform the mean shifted mouth into the mouth2 space

mouth2 = eigvec' * mouth;

%% Step 5: Select a mouth to search in the PC space
search = eigvec' * (searchMouth(:) - mn);        %transform into PC space

% Calculate the squared euclidean distances to all mouth in the PC space
% We use the dot product to square the vector difference.
for i=1:nImages
    distPC(i) = dot(mouth2(:,i)-search, mouth2(:,i)-search);
end;

% Sort the distances
[sortedDistPC, sortIndex] = sort(distPC); % sort distances

% Add up to get the probability
smile = 0;
n = 10;
for i=1:n
    index = sortIndex(i);
    if index <= 11
        smile = smile + 1;
    end
end;
pSmile = smile / n;

title(sprintf('Smile probability: %1.1f', pSmile));
