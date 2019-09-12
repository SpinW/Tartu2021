% Template for spin wave spectra calculation for material COD-ID 7018178
clear
close all

% Creating the lattice
a0 = 1.000  % Angstrom
%a0 = 0.52917721067  % Bohr radius in Angstrom
avec_Ang = [9.1242  13.8132  9.0359]
avec = avec_Ang / a0
SDMTRLNO = spinw;
SDMTRLNO.genlattice('lat_const', avec,'angled',[90.00  90.00  90.00],'sym','P 21 21 21');
plot(SDMTRLNO)

% Adding atoms
SDMTRLNO.addatom('r',[ 0.2564  0.2478  0.2610],'S',1.000,'label','Co ','color','b')
plot(SDMTRLNO)

% Creating the Spin-Hamiltonian
SDMTRLNO.gencoupling('maxDistance',50)
SDMTRLNO.table('bond',1:50)

% Adjust for double counting, if needed convert mRyd to eV
mRy_ev=2.00
Ja = 0.61*mRy_ev
Jb = 0.45*mRy_ev
Jc = 0.40*mRy_ev
Jd = 0.02*mRy_ev
Je = 0.00*mRy_ev
%Jf = 0.01*mRy_ev

SDMTRLNO.addmatrix('label','Ja','value',Ja,'color','black')
SDMTRLNO.addmatrix('label','Jb','value',Jb,'color','red')
SDMTRLNO.addmatrix('label','Jc','value',Jc,'color','green')
SDMTRLNO.addmatrix('label','Jd','value',Jd,'color','yellow')
SDMTRLNO.addmatrix('label','Je','value',Je,'color','blue')
%SDMTRLNO.addmatrix('label','Jf','value',Jf,'color','orange')

SDMTRLNO.addcoupling('mat','Ja','bond',4)
SDMTRLNO.addcoupling('mat','Jb','bond',1)
SDMTRLNO.addcoupling('mat','Jc','bond',2)
SDMTRLNO.addcoupling('mat','Jd','bond',6)
SDMTRLNO.addcoupling('mat','Je','bond',7)

% Creating the magnetic structure
SDMTRLNO.genmagstr('mode','direct','S',[0 0 0 0; 0 0 0 0; 1 1 -1 -1])
%SDMTRLNO.genmagstr('mode', 'helical', 'S', [1;1;0], 'k',[0 0 0], 'n', [0 0 1], 'nExt', [1 1 1])
plot(SDMTRLNO, 'range', [2 2 2], 'cellMode', 'inside', 'magColor', 'orange')

% Calculating the linear spin wave spectra
spec= SDMTRLNO.spinwave({[ 0.0  0.0  0.0] [ 0.5  0.0  0.0] [ 0.5  0.5  0.0] ...
    [ 0.0  0.5  0.0] [ 0.0  0.0  0.0] ...
    [ 0.0  0.0  0.5] [ 0.5  0.0  0.5] ...
    [ 0.5  0.5  0.5] [ 0.0  0.5  0.5] ...
    200}, 'hermit', true);

figure(2)
sw_plotspec(spec, 'mode', 'disp', 'imag', true, 'colormap', [0 0 0], 'colorbar', false)
%axis([0 2 0 70])

