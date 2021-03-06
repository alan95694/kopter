function [lmchk,sumindx] = mordchk(indx,n,nvar,maxord)
%
%  MORDCHK  Makes model term order checks in offit.m and mof.m.  
%
%  Usage: [lmchk,sumindx] = mordchk(indx,n,nvar,maxord);
%
%  Description:
%
%    Checks that maximum allowable order for 
%    the nth function is not exceeded.  
%
%
%  Input:
%    
%      indx = vector of orthogonal function indices.
%         n = orthogonal function number.
%      nvar = number of independent variables.
%    maxord = maximum allowable order.
%
%
%  Output:
%
%      lmchk = logical output for the order check.
%               = 0 when maximum order is not exceeded.
%               = 1 when maximum order is exceeded.
%    sumindx = sum of the independent variable indices in indx(n).
%
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Jan 2000 - Created and debugged, EAM.
%      20 Sep 2002 - Updated output description, EAM.
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
lmchk=0;
tindx=indx(n);
%
%  Get the sum of the independent variable orders.  
%
sumindx=0;
for i=1:nvar,
  sumindx=sumindx+rem(tindx,10);
  tindx=round(tindx/10);
end
%
%  Check the independent variable order sum against the limit.
%
if sumindx>maxord
  lmchk=1;
end
return
