clear variables
close all
clc

<<<<<<< HEAD
%addpath(genpath('../../'))
%addpath(genpath('../../../libs'))
=======
addpath(genpath('../../'))
addpath(genpath('../../../libs'))
>>>>>>> parent of 46a192f (New functions to obtain feature statistics)

sDir = '../../Audios';
[vSignalNorm, iFs]  = audioread( fullfile( sDir, 'asra.wav' ) );
vSignalPath  = audioread( fullfile( sDir, 'cgra.wav' ) );
<<<<<<< HEAD

=======
>>>>>>> parent of 46a192f (New functions to obtain feature statistics)

%% Parameters
sTipo    = 'M';
iNumCoef = 12; 
iFrame   = pow2(floor(log2(0.03*iFs))); 
iSolape  = floor(iFrame/2); 
eOptions = []; 
iVerbosity = 0; 

%% Norm
% MFCC
mMFCCNorm = MFCCs( vSignalNorm, iFs, sTipo, iNumCoef, iFrame,...
    iSolape, eOptions, iVerbosity );
% PLP
mPLPsNorm = PLPs( vSignalNorm, iFs, sTipo, iNumCoef, iFrame,...
    iSolape, eOptions, iVerbosity );

%% Path
% MFCC
mMFCCPath = MFCCs( vSignalNorm, iFs, sTipo, iNumCoef, iFrame,...
    iSolape, eOptions, iVerbosity );
% PLP
mPLPsPath = PLPs( vSignalNorm, iFs, sTipo, iNumCoef, iFrame,...
    iSolape, eOptions, iVerbosity );