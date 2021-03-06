function [C1,Cm,Cn,phat,qhat,rhat,aa,iterms] = compmc(fdata,cbar,bspan,sarea)
%
%  COMPMC  Computes non-dimensional moment coefficients.
%
%  Usage: [C1,Cm,Cn,phat,qhat,rhat,aa,iterms] = compmc(fdata,cbar,bspan,sarea);
%
%  Description:
%
%    Computes the non-dimensional moment coefficients 
%    and non-dimensional angular rates based
%    on measured flight data from input data array fdata.  
%    Inputs cbar, bspan, and sarea can be omitted if
%    fdata contains this information.  
%
%  Input:
%
%    fdata = flight data array in standard configuration.
%     cbar = wing mean aerodynamic chord, ft.
%    bspan = wing span, ft.
%    sarea = wing area, ft2.
%
%  Output:
%
%      C1 = non-dimensional rolling moment coefficient.
%      Cm = non-dimensional pitching moment coefficient.
%      Cn = non-dimensional yawing moment coefficient.
%    phat = non-dimensional roll rate.
%    qhat = non-dimensional pitch rate.
%    rhat = non-dimensional yaw rate.
%      aa = angular acceleration matrix = [pdot,qdot,rdot], rad/sec2.
%  iterms = nonlinear inertial terms in the moment equations
%           = [roll, pitch, yaw] equation nonlinear inertial terms.  
%

%
%    Calls:
%      deriv.m
%      xsmep.m
%      rms.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      27 June 2001 - Created and debugged, EAM.
%      07 Sept 2001 - Modified to include time-varying inertial properties, EAM.
%      12 July 2002 - Made geometry inputs optional, EAM.
%      23 Oct  2002 - Replaced norm with rms to test for angular accelerations, EAM.
%      15 Sept 2004 - Added error checks for airspeed and qbar, EAM.
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
[npts,n]=size(fdata);
dtr=pi/180;
if nargin < 4
  sarea=fdata(1,77);
end
if nargin < 3
  bspan=fdata(1,78);
end
if nargin < 2
  cbar=fdata(1,79);
end
if ((sarea <=0) | (bspan <= 0) | (cbar <= 0))
  fprintf('\n\n Geometry input error in compmc.m \n\n')
  return
end
if (norm(fdata(:,2))==0)
  fprintf('\n\n Zero airspeed error in compmc.m \n\n')
  return
end
if (norm(fdata(:,27))==0)
  fprintf('\n\n Zero qbar error in compmc.m \n\n')
  return
end
qbars=sarea*fdata(:,27);
t=fdata(:,1);
t=t-t(1);
dt=1/round(1/(t(2)-t(1)));
av=fdata(:,[5:7])*dtr;
aa=zeros(npts,3);
%
%  If angular accelerations are not present,
%  then differentiate the angular rates 
%  using locally smoothed numerical differentiation.  
%
if sum(rms(fdata(:,[42:44])))~=0
  aa=fdata(:,[42:44])*dtr;
else
  aa=deriv(av,dt);
%
%  Smooth endpoints.
%
  aa=xsmep(aa,2.0,dt);
end
%
%  Inertial properties are vectors 
%  to allow for variation with time.
%
ixx=fdata(:,49);
iyy=fdata(:,50);
izz=fdata(:,51);
ixz=fdata(:,52);
%
%  Compute the non-dimensional aerodynamic 
%  moment coefficients.
%
C1=(ixx.*aa(:,1) - ixz.*(aa(:,3) + av(:,1).*av(:,2)) ...
    + (izz-iyy).*av(:,2).*av(:,3))./(bspan*qbars);
Cm=(iyy.*aa(:,2) + ixz.*(av(:,1).^2 - av(:,3).^2) ...
    + (ixx-izz).*av(:,1).*av(:,3))./(cbar*qbars);
Cn=(izz.*aa(:,3) - ixz.*(aa(:,1) - av(:,2).*av(:,3)) ...
    + (iyy-ixx).*av(:,1).*av(:,2))./(bspan*qbars);
%
%  Compute the non-dimensional angular rates.
%
phat=av(:,1)*bspan./(2*fdata(:,2));
qhat=av(:,2)*cbar./(2*fdata(:,2));
rhat=av(:,3)*bspan./(2*fdata(:,2));
% phat=av(:,1)*bspan/(2*mean(fdata(:,2)));
% qhat=av(:,2)*cbar/(2*mean(fdata(:,2)));
% rhat=av(:,3)*bspan/(2*mean(fdata(:,2)));
%
%  Compute the inertial terms.
%
iterms=zeros(npts,3);
iterms(:,1)=-ixz.*av(:,1).*av(:,2) + (izz-iyy).*av(:,2).*av(:,3);
iterms(:,2)=ixz.*(av(:,1).^2 - av(:,3).^2) + (ixx-izz).*av(:,1).*av(:,3);
iterms(:,3)=ixz.*av(:,2).*av(:,3) + (iyy-ixx).*av(:,1).*av(:,2);
return
