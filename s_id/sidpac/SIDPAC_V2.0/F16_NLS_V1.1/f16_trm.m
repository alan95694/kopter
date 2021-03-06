function [trm,xfree,xinit,ufree,uinit] = f16_trm(p,c)
%
%  F16_TRM  Computes constraints and state derivatives for the nonlinear equations of motion.  
%
%  Usage:  [trm,xfree,xinit,ufree,uinit] = f16_trm(p,c);
%
%    To find trim p:  p = solve('f16_trm',p0,c,del,tol,ifd);
%
%
%  Description:
%
%    This function computes the nonlinear state equation 
%    derivatives, along with ROC and level turn constraints.  
%
%  Inputs:
%
%    p = parameter vector with elements comprised of the missing
%        information from the state and control vectors.
%
%      State vector elements are:
%        x(1)  = true airspeed, vt  (fps). 
%        x(2)  = sideslip angle, beta  (rad).
%        x(3)  = angle of attack, alpha  (rad). 
%        x(4)  = roll rate, p (rps).
%        x(5)  = pitch rate, q (rps).
%        x(6)  = yaw rate, r  (rps).
%        x(7)  = roll angle, phi  (rad).
%        x(8)  = pitch angle, the  (rad).
%        x(9)  = yaw angle, psi  (rad).
%        x(10) = xe  (ft)
%        x(11) = ye  (ft)
%        x(12) = h   (ft)  
%        x(13) = pow (percent, 0 <= pow <= 100)
%
%      Control vector elements are:
%        u(1) = throttle input, thtl  (fraction of full power, 0 <= thtl <= 1.0).
%        u(2) = stabilator input, stab  (deg).
%        u(3) = aileron input, ail  (deg).
%        u(4) = rudder input, rdr  (deg).
%
%    c = vector of constants:  c(1) through c(9) = inertia constants.
%                              c(10) = aircraft mass, slugs.
%                              c(11) = xcg, longitudinal c.g. location,
%                                      distance normalized by the m.a.c.
%      Constant vector elements are:
%        c(1) = ((iyy-izz)*izz - ixz^2)/gam    ;    gam=ixx*izz-ixz^2
%        c(2) = (ixx-iyy+izz)*ixz/gam
%        c(3) = izz/gam
%        c(4) = ixz/gam
%        c(5) = (izz-ixx)/iyy
%        c(6) = ixz/iyy
%        c(7) = 1.0/iyy
%        c(8) = (ixx*(ixx-iyy) + ixz^2)/gam
%        c(9) = ixx/gam
%        c(10) = mass
%        c(11) = xcg
%
%  Outputs:
%
%     trm = vector of trim equation values:
%             trm(1) = xd(1)
%             trm(2) = xd(2)
%             trm(3) = xd(3)
%             trm(4) = xd(4)
%             trm(5) = xd(5)
%             trm(6) = xd(6)
%             trm(7) = ROC contraint solved for zero.
%             trm(8) = Turn coordination constraint solved for zero.
%   xfree = vector indicating free states for trim:
%           = 1 for free state
%           = 0 for fixed state
%   xinit = initial state vector for trim, 
%           including fixed state values.
%   ufree = vector indicating free controls for trim:
%           = 1 for free control
%           = 0 for fixed control
%   uinit = initial control vector for trim, 
%           including fixed control values.
%

%
%    Calls:
%      f16_deq.m
%      tgear.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      06 Nov 1995 - Created and debugged, EAM.
%      06 Oct 2000 - Modified outputs to streamline and generalize trim, EAM.
%      23 Feb 2006 - Updated for F-16 NLS version 1.1, EAM.
%      02 Aug 2006 - Changed elevator to stabilator, EAM.
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
trm=zeros(8,1);
g=32.174;
%
%  Trim option settings.
%
%  Ones make the corresponding state or control
%  free in the trimming procedure.  
%
%  x = [ vt,beta,alpha, p, q, r, phi,  the, psi,xe, ye,     h ]'
%
xfree=[   0,   1,    1, 0, 0, 0,   1,    1,   0, 0,  0,     0 ]';
xinit=[ 502,   0,  0.1, 0, 0, 0,   0,  0.1,   0, 0,  0, 10000 ]';
%
%  u = [thtl,stab,ail,rdr]'
%
ufree=[  1,  1,  1,  1]';
uinit=[  0, -6,  0,  0]';
%
%  Flight path angle, rad.
%
gam=0*pi/180;
%
%  Turn rate, rad/sec.
%
trate=0*pi/180;
%
%  Check input parameter vector length against
%  the trim option selections.  
%
if (sum(xfree)+sum(ufree))~=length(p)
  fprintf('\n\n Parameter length mismatch in f16_trm.m \n\n')
  return
end
%
%  Check for too many free parameters - there are eight trim equations.  
%
if (sum(xfree)+sum(ufree))>8
  fprintf('\n\n Too many free parameters in f16_trm.m \n\n')
  return
end
%
%  Assign elements of the x and u vectors for trimming.
%
x=xinit;
ns=length(x);
u=uinit;
nc=length(u);
np=0;
for i=1:ns-1,
  if xfree(i)==1
    np=np+1;
    x(i)=p(np);
  end
end
for i=1:nc,
  if ufree(i)==1
    np=np+1;
    u(i)=p(np);
  end
end
%
%  Set engine power state equal to the power command  (bypass engine lag).
%
x(13)=tgear(u(1));
%
%  Compute state derivatives.
%
xd=f16_deq(u,x,c);
trm(1:3)=xd(1:3);
trm(4:6)=xd(4:6);
%
%  ROC constraint equation.
%
a=cos(x(3))*cos(x(2));b=sin(x(7))*sin(x(2))+cos(x(7))*sin(x(3))*cos(x(2));
sgam=sin(gam);
s2gam=sgam*sgam;
trm(7)=tan(x(8))-(a*b+sgam*sqrt(a^2.-s2gam+b^2.))/(a^2.-s2gam);
%
%  Turn coordination constraint equation.
%
G=trate*x(1)/g;
trm(8)=sin(x(7))-G*cos(x(2))*(sin(x(3))*tan(x(8))+cos(x(3))*cos(x(7)));
return
