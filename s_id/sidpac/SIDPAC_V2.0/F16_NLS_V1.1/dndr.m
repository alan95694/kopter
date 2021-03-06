function dcndr = dndr(alpha,beta)
%
%  DNDR  Computes non-dimensional aerodynamic yawing moment due to rudder.  
%
%  Usage: dcndr = dndr(alpha,beta);
%
%  Description:
%
%    Computes aerodynamic yawing moment due to 
%    rudder control derivative for the F-16.  
%
%  Input:
%    
%     alpha = angle of attack, deg.
%      beta = sidelsip angle, deg.
%
%  Output:
%
%    dcndr = aerodynamic yawing moment due to rudder control deivative.
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
global DNDR
s=0.2*alpha;
k=fix(s);
k=max(-1,k);
k=min(k,8);
da=s-k;
%
%  Add 3 to the indices because the indexing of DNDR 
%  starts at 1, not -2.
%
k=k+3;
l=k+sign(da);
s=0.1*beta;
m=fix(s);
m=max(-2,m);
m=min(m,2);
db=s-m;
m=m+4;
n=m+sign(db);
t=DNDR(k,m);
u=DNDR(k,n);
v=t+abs(da)*(DNDR(l,m)-t);
w=u+abs(da)*(DNDR(l,n)-u);
dcndr=v+(w-v)*abs(db);
return
