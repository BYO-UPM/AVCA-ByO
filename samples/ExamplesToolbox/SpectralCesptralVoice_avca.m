function mFeatures = SpectralCesptralVoice_avca (sFile)
% Calculates the spectral and cepstral features of the input audio file
% (sFile)
[vSignal, iFs]  = audioread( sFile );
vSignal=vSignal/max(abs(vSignal)); % Normalization

%% Parameters
sTipo    = 'MdD'; % includes derivatives
iNumCoef = 12; 
iFrame   = pow2(floor(log2(0.02*iFs))); 
iSolape  = floor(iFrame/2); 
eOptions = []; 
iVerbosity = 0; 

% MFCC
mMFCC = MFCCs( vSignal, iFs, sTipo, iNumCoef, iFrame,...
    iSolape, eOptions, iVerbosity );
mMFCC=Derivate( mMFCC,'dD' );

% PLP
mPLP = PLPs( vSignal, iFs, sTipo, iNumCoef, iFrame,...
    iSolape, eOptions, iVerbosity );
mPLP = Derivate( mPLP','dD' );

mFeatures=[mMFCC, mPLP];
