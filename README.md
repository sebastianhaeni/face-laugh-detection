# Laugh detection with Matlab

## Instructions

* `demo.m` takes an image using your webcam and tells you if your smiling.
* `mouthDetector.m` searches for a mouth. Shows some approches for feature extraction and segmentation (local threshold).
* `mouthExport.m` Finds mouth and exports its image as black & white. Can be later classified using `smileIdentifier.m`.
* `smileIdentifier.m` Classify mouth / smile using Principal Component Analysis.
* `FaceFinder.m` Example for finding faces using skin tone segmentation.
