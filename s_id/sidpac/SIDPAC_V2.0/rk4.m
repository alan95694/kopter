function x = rk4(deqname,u,t,x0,c)
%
%  RK4  Fourth-order Runge-Kutta numerical integration.  
%
%  Usage: x = rk4(deqname,u,t,x0,c);
%
%  Description:
%
%    Integrates the differential equations specified in the 
%    file named deqname, using fourth order Runge-Kutta integration 
%    with input interpolation.
%
%  Input:
%    
%    deqname = name of the file that computes the state derivatives.
%          u = control vector time history.
%          t = time vector.
%         x0 = state vector initial condition.
%          c = vector or data structure of constants.
%
%  Output:
%
%          x = state vector time history.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      24 Jan 1995 - Created and debugged, EAM.
%      22 May 2001 - Repaired call line inconsistency, EAM.
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
npts=length(t);
dt=t(2)-t(1);
n=length(x0);
x=zeros(npts,n);
x(1,:)=x0';
xd1=zeros(n,1);
xd2=zeros(n,1);
xd3=zeros(n,1);
xd4=zeros(n,1);
for i=1:npts-1,
  xi=x(i,:)';
  uint=u(i,:)';
  xd1=eval([deqname,'(uint,xi,c)']);
  xint=xi + dt*xd1/2;
  uint=(u(i,:)' + u(i+1,:)')/2;
  xd2=eval([deqname,'(uint,xint,c)']);
  xint=xi + dt*xd2/2;
  xd3=eval([deqname,'(uint,xint,c)']);
  xint=xi + dt*xd3;
  uint=u(i+1,:)';
  xd4=eval([deqname,'(uint,xint,c)']);
  x(i+1,:)=(xi + dt*(xd1+2*xd2+2*xd3+xd4)/6)';
end
return
