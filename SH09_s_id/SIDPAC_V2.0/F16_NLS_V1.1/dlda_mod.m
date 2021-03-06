function dclda = dlda_mod(alpha,beta,LUTvalues)
%
%  DLDA  Computes non-dimensional aerodynamic rolling moment due to aileron.  
%
%  Usage: dclda = dlda(alpha,beta);
%
%  Description:
%
%    Computes aerodynamic rolling moment due to 
%    aileron control derivative for the F-16.  
%
%  Input:
%    
%     alpha = angle of attack, deg.
%      beta = sidelsip angle, deg.
%
%  Output:
%
%    dclda = aerodynamic rolling moment due to aileron control deivative.
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
% global DLDA
DLDA = LUTvalues.DLDA;
s=0.2*alpha;
k=fix(s);
k=max(-1,k);
k=min(k,8);
da=s-k;
%
%  Add 3 to the indices because the indexing of DLDA 
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
t=DLDA(k,m);
u=DLDA(k,n);
v=t+abs(da)*(DLDA(l,m)-t);
w=u+abs(da)*(DLDA(l,n)-u);
dclda=v+(w-v)*abs(db);
return
