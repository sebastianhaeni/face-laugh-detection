clear all; clear clc; close all;

load('positiveInstances.mat')
positiveInstances = laugh_positive;

imDir = fullfile('images','smile');
addpath(imDir);

negativeFolder = fullfile('images','smile','negative');
negativeImages = imageDatastore(negativeFolder);

trainCascadeObjectDetector('laughDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5, 'FeatureType', 'Haar');

detector = vision.CascadeObjectDetector('laughDetector.xml');
img = imread('test_positive_3.jpg');

bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'laugh');
figure; imshow(detectedImg);
