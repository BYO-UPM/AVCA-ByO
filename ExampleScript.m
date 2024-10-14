
addpath(genpath('.'))
sLibrariesPath=''; % Add here the path to the libraries required to use AVCA
addpath(genpath(sLibrariesPath))

sFile='./Audios/asra.wav';

%% Obtaining statistics of the different features

%% Perturbation features
mFeaturesFl=PerturbationFluctuationVoice_avca(sFile);

%% Regularity features
mFeaturesReg=RegularityVoice_avca_stats (sFile);

%% Complexity features
mFeaturesNDA=NDAVoice_avca_stats(sFile);

%% Spectral and cepstral features
mFeaturesCeps= SpectralCesptralVoice_avca(sFile);

%% Modulation spectrum features
mFeaturesMS=MSVoice_avca(sFile); % The algorithm may provide NaNs when there is no voice signal (silences)

%% Single vector containing all features
vFeatures=[mFeaturesFl, mFeaturesReg, mFeaturesNDA...
    statsFeats(mFeaturesCeps), statsFeats(mFeaturesMS)];


%% Using a single function to obtain feature statistics

[ vFeatures, caNamesFeatures ] = AVCA_features_stat( sFile );



