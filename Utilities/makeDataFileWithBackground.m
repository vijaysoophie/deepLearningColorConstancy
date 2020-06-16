function makeDataFileWithBackground(luminanceLevels, nSamples, nBackGroundSamples, folderToStore, fileName)
% makeDataFileWithBackground([0.1:0.1:0.9], 1000, 5, pwd, 'test.csv')
%
% Usage: 
%     makeDataFileWithBackground([0.1:0.1:0.9], 1000, 5, pwd, 'test.csv')
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

% Desired wl sampling
S = [400 5 61];
theWavelengths = SToWls(S);

nSurfaceAtEachLuminace = nSamples;
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

%% Load in a standard daylight as our reference spectrum
%
% We'll scale this so that it has a luminance of 1, to help us think
% clearly about the scale of reference luminances we are interested in
% studying.
theIlluminantData = load('spd_D65');
theIlluminant = SplineSpd(theIlluminantData.S_D65,theIlluminantData.spd_D65,theWavelengths);
theIlluminant = theIlluminant/(theLuminanceSensitivity(2,:)*theIlluminant);

%% Generate new surfaces
if ~exist(folderToStore)
    mkdir(folderToStore);
end

fid = fopen(fullfile(folderToStore,fileName),'w');

m=0;
for ii = 1:(size(luminanceLevels,2)*nSurfaceAtEachLuminace)
    m=m+1;
    OK = false;
    while (~OK)
        ran_wgts = mvnrnd(mean_wgts',cov_wgts)';
        theReflectance = B*ran_wgts+sur_mean;
        theLightToEye = theIlluminant.*theReflectance;
        theTargetXYZ = theLuminanceSensitivity*theLightToEye;
        theLuminanceTarget = luminanceLevels(ceil(ii/nSurfaceAtEachLuminace));
        scaleFactor = theLuminanceTarget / theTargetXYZ(2);
        theReflectanceScaled = scaleFactor * theReflectance;
        if (all(theReflectanceScaled >= 0) & all(theReflectanceScaled <= 1))
            OK = true;
        end
        theLightToEye = theIlluminant.*theReflectanceScaled;
        theTargetXYZ = theLuminanceSensitivity*theLightToEye;
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
	theLightToEye = theIlluminant.*newSurfaces;
    otherObjectXYZ = theLuminanceSensitivity*theLightToEye;

    fprintf(fid,'%3.6f %3.6f %3.6f ',theTargetXYZ);
    for jj = 1:nBackGroundSamples
        fprintf(fid,'%3.6f %3.6f %3.6f ',otherObjectXYZ(:,jj)');
    end
    fprintf(fid,'%3.6f\n', ceil(ii/nSurfaceAtEachLuminace));
    
    if (m==numel(nSamples)) m=0; end    
end
fclose(fid);
