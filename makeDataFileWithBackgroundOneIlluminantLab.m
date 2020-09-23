function makeDataFileWithBackgroundOneIlluminantLab(nSamples, nBackGroundSamples, folderToStore, fileName, varargin)
% makeDataFileWithBackgroundOneIlluminant(luminanceLevels, nSamples, nBackGroundSamples, folderToStore, fileName, varargin)
%
% Usage:
%     makeDataFileWithBackgroundOneIlluminant([0.1:0.1:0.9], 1000, 5, pwd, 'test.csv')
%
% Description:
%    This function makes the data file for deep learning. It
%    generates random surfaces at fixed luminance levels and then stores
%    the value of the XYZ and luminance levels in a data file.
%
%    The spectrum are generated using the nickerson and the
%    vrhel libraries. These libraries should be a part of
%    RenderToolbox. To generate the spectra, we first find out the pricipal
%    components of the spectra in the library. Then we choose the
%    directions corresponding to the largest six eigenvalues. We project
%    the spectra along these six directions and find out the mean and the
%    variance of this distribution. These are then used along with a
%    multinormal random distribution to generate new random spectra. The
%    new spectra are scaled such that the luminance equals the desired
%    luminance levels. Finally, we make sure that the reflectance spectra
%    values are between 0 and 1 at all frequencies.
%
% Input:
%   luminanceLevels = luminance levels for which the spectra are generated
%   nSamples = number of samples at each luminance level
%   nBackGroundSamples = number of samples of background object reflectance
%   folderToStore = folder to store
%   fileName = file name
%
% 6/09/2020  vs, vs  Wrote it.


parser = inputParser();
parser.addParameter('LabLevels', [0.1; 0.1; 0.2], @isnumeric);
parser.addParameter('covScaleFactor', 1, @isnumeric);
parser.addParameter('bMeanD65', 1, @islogical);
parser.addParameter('bFixedIlluminant', 1, @islogical);
parser.addParameter('bScaling', 1, @islogical);

parser.parse(varargin{:});
LabLevels = parser.Results.LabLevels;
covScaleFactor = parser.Results.covScaleFactor;
bMeanD65 = parser.Results.bMeanD65;
bFixedIlluminant = parser.Results.bFixedIlluminant;
bScaling = parser.Results.bScaling;

%%
% Desired wl sampling
S = [400 5 61];
theWavelengths = SToWls(S);

nsurfacePerXYZ = nSamples;
%% Load surfaces
%
% These are in the Psychtoolbox.

% Munsell surfaces
load sur_nickerson
sur_nickerson = SplineSrf(S_nickerson,sur_nickerson,S);

% Vhrel surfaces
load sur_vrhel
sur_vrhel = SplineSrf(S_vrhel,sur_vrhel,S);

% Put them together
sur_all = [sur_nickerson sur_vrhel];

sur_mean=mean(sur_all,2);
sur_all_mean_centered = bsxfun(@minus,sur_all,sur_mean);

