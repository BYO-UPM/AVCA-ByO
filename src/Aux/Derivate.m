% function cd=Derivate( c, w );
%
% This function calculates the first and second derivative of a
% secuence of frames given by matrix 'mCoeff' and appends it to the input
% matrix.
% Procedure extracted from [1]
%
% Input parameters: 
%   'mCoeff'   matrix containing the features. One frame per row.
%   'w'   any sensible combination of the following:
%        'd'	include delta coefficients (dc/dt)
%        'D'	include delta-delta coefficients (d^2c/dt^2)
% 
% Output parameters:
%   'mDer'  New matrix that includes the input matrix and the appended
%   derivatives.
%
% [1] Furui, S. (1986). Speaker-independent isolated word recognition using 
% dynamic features of speech spectrum. IEEE Transactions on Acoustics, 
% Speech, and Signal Processing, 34(1), 52-59.
%

function mDer=Derivate( mCoeff, w, eOptions )

if nargin < 1, error('No input matrix to derivate' ); end;
if nargin < 2, w='Dd'; end;
if nargin < 3, eOptions=[]; end

    if isfield(eOptions,'deriLong'), iLong=eOptions.deriLong;
    else iLong=4; % Range of FIR filter: 2*iLong+1
    end

nf=size(mCoeff,1);
nc=size(mCoeff,2);

% calculate 2nd derivative
if any(w=='D')
  vf=(iLong:-1:-iLong)/sum((iLong:-1:-iLong).^2);
  af=(1:-1:-1)/2;
  ww=ones(iLong+1,1);
  cx=[mCoeff(ww,:); mCoeff; mCoeff(nf*ww,:)];
  vx=reshape(filter(vf,1,cx(:)),nf+2*iLong+2,nc);
  vx(1:iLong*2,:)=[];
  ax=reshape(filter(af,1,vx(:)),nf+2,nc);
  ax(1:2,:)=[];
  vx([1 nf+2],:)=[];
  if any(w=='d')
     mDer=[mCoeff vx ax];
  else
     mDer=[mCoeff ax];
  end
elseif any(w=='d')   % calculate only 1st derivative
  vf=(iLong:-1:-iLong)/sum((iLong:-1:-iLong).^2);
  ww=ones(iLong,1);
  cx=[mCoeff(ww,:); mCoeff; mCoeff(nf*ww,:)];
  vx=reshape(filter(vf,1,cx(:)),nf+iLong*2,nc);
  vx(1:iLong*2,:)=[];
  mDer=[mCoeff vx];
end

return; 

