function vParameters = AdditiveNoise_stats( vSignal, iFs, iFrameSize, iOverlap )

% Calculation of the statistics of the additive noise parameters
%
% Inputs:
%   vFrame               = Input vFrame
%   iFs                  = Sampling frequency
%   iFrameSize           = Number of samples used to define the frame of
%                          analysis
%   iOverlap             = Number of samples for ovelapping windows
%
% Outputs:
%   vParameters          = Vector containing the statistics (mean and stdev)
%                        of the following additive noise parameters: 
%                           - vNNE: Normalized noise energy
%                           - vHNR: Harmonics to noise ratio - Yumoto
%                           - vGNE: Glottal-to-noise excitation ratio
%                           - vCHNR: Cespstrum harmonics-to-noise ratio

iLengthSignal = length(vSignal);
iNumVentanas = fix((iLengthSignal - iFrameSize + iOverlap)/(iOverlap));

% Normalized noise energy
vNNE  = NNE(vSignal, iFs, 1, iLengthSignal, iNumVentanas ); 
% Harmonics to noise ratio - Yumoto
vHNR = HNRYum(vSignal, iFs, 1, iLengthSignal, iNumVentanas); 
% Cespstrum harmonics-to-noise ratio
vCHNR = CHNR( vSignal, iFs, 1, iLengthSignal, iNumVentanas );

% Glottal-to-noise excitation ratio
vGNE = GNE(vSignal, iFs, 1, length(vSignal), iNumVentanas, 40e-3, 500, 100 ); 

[NNE_mean, NNE_std]=logstatistics(vNNE);
[HNR_mean, HNR_std]=logstatistics(vHNR);
[CHNR_mean, CHNR_std]=logstatistics(vCHNR);

vParameters = [NNE_mean, NNE_std, HNR_mean, HNR_std, CHNR_mean, CHNR_std, mean(vGNE), std(vGNE)];

end



%This function calculates the logarithmic average and standard deviation of
%the input vector (vIn)
function [rMean, rStd] = logstatistics (vIn)

vIn=10.^(vIn/10);

rMean=10*log10(mean(vIn));
rStd=10*log10(std(vIn));


end