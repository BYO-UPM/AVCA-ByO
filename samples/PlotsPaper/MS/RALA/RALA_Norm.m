clear variables
close all
clc

addpath( '../../' )
addpath( genpath( '../../../../src' ) )
addpath( genpath( '../../../../External Toolboxes' ) )

sDir = '../../../../Audios';

% [vSignalNorm, iFs]  = audioread( fullfile( sDir, '1-a_n.wav' ) );
[vSignalNorm, iFs]  = audioread( fullfile( sDir, 'asra.wav' ) );

vSignalNorm = normalize( vSignalNorm, 'zscore' );

%Parametros Ventana
iTraslape = 0.5;
iFrame    = ceil( 180e-3*iFs );
iSolape   = ceil( iTraslape*iFrame );

%Procesado
sModoPrep = 'nHQ';
sModoPost = 'XCFPA';
%Centroids (normalized respecting the first centroid),
%Contrast & Homogeneity and Histogram parameters

%Parametros EMod
eOptions.EMiFmodMax=200;
iNumParam  = 12;
iVerbosity = 0;

%% Calculation of parameters
[ ~, eParIntermedios ] = ...
    EM( vSignalNorm, iFs, sModoPost, iNumParam, iFrame, iSolape, eOptions, iVerbosity );

eParIntermedios.sNombre =  '';
ePar.ePar = eParIntermedios;
[mParametros] = EM_ePar( ePar, vSignalNorm, sModoPost, iNumParam, eOptions, iVerbosity);

idx = 13;

temp = 20*log10( fftshift( abs( eParIntermedios.vmMS(:,:,idx) ), 2 ) );
figure
if 	~all( diff( eParIntermedios.vAf ) == min( diff( eParIntermedios.vAf ) ) )
    % This is the case where the subband center frequencies are
    % non-uniformly spaced. The following code interpolates P along the
    % acoustic-frequency axis using a base granularity set by STEPSIZE.
    % As a result the modulation spectra of broad subbands will appear
    % as thicker rows in the displayed joint-frequency plot.
    stepsize = min( 50, min( diff( eParIntermedios.vAf ) / 2 ) );
    afreqs2 = eParIntermedios.vAf(1):stepsize:eParIntermedios.vAf(end);
    temp = interp1( eParIntermedios.vAf, temp, afreqs2, 'nearest' );
    %% Para graficar RALA
    temp2 = temp;
    %         temp2( temp<= mean( temp(:) ) ) = 0;
    temp2( temp> mean( temp(:) ) ) = 1;
    imagesc( eParIntermedios.vMf - eParIntermedios.data.modfs/2, afreqs2, temp2 );
    map = [ 1, 1, 1; 0 0 0 ];
    colormap( map )
else
    % Uniformly-spaced subbands are much easier to plot.
    imagesc( mfreqs - eParIntermedios.data.modfs/2, eParIntermedios.vAf, temp );
end

if strcmpi( eParIntermedios.data.demodparams{1}, 'harm' ) ||...
        strcmpi( eParIntermedios.data.demodparams{1}, 'harmcog' )
    axislabel = 'Harmonic number';
else
    axislabel = 'Acoustic frequency (Hz)';
end

%%
xLab = 'Modulation frequency (Hz)';
yLab = axislabel;
axis xy

titulo  = '';
lineW   = 3;
fontS   = 35;
axisIn  = '';
bColor  = false;

% climdb( 50 )

name = 'RALA_Norm';
Graficador( name, xLab, yLab, titulo, axisIn, lineW, fontS, bColor )