function cpow = tgear(thtl)
%
%  TGEAR  Implements throttle gearing.  
%
%  Usage: cpow = tgear(thtl);
%
%  Description:
%
%    This function implements the throttle gearing.
%
%  Input:
%    
%    thtl = throttle setting, fraction of M.A.C.  (0 <= thtl <= 1.0).
%
%  Output:
%
%    cpow = commanded power level, % of full power  (0 <= cpow <= 100).
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      26 May 1995 - Created and debugged, EAM.
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
if thtl<=0.77,
  cpow=64.94*thtl;
else
  cpow=217.38*thtl-117.38;
end
return
