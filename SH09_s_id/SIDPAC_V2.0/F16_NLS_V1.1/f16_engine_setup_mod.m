%
%  F16_ENGINE_SETUP  Generates engine thrust data tables.  
%
%  Usage: f16_engine_setup;
%
%  Description:
%
%    This program generates the engine thrust data tables
%    for the F-16 nonlinear simulation.  
%
%  Input:
%
%    None
%
%  Output:
%
%    IDP = idle power data.
%    MLP = mil power data.
%    MXP = max power data. 
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      17 June 1995 - Created and debugged, EAM.
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
%
%  Engine data.
%
% global IDP MLP MXP
%
%  Idle power.
%
IDP=[ 1060.,  670.,  880., 1140., 1500., 1860.;...
       635.,  425.,  690., 1010., 1330., 1700.;...
        60.,   25.,  345.,  755., 1130., 1525.;...
     -1020., -710., -300.,  350.,  910., 1360.;...
     -2700.,-1900.,-1300., -247.,  600., 1100.;...
     -3600.,-1400., -595., -342., -200.,  700.]';
%
%  Mil power.
%
MLP=[12680., 9150., 6200., 3950., 2450., 1400.;...
     12680., 9150., 6313., 4040., 2470., 1400.;...
     12610., 9312., 6610., 4290., 2600., 1560.;...
     12640., 9839., 7090., 4660., 2840., 1660.;...
     12390.,10176., 7750., 5320., 3250., 1930.;...
     11680., 9848., 8050., 6100., 3800., 2310.]';
%
%  Max power.
%
MXP=[20000.,15000.,10800., 7000., 4000., 2500.;...
     21420.,15700.,11225., 7323., 4435., 2600.;...
     22700.,16860.,12250., 8154., 5000., 2835.;...
     24240.,18910.,13760., 9285., 5700., 3215.;...
     26070.,21075.,15975.,11115., 6860., 3950.;...
     28886.,23319.,18300.,13484., 8642., 5057.]';
LUTvalues.IDP = IDP;
LUTvalues.MLP = MLP;
LUTvalues.MXP = MXP;
return
