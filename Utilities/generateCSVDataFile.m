luminanceLevels = [0.1:0.1:0.9];
NSamples = 1000;
NBackgorundSamplesPerImage = 5;
bScaling = true;
bMeanD65 = true;
bFixedIlluminant = false;

makeDataFileWithBackgroundOneIlluminant(NSamples, ... % NSamples
                    NBackgorundSamplesPerImage, ... % NBackgorundSamplesPerImage
                    '/Users/julian/Documents/masteringMachineLearning', ... % FolderName
                    ['lumLvl_',num2str(length(luminanceLevels)),'_NPerLvl_',num2str(NSamples),...
                    '_Back_',num2str(NBackgorundSamplesPerImage),'_ill_D65_Cov_1_Scale_1.csv'], ... % FileName
                    'luminanceLevels', luminanceLevels, ...
                    'bMeanD65', bMeanD65, ...
                    'covScaleFactor', 1, ...
                    'bFixedIlluminant', bFixedIlluminant, ... 
                    'bScaling', bScaling);

%%                
                
XYZLevels = repmat([0.1:0.1:0.8],3,1);
NSamples = 1000;
NBackgorundSamplesPerImage = 5;
bScaling = true;
bMeanD65 = false;
bFixedIlluminant = false;

makeDataFileWithBackgroundOneIlluminantXYZ(NSamples, ... % NSamples
                    NBackgorundSamplesPerImage, ... % NBackgorundSamplesPerImage
                    '/Users/julian/Documents/masteringMachineLearning', ... % FolderName
                    ['lumLvl_',num2str(length(XYZLevels)),'_NPerLvl_',num2str(NSamples),...
                    '_Back_',num2str(NBackgorundSamplesPerImage),'_ill_Rand_cov_1_scalingOn.csv'], ... % FileName
                    'XYZLevels', XYZLevels, ...
                    'bMeanD65', bMeanD65, ...
                    'covScaleFactor', 1, ...
                    'bFixedIlluminant', bFixedIlluminant, ... 
                    'bScaling', bScaling);              
                
                
                
                
                
                
                