%% Analyze with respect to a linear model
B = FindLinMod(sur_all_mean_centered,6);
sur_all_wgts = B\sur_all_mean_centered;
mean_wgts = mean(sur_all_wgts,2);
cov_wgts = cov(sur_all_wgts');

%% Load in spectral weighting function for luminance
% This is the 1931 CIE standard
theXYZData = load('T_xyz1931');
theLuminanceSensitivity = SplineCmf(theXYZData.S_xyz1931,theXYZData.T_xyz1931,theWavelengths);

% % This is the human cone response accounting for transmittance
% humanConeMosaic = coneMosaic;
% SHumanConeMosaic = [humanConeMosaic.wave(1) diff(humanConeMosaic.wave(1:2)) length(humanConeMosaic.wave)];
% theLuminanceSensitivity = SplineCmf(SHumanConeMosaic,humanConeMosaic.qe',theWavelengths);
%
% lensTransmittance = Lens().transmittance;
% lensTransmittance = SplineCmf(SHumanConeMosaic,lensTransmittance',theWavelengths);
% theLuminanceSensitivity = bsxfun(@times, theLuminanceSensitivity, lensTransmittance);
% scalarsToEqualizeCornealQuantalEfficiencies = 1./sum(theLuminanceSensitivity, 2);
% scalarsToEqualizeCornealQuantalEfficiencies = scalarsToEqualizeCornealQuantalEfficiencies / scalarsToEqualizeCornealQuantalEfficiencies(1);
% theLuminanceSensitivity = bsxfun(@times,theLuminanceSensitivity,scalarsToEqualizeCornealQuantalEfficiencies);

%% Load in a standard daylight as our reference spectrum
%
% We'll scale this so that it has a luminance of 1, to help us think
% clearly about the scale of reference luminances we are interested in
% studying.
theIlluminantData = load('spd_D65');
theIlluminant = SplineSpd(theIlluminantData.S_D65,theIlluminantData.spd_D65,theWavelengths);
theIlluminant = theIlluminant/(theLuminanceSensitivity(2,:)*theIlluminant);

%% Get the null space
nullSpace = null(theLuminanceSensitivity*diag(theIlluminant)*B);


%% Make illuminants
totalIlls = nSamples*size(LabLevels,2);

if bMeanD65
    newIlluminant = makeIlluminants(1, 1, 'covScaleFactor', covScaleFactor);
else
    newIlluminant = makeIlluminants(1, 0, 'covScaleFactor', covScaleFactor);
end
scale = 1;
newIlluminant = repmat(newIlluminant,1,totalIlls);

if ~bFixedIlluminant
    if bMeanD65
        newIlluminant = makeIlluminants(totalIlls, 1, 'covScaleFactor', covScaleFactor);
    else
        newIlluminant = makeIlluminants(totalIlls, 0, 'covScaleFactor', covScaleFactor);
    end
end


%% Generate new surfaces
if ~exist(folderToStore)
    mkdir(folderToStore);
end

fid = fopen(fullfile(folderToStore,fileName),'w');

for ii = 1:size(LabLevels,2)

    XYZLevel = LabToXYZ(LabLevels(:,ii), whitepoint('D65')');
    m=0;    
    ww(:,ii) = (theLuminanceSensitivity*diag(theIlluminant)*B)\...
        (XYZLevel - theLuminanceSensitivity*diag(theIlluminant)*sur_mean);
    
    while (m < nsurfacePerXYZ)
        m=m+1;
        OK = false;
        while (~OK)
            newWeights = ww(:,ii) + nullSpace*(0.95*norm(ww(:,ii)))*rand(3,1);
            theReflectanceScaled = B*newWeights+sur_mean;
            if (all(theReflectanceScaled >= 0) & all(theReflectanceScaled <= 1))
                OK = true;
            end
        end
        
        % Make backgorund object reflectances
        newIndex = 1;
        for jj = 1:nBackGroundSamples
            OK = false;
            while (~OK)
                ran_wgts = mvnrnd(mean_wgts',cov_wgts)';
                ran_sur = B*ran_wgts+sur_mean;
                if (all(ran_sur >= 0) & all(ran_sur <= 1))
                    newSurfaces(:,newIndex) = ran_sur;
                    newIndex = newIndex+1;
                    OK = true;
                end
            end
        end
        
        if bScaling
            scale = generateLogUniformScales(1, 0.001, 1);
        end
        
        theLightToEye = (scale*newIlluminant(:,(ii-1)*nsurfacePerXYZ + m)).*theReflectanceScaled;
        theTargetXYZ = theLuminanceSensitivity*theLightToEye;
        theTargetLab = LabToXYZ(theTargetXYZ, whitepoint('D65')');
        
        theLightToEye = (scale*newIlluminant(:,(ii-1)*nsurfacePerXYZ + m)).*newSurfaces;
        otherObjectXYZ = theLuminanceSensitivity*theLightToEye;
        otherObjectLab = LabToXYZ(otherObjectXYZ, whitepoint('D65')');
        
        fprintf(fid,'%3.6f %3.6f %3.6f ', theTargetLab);
        for jj = 1:nBackGroundSamples
            fprintf(fid,'%3.6f %3.6f %3.6f ', otherObjectLab(:,jj)');
        end
        fprintf(fid,'%3.6f\n', ii);
    end
end
fclose(fid);
