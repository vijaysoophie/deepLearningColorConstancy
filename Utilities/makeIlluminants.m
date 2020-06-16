function newIlluminance = makeIlluminants(nNewIlluminaces, bMakeD65, varargin)
% makeIlluminants(nIlluminances, bMakeD65, varargin)
%
% Usage: 
%     makeIlluminants(0, 'covScaleFactor', 1)
%
% Description:
%   This function generates the illuminants for the base scenes. The
%   illuminace spectra are generated using the granada daylight library. We
%   first rescale each spectrum by the mean value of the spectrum over its 
%   wavelenght. Then we find the principal components of the rescaled 
%   spectrum. We choose the directions corresponding to the six largest 
%   eigenvalues. We sample new spectra from a multivariate random gaussian 
%   whose mean and variance correspond to the projection of the rescaled
%   spectra along the first six PCA directions. 
%   If the scaling option is 1, then each spectrum is scaled by the mean
%   spectrum value of a randomly sampled Granada spectrum.
%
% Input:
%   bMakeD65 = makes the mean value as D65
%
% April 12, 2018: VS wrote this
% June 12, 2020: VS modified this

parser = inputParser();
parser.addParameter('covScaleFactor', 1, @isnumeric);

parser.parse(varargin{:});
covScaleFactor = parser.Results.covScaleFactor;

% Desired wl sampling
rescaling = 1;  % O no rescaling
                % 1 rescaling

S = [400 5 61];
theWavelengths = SToWls(S);

%% Load Granada Illumimace data
pathToIlluminanceData = fullfile(fileparts(fileparts(mfilename('fullpath'))),'Data/IlluminantSpectra');
load(fullfile(pathToIlluminanceData,'daylightGranadaLong'));
daylightGranadaOriginal = SplineSrf(S_granada,daylightGranada,S);

load(fullfile(pathToIlluminanceData,'skylightGranada'));
skylightGranadaOriginal = SplineSrf(S_granada,skylightGranada,S);

daylightGranadaOriginal = [daylightGranadaOriginal skylightGranadaOriginal];
% Rescale spectrum by its mean
meanDaylightGranada = mean(daylightGranadaOriginal);
daylightGranadaRescaled = bsxfun(@rdivide,daylightGranadaOriginal,meanDaylightGranada);

% Center the data for PCA
if ~ rescaling 
    daylightGranadaRescaled = daylightGranadaOriginal;
end
meandaylightGranadaRescaled = mean(daylightGranadaRescaled,2);
daylightGranadaRescaledMeanSubtracted = bsxfun(@minus,daylightGranadaRescaled,meandaylightGranadaRescaled);

%% Analyze with respect to a linear model
B = FindLinMod(daylightGranadaRescaledMeanSubtracted,6);
ill_granada_wgts = B\daylightGranadaRescaledMeanSubtracted;
mean_wgts = mean(ill_granada_wgts,2);
cov_wgts = cov(ill_granada_wgts');
cov_wgts = cov_wgts*covScaleFactor;

%% Get D65
theIlluminantData = load('spd_D65');
D65Illuminant = SplineSpd(theIlluminantData.S_D65,theIlluminantData.spd_D65,theWavelengths);
D65Illuminant = D65Illuminant/mean(D65Illuminant);


%% Mean to be added
if (bMakeD65)
    meanIlluminant = D65Illuminant;
else
    meanIlluminant = meandaylightGranadaRescaled;
end

%% Generate an illuminant
newIlluminance = zeros(S(3),nNewIlluminaces);
newIndex = 1;

for i = 1:nNewIlluminaces
    OK = false;
    while (~OK)
        ran_wgts = mvnrnd(mean_wgts',cov_wgts)';
        ran_ill = B*ran_wgts + meanIlluminant;
        if (all(ran_ill >= 0))
            newIlluminance(:,newIndex) = ran_ill;
            newIndex = newIndex+1;
            OK = true;
        end        
    end
end

end