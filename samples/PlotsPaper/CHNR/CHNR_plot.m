clear variables
clc
close all

addpath( genpath( '../../../src' ) )
addpath( genpath( '../../../External Toolboxes' ) )

sDir = '../../../Audios';

% [vSignalNorm, iFs]  = audioread( fullfile( sDir, '1-a_n.wav' ) );
% vSignalPath  = audioread( fullfile( sDir, '1424-a_n.wav' ) );

[vSignalNorm, iFs]  = audioread( fullfile( sDir, 'asra.wav' ) );
vSignalNorm = normalize( vSignalNorm, 'zscore' );

vSignalPath  = audioread( fullfile( sDir, 'cgra.wav' ) );
vSignalPath = normalize( vSignalPath, 'zscore' );

iFrame  = ceil( 40e-3*iFs );
iSolape = ceil( 0.5*iFrame );
sTipo = 'R';

xLab    = 'Frequency (kHz)'; 
yLab    = 'Magnitude (dB)'; 

titulo  = '';
axisIn  = [0 12 -3 3];
lineW   = 3;
fontS   = 35;

%% Norm
mSignal = enframe( vSignalNorm, hamming( iFrame ), iSolape );

i = 3;
vFrame = mSignal(i,:);
CHNRi( vFrame, iFs )

name = 'CHNR_Norm'; 
Graficador( name, xLab, yLab, titulo, axisIn, lineW, fontS )

%% Path
mSignal = enframe( vSignalPath, hamming( iFrame ), iSolape );

i = 10;
vFrame = mSignal(i,:);
CHNRi( vFrame, iFs )

name = 'CHNR_Path'; 
Graficador( name, xLab, yLab, titulo, axisIn, lineW, fontS )