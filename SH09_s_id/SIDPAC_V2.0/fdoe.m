function [Y,p,crb,svv] = fdoe(dsname,p0,U,t,w,c,Z,auto,crb0,del,svlim)
%
%  FDOE  Output-error parameter estimation in the frequency domain.
%
%  Usage: [Y,p,crb,svv] = fdoe(dsname,p0,U,t,w,c,Z,auto,crb0,del,svlim);
%
%  Description:
%
%    Computes the output-error maximum likelihood estimate of 
%    parameter vector p, Cramer-Rao bound matrix crb, 
%    the power spectral density of the measuement noise svv, 
%    and the model output Y in the frequency domain,
%    using modified Newton-Raphson optimization.  
%    This routine implements the output-error formulation 
%    in the frequency domain.  The dynamic system is specified
%    in the file named dsname.  
%    Inputs auto, crb0, del, and svlim are optional.  
%
%  Input:
%    
%    dsname = name of the file that computes the model outputs.
%        p0 = initial vector of parameter values.
%         U = input vector or matrix in the frequency domain.
%         t = time vector.
%         w = frequency vector, rad/sec.
%         c = vector or data structure of constants passed to dsname.
%         Z = measured output vector or matrix in the frequency domain.
%      auto = flag indicating type of operation (optional):
%             = 1 for automatic  (no user input required, default).
%             = 0 for manual  (user input required).
%      crb0 = parameter covariance matrix for p0 (optional).
%       del = vector of parameter perturbations 
%             in fraction of nominal parameter value (optional).
%     svlim = minimum singular value ratio for matrix inversion (optional).
%
%  Output:
%
%          Y = model output vector or matrix in the frequency domain. 
%          p = vector of parameter estimates.
%        crb = estimated parameter covariance matrix.
%        svv = power spectral density of the measurement noise.
%

%
%    Calls:
%      cvec.m
%      estsvv.m
%      mnr.m
%      compcost.m
%      simplex.m
%      misvd.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      21 May  1999 - Created and debugged, EAM.
%      15 July 2004 - Updated to be consistent with oe.m, EAM.
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
[fid,message]=fopen('fdoe.out','w');
if fid < 3
  message,   
  return
end
%
%  Initialization.
%
iter=1;
itercnt=0;
maxitercnt=500;
%
%  Switch to the same notation used for the time domain 
%  maximum likelihood estimation code.  Variable x0 is a dummy.
%
u=U;
z=Z;
x0=0;
dt=t(2)-t(1);
[npts,no]=size(z);
p0=cvec(p0);
np=length(p0);
if nargin < 11 | isempty(svlim)
  svlim=eps*npts;
end
if svlim <= 0
  svlim=eps*npts;
end
if nargin < 10 | isempty(del)
  del=0.01*ones(np,1);
end
if nargin < 9 | isempty(crb0)
  crb0=zeros(np,np);
  M0=zeros(np,np);
else
  crb0=diag(diag(crb0));
  M0=misvd(crb0);
end
if nargin < 8 | isempty(auto)
  auto=1;
end
y=eval([dsname,'(p0,u,w,x0,c)']);
rr=estsvv(y,z,t);
pctrr=100*ones(no,1);
p=p0;
%
%  Optimization loop.
%
while (iter > 0)&(itercnt < maxitercnt),
  iter=iter - 1;
%
%  Modified Newton-Raphson.
%
  [infomat,djdp,cost]=mnr(dsname,p,u,w,x0,c,del,y,z,rr);
  infomat=npts*dt*infomat;
%
%  Add the a priori contributions.
%
  infomat=infomat+M0;
  djdp=djdp-M0*(p-p0);
  cost=cost+0.5*(p-p0)'*M0*(p-p0);
  [Usvd,Ssvd,Vsvd]=svd(infomat);
  fprintf(fid,'\n SINGULAR VALUES: \n');
  svmax=Ssvd(1,1);
  for j=1:np,
    fprintf(fid,'     singular value %3.0f = %13.6e \n',j,Ssvd(j,j));
    if Ssvd(j,j)/svmax < svlim
      Ssvd(j,j)=0.0;
      fprintf(fid,' SINGULAR VALUE %3.0f DROPPED \n',j);
      fprintf(1,' SINGULAR VALUE %3.0f DROPPED \n',j);
    else
      Ssvd(j,j)=1/Ssvd(j,j);
    end
  end
