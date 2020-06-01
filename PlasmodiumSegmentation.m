clear all;
close all;
clc;

datasetDirInfo = 'D:\Rezqy\Kuliah\Kuliah\Semester 6\TPC\Tugas Akhir\Plasmodium\Example\Data';
groundTruthDirInfo = 'D:\Rezqy\Kuliah\Kuliah\Semester 6\TPC\Tugas Akhir\Plasmodium\Example\Ground truth';


baseFileName = 'FG(2).png';
fullFileName = fullfile(datasetDirInfo, baseFileName);

B = imread(fullfile(groundTruthDirInfo, baseFileName));

rgbImage = imread(fullFileName);


%figure;
%imshow(hsvImage);
%% RGB to HSV
hsvImage = rgb2hsv(rgbImage);


H = hsvImage(:,:,1);
S = hsvImage(:,:,2);
V = hsvImage(:,:,3);

%% Segmentation
level = multithresh(S,2);
segmentedImage = imquantize(S,level);

binaryImage = logical(mod(imquantize(S,level(2)),2));
binaryImage = imcomplement(binaryImage);
Open = bwareaopen(binaryImage, 3000);
Open = Open - bwareaopen(Open, 5000);

se = strel('disk',40);
out = imclose(Open,se);
    
%% Evaluation Method
A = out;

if(isa(A,'logical'))
    X = A;
else
    X = logical(A);
end
if(isa(B,'logical'))
    Y = B;
else
    Y = logical(B);
end

% Evaluate TP, TN, FP, FN
sumindex = X + Y;
TP = length(find(sumindex == 2));
TN = length(find(sumindex == 0));
substractindex = X - Y;
FP = length(find(substractindex == 1));
FN = length(find(substractindex == -1));
Accuracy = (TP+TN)/(FN+FP+TP+TN)
Sensitivity = TP/(TP+FN)
Specitivity = TN/(TN+FP)

%% Figure
figure;
subplot(3,2,1);
imshow(rgbImage);
title('RGB');

subplot(3,2,2);
imshow(hsvImage);
title('HSV');

subplot(3,2,3);
imshow(S);
title('S');

subplot(3,2,4);
imshow(segmentedImage,[]);
title('Segmented');

subplot(3,2,5);
imshow(binaryImage,[]);
title('Segmented');

subplot(3,2,6);
imshow(out,[]);
title('OUTPUT');

figure;
subplot(1,3,1);
imshow(rgbImage);
title('RGB','FontSize',14);

subplot(1,3,2);
imshow(B);
title('Ground Truth','FontSize',14);

subplot(1,3,3);
imshow(out,[]);
title('SEGEMENTED','FontSize',14);
