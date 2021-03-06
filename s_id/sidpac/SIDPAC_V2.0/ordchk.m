function lochk = ordchk(indx,n,ivar,nord)
%
%  ORDCHK  Makes independent variable order checks in offit.m and mof.m.  
%
%  Usage: lochk = ordchk(indx,n,ivar,nord);
%
%  Description:
%
%    Checks that maximum allowable order for independent 
%    variable ivar of the nth function is not exceeded.
%
%
%  Input:
%    
%    indx = vector of function indices.
%       n = function number.
%    ivar = independent variable number for the order check.
%    nord = vector of maximum allowable variable orders.
%
%
%  Output:
%
%    lochk = logical output for the order check.
%            = 0 when maximum order is not exceeded.
%            = 1 when maximum order is exceeded.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Jan 2000 - Created and debugged, EAM.
%      22 Dec 2002 - Replaced round with fix to 
%                    repair a bug that shows up 
%                    at high model indices, EAM.
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
lochk=0;
tindx=indx(n);
%
%  Put the index of interest in the ones place of tindx.
%
if ivar>1 
  for i=1:ivar-1,
    tindx=fix(tindx/10);
  end
end
%
%  Check the index of interest against the limit.
%
if rem(tindx,10)>nord(ivar)
  lochk=1;
end
return
