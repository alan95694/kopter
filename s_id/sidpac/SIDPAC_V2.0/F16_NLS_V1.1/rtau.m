function rtau = rtau(dp)
%
%  RTAU  Computes the reciproal time constant for a first-order thrust lag.
%
%  Usage: rtau = rtau(dp);
%
%  Description:
%
%    Computes the reciprocal time constant 
%    for a first-order thrust lag.  
%
%  Input:
%    
%     dp = difference between commanded and 
%          actual power level = pc-pa, percent.
%
%  Output:
%
%   rtau = reciprocal time constant for the thrust lag, 1/sec.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 Feb 1995 - Created and debugged, EAM.
%
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
if dp<=25.0
  rtau=1.0;
else
  if dp>=50.0
    rtau=0.1;
  else
    rtau=1.9-0.036*dp;
  end
end
return
