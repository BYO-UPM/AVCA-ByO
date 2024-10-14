function mFeatures = PerturbationFluctuationVoice_avca(sFile)
% Calculates the frequency and amplitude perturbation features statistics of the input audio file
% (sFile)

[vSignal, iFsOrig]  = audioread( sFile );
vSignal=vSignal/max(abs(vSignal)); % Normalization
iFs=25000;
vSignal=resample(vSignal,iFs, iFsOrig);

iFrame      = ceil( 40e-3*iFs ); 
iOverlap    = floor( 0.5*iFrame );

%% Features
[vJitter, vShimmer]  = JitterShimmer( vSignal, iFs );
vFluctuation = Fluctuation( vSignal, iFs );
vAdditiveNoise = AdditiveNoise_stats( vSignal, iFs, iFrame, iOverlap );

mFeatures=[vJitter, vShimmer, vFluctuation, vAdditiveNoise];