%  crb=inv(infomat);
  crb=Vsvd*Ssvd*Usvd';
  dp=crb*djdp;
  pn=p+dp;
  [costn,yn]=compcost(dsname,pn,u,w,x0,c,z,rr,p0,M0);
  fprintf(fid,'\n iteration number %4.0f \n',itercnt);
  fprintf(1,'\n iteration number %4.0f \n',itercnt);
  fprintf(fid,'\n   current cost  = %13.6e \n',cost);
  fprintf(1,'\n   current cost  = %13.6e \n',cost);
  fprintf(fid,'   mnr step cost = %13.6e \n',costn);
  fprintf(1,'   mnr step cost = %13.6e \n',costn);
  fprintf(fid,'\n     parameter      update      std. error       djdp    \n');
  fprintf(1,'\n     parameter      update      std. error       djdp    \n');
  fprintf(fid,'     ---------      ------      ----------       ----    \n');
  fprintf(1,'     ---------      ------      ----------       ----    \n');
%
%  Print out the current data for the estimated parameters.  
%  Line up the numbers accounting for any negative signs.  
%
  for j=1:np,
    if p(j) < 0.0
      fprintf(fid,'  %11.4e',p(j));
      fprintf(1,'  %11.4e',p(j));
    else
      fprintf(fid,'   %11.4e',p(j));
      fprintf(1,'   %11.4e',p(j));
    end
    if dp(j) < 0.0
      fprintf(fid,'  %11.4e',dp(j));
      fprintf(1,'  %11.4e',dp(j));
    else
      fprintf(fid,'   %11.4e',dp(j));
      fprintf(1,'   %11.4e',dp(j));
    end
    fprintf(fid,'   %11.4e',sqrt(crb(j,j)));
    fprintf(1,'   %11.4e',sqrt(crb(j,j)));
    if djdp(j) < 0.0
      fprintf(fid,'   %11.4e   \n',djdp(j));
      fprintf(1,'   %11.4e   \n',djdp(j));
    else
      fprintf(fid,'    %11.4e   \n',djdp(j));
      fprintf(1,'    %11.4e   \n',djdp(j));
    end
%    fprintf(fid,'   %11.4e   %11.4e   %11.4e   %11.4e   \n',...
%                     p(j),   dp(j), sqrt(crb(j,j)), djdp(j));
%    fprintf(1,'   %11.4e   %11.4e   %11.4e   %11.4e   \n',...
%                     p(j),   dp(j), sqrt(crb(j,j)), djdp(j));
  end
  fprintf(fid,'\n');
  fprintf(1,'\n');
%
%  If Modified Newton-Raphson diverges, switch to simplex.
%
  if abs(costn) > 1.01*abs(cost)
    fprintf(fid,'\n MODIFIED NEWTON-RAPHSON DIVERGED -> SWITCH TO SIMPLEX \n');
    fprintf(1,'\n MODIFIED NEWTON-RAPHSON DIVERGED -> SWITCH TO SIMPLEX \n');
    [costn,yn,pn]=simplex(dsname,p,u,w,x0,c,del,z,rr,fid,p0,M0);
  end
%
%  Check convergence criteria at decision point (iter=0).
%
  if iter <= 0
%
%  Discrete noise covariance matrix estimate.
%
    krr=0;
    for j=1:no,
      if abs(pctrr(j))<=5.0
        krr=krr + 1;
      end
    end
%
%  Parameter estimates and cost gradient.
%
    kp=0;
    kslp=0;
    for j=1:np,
      if abs(dp(j)) < 0.0001
        kp=kp + 1;
      end
      if abs(djdp(j)) < 0.05
        kslp=kslp + 1;
      end
    end
%
%  Cost.
%
    kj=0;
    if abs((costn-cost)/cost) < 0.001
      kj=1;
    end
    if (krr==no)&(kp==np)&(kslp==np)&(kj==1)
      fprintf(fid,'\n\n CONVERGENCE CRITERIA SATISFIED \n');
      fprintf(1,'\n\n CONVERGENCE CRITERIA SATISFIED \n');
    end
%
%  Manual operation.
%
    if auto~=1
%
%  Prompt user for more parameter estimation iterations.
%
      iter=input(' NUMBER OF ADDITIONAL ITERATIONS (0 to quit) ');
      iter=round(iter);
      if iter > 1000
        iter=1000;
      end
