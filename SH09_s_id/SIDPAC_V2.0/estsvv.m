function svv = estsvv(Y,Z,t)
%
%  ESTSVV  Computes an estimate of the measurement noise spectral density matrix.  
%
%  Usage: svv = estsvv(Y,Z,t);
%
%  Description:
%
%    Computes the power spectral density estimate for the
%    measurement noise (output residuals) in the frequency domain.
%
%  Input:
%    
%    Y = model output vector in the frequency domain.
%    Z = measured output vector in the frequency domain.
%    t = time vector.
%
%  Output:
%
%    svv = measurement noise power spectral density matrix estimate.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      15 May 1999 - Created and debugged, EAM.
%
%  Copyright (C) 2006  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@nasa.gov
%
[nf,no]=size(Z);
dt=1/round(1/(t(2)-t(1)));
v=Z-Y;
svv=dt*(v'*v);
%
%  The calculation below assumes uncorrelated residuals.
%
%svv=zeros(no,no);
%for j=1:no,
%  svv(j,j)=dt*(v(:,j)'*v(:,j));
%end
return
