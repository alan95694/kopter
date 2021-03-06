function d = dampder(alpha)
%
%  DAMPDER  Computes aerodynamic damping derivatives.  
%
%  Usage: d = dampder(alpha);
%
%  Description:
%
%    Computes the aerodynamic damping derivatives for the F-16.  
%
%  Input:
%    
%     alpha = angle of attack, deg.
%
%  Output:
%
%       d = vector of damping derivatives.
%         = [Cxq,Cyr,Cyp,Czq,Clr,Clp,Cmq,Cnr,Cnp];
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 June 1995 - Created and debugged, EAM.
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
global DDER
s=0.2*alpha;
k=fix(s);
k=max(-1,k);
k=min(k,8);
da=s-k;
%
%  Add 3 to the indices because the indexing of DDER 
%  starts at 1, not -2.
%
k=k+3;
l=k+sign(da);
d=DDER(k,:)+abs(da)*(DDER(l,:)-DDER(k,:));
return
