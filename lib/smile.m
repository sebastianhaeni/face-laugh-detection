function [ S ] = smile( MOUTH )
%SMILE Returns the probablity the given MOUTH is smiling.

searchMouth = rgb2gray(MOUTH);
searchMouth = histeq(searchMouth);
searchMouth = imresize(searchMouth, [70 115]);
searchMouth = double(searchMouth) / 255;

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

%% Step 2: Calculate the mean image and shift all mouth by it
mn = mean(mouth, 2);
for i=1:nImages
    mouth(:,i) = mouth(:,i)-mn;          % substruct the mean
end;

%% Step 3: Calculate Eigenvectors & Eigenvalues
% Create covariance matrix faster by using
% Turk and Pentland's trick to get the eigenvectors of mouth*mouth' from
% the eigenvectors of mouth'*mouth
C = mouth' * mouth;
[eigvec, eigval] = eig(C);
eigvec = mouth * eigvec;                        % Convert eigenvectors back as if they came from A'*A
eigvec = eigvec / (sqrt(abs(eigval)));          % Normalize eigenvectors
% eigvec & eigval are in fact sorted but in the wrong order
eigval = diag(eigval);                          % Get the eigenvalue from the diagonal
eigval = eigval / nImages;                      % Normalize eigenvalues
[~, indices] = sort(eigval, 'descend');         % Sort the eigenvalues
eigvec = eigvec(:, indices);                    % Sort the eigenvectors accordingly

%% Step 4: Transform the mean shifted mouth into the mouth2 space
mouth2 = eigvec' * mouth;

%% Step 5: Select a mouth to search in the PC space
search = eigvec' * (searchMouth(:) - mn);        %transform into PC space

% Calculate the squared euclidean distances to all mouths in the PC space
% We use the dot product to square the vector difference.
for i = 1:nImages
    distPC(i) = dot(mouth2(:, i) - search, mouth2(:, i) - search);
end;

% Sort the distances
[~, sortIndex] = sort(distPC); % sort distances

smile = 0;
n = 6;
for i = 1:n
    index = sortIndex(i);
    if index <= 11
        smile = smile + 1;
    end
end;

S = smile / n;

end

