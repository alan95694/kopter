function cmt = cmo(alpha,stab)
%
%  CMO  Computes basic aerodynamic pitching moment coefficient.
%
%  Usage: cmt = cmo(alpha,stab);
%
%  Description:
%
%    Computes the basic aerodynamic pitching moment 
%    coefficient for the F-16.  
%
%  Input:
%    
%     alpha = angle of attack, deg.
%      stab = stabilator deflection, deg.
%
%  Output:
%
%       cmt = basic aerodynamic pitching moment coefficient.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      19 June 1995 - Created and debugged, EAM.
%      02 Aug  2006 - Changed elevator to stabilator, EAM.
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
global CMO
s=0.2*alpha;
k=fix(s);
k=max(-1,k);
k=min(k,8);
da=s-k;
%
%  Add 3 to the indices because the indexing of CMO 
%  starts at 1, not -2.
%
k=k+3;
l=k+sign(da);
s=stab/12;
m=fix(s);
m=max(-1,m);
m=min(m,1);
de=s-m;
m=m+3;
n=m+sign(de);
t=CMO(k,m);
u=CMO(k,n);
v=t+abs(da)*(CMO(l,m)-t);
w=u+abs(da)*(CMO(l,n)-u);
cmt=v+(w-v)*abs(de);
return
