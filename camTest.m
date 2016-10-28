cam = webcam(1);

I = snapshot(cam);

faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, I);
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
figure, imshow(IFaces), title('Detected faces');

clear cam;
