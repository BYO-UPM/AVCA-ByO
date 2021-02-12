function mFeatures= RegularityVoice_avca (sFile)

[vSignal, iFs]  = audioread( sFile );
vSignal=vSignal/max(abs(vSignal)); % Normalization


%% Parameters
iFrame    = ceil( 40e-3*iFs ); 
iSolape   = floor( 0.5*iFrame );
sNorm     = 'chebychev';

dim       = 8;
tau       = 20;
iAlpha    = 0.35;

%% Norm
% Use the voicebox toolbox
mSignal = enframe( vSignal, hamming( iFrame ), iSolape );

rApEn = zeros( 1, size( mSignal, 1 ) );
rSampEn = zeros( 1, size( mSignal, 1 ) );
rFuzzyEn = zeros( 1, size( mSignal, 1 ) );
rGSampEn = zeros( 1, size( mSignal, 1 ) );
rmSampEn = zeros( 1, size( mSignal, 1 ) );

%xNorm = 1:size( mSignal, 1 );
for j=1:size( mSignal, 1 )

    vFrame = mSignal(j,:);
    vFrame = normalize( vFrame, 'zscore' );    
    rParam = std( vFrame )*iAlpha;
    
    % Reconstruction
    % dim = m + 1
    mAtractorEntropyp1 = embeb( vFrame, dim+1, tau );
    % dim = m
    mAtractorEntropy = embeb( vFrame, dim, tau );
        
    [rApEn(j),rSampEn(j),rmSampEn(j),rGSampEn(j),rFuzzyEn(j)] =...
        CalculateRegularity( mAtractorEntropyp1, mAtractorEntropy, rParam, sNorm, true );
end

mFeatures= [rApEn, rSampEn, rFuzzyEn, ...
    rGSampEn, rmSampEn];
