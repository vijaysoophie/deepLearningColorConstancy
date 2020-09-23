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
clear;
luminanceLevels = [0.1:0.1:0.9];
NSamples = 1000;
NBackgorundSamplesPerImage = 5;
bScaling = true;
bMeanD65 = true;
bFixedIlluminant = false;

makeDataFileWithFixedBackgroundVariableIlluminant(NSamples, ... % NSamples
                    NBackgorundSamplesPerImage, ... % NBackgorundSamplesPerImage
                    '/Users/julian/Documents/masteringMachineLearning', ... % FolderName
                    ['lumLvl_',num2str(length(luminanceLevels)),'_NPerLvl_',num2str(NSamples),...
                    '_FixedBack_',num2str(NBackgorundSamplesPerImage),'_randIll_D65_Cov_1_Scale_0_1_to_0_001.csv'], ... % FileName
                    'luminanceLevels', luminanceLevels, ...
                    'bMeanD65', bMeanD65, ...
                    'covScaleFactor', 1, ...
                    'bFixedIlluminant', bFixedIlluminant, ... 
                    'bScaling', bScaling);
%%             

% B =
% 
%     0.5618   -0.3922    0.7284
%     0.6032   -0.4084   -0.6851
%     0.5662    0.8242    0.0072
% 
% cov_wgts
% 
% cov_wgts =
% 
%     0.1161    0.0000   -0.0000
%     0.0000    0.0135    0.0000
%    -0.0000    0.0000    0.0009
%%
clear;
XYZ_mean = [0.2836 0.2892 0.2574]';
vec1 = [0.0652    0.0700    0.0657]';
vec2 = [-0.0053   -0.0055    0.0111]';
vec3 = [0.0007   -0.0006    0.0000]';

XYZ = [];
for ii = -2:1:2
    for jj = -2:1:2
        for kk = -2:1:2
            XYZValue = XYZ_mean + ii*vec1 + jj*vec2 + kk*vec3;
            XYZ = [XYZ XYZValue];
        end
    end
end

               
%%
XYZLevels = XYZ;
NSamples = 1000;
NBackgorundSamplesPerImage = 5;
bScaling = false;
bMeanD65 = false;
bFixedIlluminant = false;

makeDataFileWithBackgroundOneIlluminantXYZ(NSamples, ... % NSamples
                    NBackgorundSamplesPerImage, ... % NBackgorundSamplesPerImage
                    '/Users/julian/Documents/masteringMachineLearning', ... % FolderName
                    ['lumLvl_',num2str(length(XYZLevels)),'_NPerLvl_',num2str(NSamples),...
                    '_Back_',num2str(NBackgorundSamplesPerImage),'_ill_Rand_cov_1_XYZ.csv'], ... % FileName
                    'XYZLevels', XYZLevels, ...
                    'bMeanD65', bMeanD65, ...
                    'covScaleFactor', 1, ...
                    'bFixedIlluminant', bFixedIlluminant, ... 
                    'bScaling', bScaling);              

%%
XYZLevels = XYZ;
NSamples = 100;
NBackgorundSamplesPerImage = 5;
bScaling = true;
bMeanD65 = false;
bFixedIlluminant = false;

makeDataFileWithFixedBackgroundOneIlluminantXYZ(NSamples, ... % NSamples
                    NBackgorundSamplesPerImage, ... % NBackgorundSamplesPerImage
                    '/Users/julian/Documents/masteringMachineLearning', ... % FolderName
                    ['lumLvl_',num2str(length(XYZLevels)),'_NPerLvl_',num2str(NSamples),...
                    '_FixedBack_',num2str(NBackgorundSamplesPerImage),'_ill_Rand_cov_1_XYZ.csv'], ... % FileName
                    'XYZLevels', XYZLevels, ...
                    'bMeanD65', bMeanD65, ...
                    'covScaleFactor', 1, ...
                    'bFixedIlluminant', bFixedIlluminant, ... 
                    'bScaling', bScaling);              
                                
%%                
clear;
HSV_mean = [0.4113    0.3858    0.6336]';
vec1 = [-0.1121    0.0024    0.0083]';
vec2 = [0.0015   -0.0349    0.0297]';
vec3 = [0.0025    0.0228    0.0266]';
   
HSV = [];                
for ii = [-3 0 3]
    for jj = [-3 0 3]
        for kk = [-3 0 3]
            HSVValue = HSV_mean + ii*vec1 + jj*vec2 + kk*vec3;
            HSV = [HSV HSVValue];
        end
    end
end

%%

HSVLevels = HSV;
NSamples = 10000;
NBackgorundSamplesPerImage = 5;
bScaling = false;
bMeanD65 = false;
bFixedIlluminant = false;

makeDataFileWithBackgroundOneIlluminantHSL(NSamples, ... % NSamples
                    NBackgorundSamplesPerImage, ... % NBackgorundSamplesPerImage
                    '/Users/julian/Documents/masteringMachineLearning', ... % FolderName
                    ['lumLvl_',num2str(length(HSVLevels)),'_NPerLvl_',num2str(NSamples),...
                    '_Back_',num2str(NBackgorundSamplesPerImage),'_ill_Rand_cov_1_HSV.csv'], ... % FileName
                    'HSVLevels', HSVLevels, ...
                    'bMeanD65', bMeanD65, ...
                    'covScaleFactor', 1, ...
                    'bFixedIlluminant', bFixedIlluminant, ... 
                    'bScaling', bScaling);              
                
%% 
% %%                
% Lab = [];                
% for L = [0.1 0.5 1.0]
%     for a = [0.2 0.6]
%         for b = [0.2 0.6]
%             Lab = [Lab [L;a;b]];
%         end
%     end
% end
% 
% %
% LabLevels = Lab;
% NSamples = 10;
% NBackgorundSamplesPerImage = 5;
% bScaling = false;
% bMeanD65 = false;
% bFixedIlluminant = true;
% 
% makeDataFileWithBackgroundOneIlluminantLab(NSamples, ... % NSamples
%                     NBackgorundSamplesPerImage, ... % NBackgorundSamplesPerImage
%                     '/Users/julian/Documents/masteringMachineLearning', ... % FolderName
%                     ['lumLvl_',num2str(length(LabLevels)),'_NPerLvl_',num2str(NSamples),...
%                     '_Back_',num2str(NBackgorundSamplesPerImage),'_ill_Rand_cov_1_Scaling_Lab.csv'], ... % FileName
%                     'LabLevels', LabLevels, ...
%                     'bMeanD65', bMeanD65, ...
%                     'covScaleFactor', 1, ...
%                     'bFixedIlluminant', bFixedIlluminant, ... 
%                     'bScaling', bScaling);              
%                 
                
                
                
                
                
                
                
                
                