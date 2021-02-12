function mFeatures=NDAVoice_avca_stats(sFile)
% Calculates the complexity features statistics of the input audio file
% (sFile)

[vSignal, iFs]  = audioread( sFile );
vSignal=vSignal/max(abs(vSignal)); % Normalization


%% Parameters
iFrame    = ceil( 40e-3*iFs );
iSolape   = floor( 0.5*iFrame );
sNorm     = 'chebychev';

dim       = 8;
tau       = 20;

% RPDE
T_max       = -1;    % maximum recurrence time (If not specified, then all recurrence times are returned)
iEpsilon    = 0.12;  % recurrence neighbourhood radius (If not specified, then a suitable value is chosen automatically)
% iEpsilon    = 0.5*std( vFrame );    
% ----------
% Correlation dimension
iRelRange   = 0.1;  % relative_range - search radius, relative to attractor diameter (0 < relative_range < 1)
% ----------
% Largest Lyapunov
iMaxdelta_n = 3;  % Maximal number of iterations, to compute delta_n
iNumVecinos = 5;  % Number of nearest neighbors to compute

%% Norm
% Use the voicebox toolbox
mSignal = enframe( vSignal, hamming( iFrame ), iSolape );
mCor = size( mSignal, 1 );
mLLE = size( mSignal, 1 );
mHurst = size( mSignal, 1 );
mDFA   = size( mSignal, 1 );
mRPDE  = size( mSignal, 1 );
mPE      = size( mSignal, 1 );
mMarkEnt = size( mSignal, 1 );


for j=1:size( mSignal, 1 )
    
    vFrame = mSignal(j,:);
    vFrame = normalize( vFrame, 'zscore' );
    
    % Reconstruction
    % dim = m
    mAtractor = embeb( vFrame, dim, tau );
        
    %%% 1) Correlation dimension
    iExclude    = ceil( 0.1*length( vFrame ) );  % in case the query points are taken out of the pointset, 
                                             % exclude specifies a range of indices which are omitted fromsearch.

    iCont = 0;  %To ensure a non-zero estimate
    iDCor = 0;
    while iDCor==0 && iCont <3
        iDCor = takens_estimator( mAtractor, 1:length( mAtractor ), iRelRange, (iCont+1)* iExclude );
        iCont = iCont+1;
    end    
    mCor(j) = iDCor;
    
    %%% 2)Largest lyapunov exponent
    l    = largelyap_R( mAtractor, 1:length( mAtractor )-iMaxdelta_n, iMaxdelta_n, iNumVecinos, iExclude );
    LLE  = polyfit( 1:iMaxdelta_n, l(1:iMaxdelta_n)', 1 );
    mLLE(j) = LLE(1);    
    
    %%% 3)Hurst exponent
    iHurst      = hurst_estimate( vFrame, 'absval', 0, 1 );  
    mHurst (j)  = iHurst;
    
    %%% 4)DFA
    if size( vFrame, 2 )>1
        vFrame=vFrame';
    end
    [iDFA, ~, ~] = fastdfa( vFrame ); 
    mDFA(j) = iDFA;
    
    %%% 5)RPDE
    iRPDE       = rpde( vFrame, iEpsilon, T_max );
    mRPDE(j)    = iRPDE;
    
    %%% 6) permutation_entropy
    [PE, ~] = permutation_entropy( vFrame, dim, tau );
    mPE(j) = PE;

    %%% 7 Markovian entropies   
    % Markovian Entropies    
    rParam = std( vFrame )*0.1;
    Entropies = Markov_Entropies( vFrame, dim, tau, rParam, 'MHR' ); 
    mMarkEnt(j) = Entropies.OriginalDim.EhmmrN;
end

mFeatures=[mean(mCor), std(mCor), mean(mLLE),std(mLLE), mean(mHurst), ...
    std(mHurst), mean(mDFA), std(mDFA), mean(mRPDE), std(mRPDE), ...
    mean(mPE), std(mPE), mean(mMarkEnt), std(mMarkEnt)];
