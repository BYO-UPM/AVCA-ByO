function mFeatures=MSVoice_avca(sFile)
% Calculates the modulation spectra features of the input audio file
% (sFile)

[vSignal, iFs]  = audioread( sFile );
vSignal=vSignal/max(abs(vSignal)); % Normalization

iMaxSec=1; % Limiting the signal to 3 s.
if length(vSignal)>iMaxSec*iFs
    iNewLength=iMaxSec*iFs;
    iBeginning=round((length(vSignal)-iNewLength)/2);
    vSignal=vSignal(iBeginning:iBeginning+iNewLength-1);
    
end

%% Parameters
sTipo='MCYFOPA'; % All features are calculated, using Hamming windowing
iSubMod=12;
iFrame=pow2(floor(log2(0.150*iFs))); % Default: 150 ms
iShift=floor(iFrame/2);
eOptions=[];
iVerbosity=0;

%% Norm
mFeatures = MS_features( vSignal, iFs, sTipo,...
    iSubMod, iFrame, iShift, eOptions, iVerbosity);
