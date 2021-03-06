%
%  GEN_F16_MODEL  Trims the nonlinear simulation and generates linear models using finite differences.
%
%  Usage: gen_f16_model;
%
%  Description:
%
%    This program trims the F-16 nonlinear simulation, 
%    then computes the linear system matrices 
%    using central finite differences.  
%
%  Input:
%
%    None
%
%  Output:
%
%    A,B,C,D = linear system matrices.
%         x0 = trim state vector.
%         u0 = trim control vector.
%         c  = c(1) through c(9) = inertia constants for aircraft
%              nonlinear equations of motion.
%              c(10) = aircraft mass.
%              c(11) = X c.g. position in fraction of the m.a.c.
%

%
%    Calls:
%      f16_aero_setup.m
%      f16_engine_setup.m
%      f16_massprop.m
%      solve.m
%      f16_trm.m
%      ic_ftrm.m
%      lnze.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      22 Apr 1995 - Created and debugged, EAM.
%      06 Oct 2000 - Modified to avoid setting vt and alt in the workspace, EAM.
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
f16_aero_setup;
f16_engine_setup;
if exist('c')==0
  c=f16_massprop;
end
if ~exist('p0')
   p0=zeros(8,1);
   p0(1)=1;
end
%
%  Use values defined in xinit and uinit
%  as the initial parameter values for trimming.
%
[trm,xfree,xinit,ufree,uinit]=f16_trm(p0,c);
indx=find(xfree==1);
indu=find(ufree==1);
if ~isempty(indx)
  p0=xinit(indx);
end
if ~isempty(indu)
  p0=[p0;uinit(indu)];
end
np=length(p0);
del=0.01*ones(np,1);
if exist('tol')==0
  tol=1.0e-08;
end
if exist('ifd')==0
  ifd=1;
end
p=solve('f16_trm',p0,c,del,tol,ifd);
[trm,xfree,xinit,ufree,uinit]=f16_trm(p,c);
[x0,u0]=ic_ftrm(p,xfree,xinit,ufree,uinit);
%
%  Longitudinal case.
%
if exist('lonflg')==0
  lonflg=1;
end
if lonflg==1
  if exist('iu')==0
    iu=[1,2]'; 
  end
  if exist('ix')==0
    ix=[1,3,5,8,13]';
  end
else
%
%  Lateral case.
%
  if exist('iu')==0
    iu=[3,4]';
  end
  if exist('ix')==0
    ix=[2,4,6,7]';
  end
end
[A,B,C,D]=lnze('f16_deq',u0,x0,c,iu,ix,del);
return