%
%  Prompt user for a dicrete noise covariance matrix estimation.
%
      if iter > 0
        ans=input(' UPDATE THE RR MATRIX ?  (y/n) ','s');
        if (ans=='y')|(ans=='Y')
          rrn=estsvv(yn,z,t);
          pctrr=100*diag(rrn-rr)./diag(rr);
          rr=rrn;
          fprintf(fid,'\n\n');
          fprintf(1,'\n\n');
          fprintf(fid,' output   rms error    rr inverse   percent change \n');
          fprintf(1,' output   rms error    rr inverse   percent change \n');
          fprintf(fid,' ------   ---------    ----------   -------------- \n');
          fprintf(1,' ------   ---------    ----------   -------------- \n');
%
%  Print out the current data for the estimated noise covariance matrix.  
%  Line up the numbers accounting for any negative signs.  
%
          for j=1:no,
            fprintf(fid,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            fprintf(1,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            if pctrr(j) < 0.0
              fprintf(fid,'   %11.4e   \n', pctrr(j));
              fprintf(1,'   %11.4e   \n', pctrr(j));
            else
              fprintf(fid,'    %11.4e   \n', pctrr(j));
              fprintf(1,'    %11.4e   \n', pctrr(j));
            end
%            fprintf(fid,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
%            fprintf(1,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
          end
          fprintf(fid,'\n');
          fprintf(1,'\n');
%
%  Compute the cost for yn and pn.
%
          vv=inv(rr);
          costn=0.0;
          v=z-yn;
%
%  The operator .' means transpose without complex conjugation.
%
          for i=1:npts,
            costn=costn + conj(v(i,:))*vv*v(i,:).';
          end
%
%  Get rid of imaginary round-off error.
%
          costn=0.5*real(costn);
%
%  Add the a priori contribution.
%
          costn=costn + 0.5*(pn-p0)'*M0*(pn-p0);
        end
      end
    else
%
%  Automatic operation.
%
      if (kp==np)&(kslp==np)&(kj==1)
        if (krr~=no)
          rrn=estsvv(yn,z,t);
          pctrr=100*diag(rrn-rr)./diag(rr);
          rr=rrn;
          fprintf(fid,'\n\n');
          fprintf(1,'\n\n');
          fprintf(fid,' output   rms error    rr inverse   percent change \n');
          fprintf(1,' output   rms error    rr inverse   percent change \n');
          fprintf(fid,' ------   ---------    ----------   -------------- \n');
          fprintf(1,' ------   ---------    ----------   -------------- \n');
%
%  Print out the current data for the estimated noise covariance matrix.  
%  Line up the numbers accounting for any negative signs.  
%
          for j=1:no,
            fprintf(fid,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            fprintf(1,'  %3.0f    %11.4e   %11.4e',j, sqrt(rr(j,j)), 1/rr(j,j));
            if pctrr(j) < 0.0
              fprintf(fid,'   %11.4e   \n', pctrr(j));
              fprintf(1,'   %11.4e   \n', pctrr(j));
            else
              fprintf(fid,'    %11.4e   \n', pctrr(j));
              fprintf(1,'    %11.4e   \n', pctrr(j));
            end
%            fprintf(fid,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
%            fprintf(1,'  %3.0f   %11.4e   %11.4e    %11.4e   \n',...
%                             j, sqrt(rr(j,j)), 1/rr(j,j), pctrr(j));
          end
          fprintf(fid,'\n');
          fprintf(1,'\n');
%
%  Compute the cost for yn and pn.
%
          vv=inv(rr);
          costn=0.0;
          v=z-yn;
%
%  The operator .' means transpose without complex conjugation.
%
          for i=1:npts,
            costn=costn + conj(v(i,:))*vv*v(i,:).';
          end
%
%  Get rid of imaginary round-off error.
%
          costn=0.5*real(costn);
%
%  Add the a priori contribution.
%
          costn=costn + 0.5*(pn-p0)'*M0*(pn-p0);
          iter=5;
        else
          iter=0;
        end
      else
        iter=2;
      end
    end
  end
  y=yn;
  p=pn;
  cost=costn;
  itercnt=itercnt + 1;
end
rr=estsvv(y,z,t);
[infomat,djdp,cost]=mnr(dsname,p,u,w,x0,c,del,y,z,rr);
infomat=npts*dt*infomat;
%
%  Add the a priori contributions.
%
infomat=infomat+M0;
djdp=djdp-M0*(p-p0);
cost=cost+0.5*(p-p0)'*M0*(p-p0);
Y=y;
%crb=inv(infomat);
crb=misvd(infomat);
svv=rr;
%
%  Diagonal elements of svv are always real, so 
%  remove any imaginary part due to round-off error.
%
for j=1:no
  svv(j,j)=real(svv(j,j));
end
fclose(fid);
return
