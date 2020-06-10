% deepLearningColorConstancyLocalHook
%
% Set up machine specific prefs for the deepLearningColorConstancy project.
%
% The goal of this project is to create a simple virtual world, so
% that we can start playing with AMA analysis using it. 

%
% 2/10/16  vs, dhb   Wrote it.

%% Set up some parameters for portability
projectName = 'deepLearningColorConstancy';

%% Where does output go
% 
% The default for output if you are not a recognized user is in a subdir
% called output/deepLearningColorConstancy of what is returned by
% rtbGetUserFolder, which itself is configured as part of setting up
% RenderToolbox (there is a default if you don't do anything.)
%
% You may want to change this to be wherever you want the potentially big
% pile of output to end up.
%
% We make an attempt below to do sensible things for users/machines we know
% about before dropping to the default
[~,computerName] = system('hostname');
computerName = strtrim(computerName);
[~, userID] = system('whoami');
userID = strtrim(userID);
switch (computerName)
    case 'eagleray.psych.upenn.edu'
        switch userID
            case {'dhb'}
                dataDirRoot = ['/Users1/' '/Dropbox (Aguirre-Brainard Lab)/IBIO_Analysis'];
            otherwise
                dataDirRoot = fullfile(rtbGetUserFolder(), 'output');
        end
    case 'stingray.psych.upenn.edu'
        switch userID
            case{'vsin'}
                dataDirRoot = ['/Users/vsin/' 'Dropbox (Aguirre-Brainard Lab)/IBIO_analysis'];
            otherwise
                dataDirRoot = fullfile(rtbGetUserFolder(), 'output');
        end            
    otherwise
        dataDirRoot = fullfile(rtbGetUserFolder(), 'output');    
end

dataDirName = 'deepLearningColorConstancy';
dataDir = fullfile(dataDirRoot,projectName,'');
if (~exist(dataDir,'dir'))
    mkdir(dataDir);
end
setpref(projectName, 'baseFolder',dataDir);
