clear variables
close all
clc

addpath(genpath('../../'))
%addpath(genpath('../../../libs'))

%sDir = '../../Audios';
%[vSignalNorm, iFs]  = audioread( fullfile( sDir, 'asra.wav' ) );
%vSignalPath  = audioread( fullfile( sDir, 'cgra.wav' ) );

sFile1='VA1lbuairgo52M1606161813.wav';
sFile2='PD_A1_0009.wav';

[vSignalNorm, iFs]  = audioread( sFile1 );
vSignalPath  = audioread( sFile2 );

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