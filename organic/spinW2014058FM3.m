clear
close all

% Creating the lattice
a0 = 1.000  % Angstrom
%a0 = 0.52917721067  % Angstrom
avec_Ang = [7.287 7.962 9.583]
avec = avec_Ang / a0
SDMTRLNO = spinw;
SDMTRLNO.genlattice('lat_const', avec,'angled',[75.643 76.678 89.697],'sym','P -1');
plot(SDMTRLNO)

% Adding atoms
SDMTRLNO.addatom('r',[1.000  1.000  1.000],'S',2.000,'label','Mn ','color','b')
plot(SDMTRLNO)

% Creating the Spin-Hamiltonian
SDMTRLNO.gencoupling('maxDistance',50)
SDMTRLNO.table('bond',1:50)

mRy_ev=1.00
%mRy_ev=13.6
J1=-1.00*mRy_ev
Ja = 0.28*mRy_ev
Jb = -0.13*mRy_ev
Jc = 0.04*mRy_ev
Jd = -0.01*mRy_ev
Je = -0.01*mRy_ev
Jf = 0.01*mRy_ev


SDMTRLNO.addmatrix('label','J1','value',J1,'color','black')
%SDMTRLNO.addmatrix('label','Ja','value',Ja,'color','black')
%SDMTRLNO.addmatrix('label','Jb','value',Jb,'color','red')
%SDMTRLNO.addmatrix('label','Jc','value',Jc,'color','green')
%SDMTRLNO.addmatrix('label','Jd','value',Jd,'color','yellow')
%SDMTRLNO.addmatrix('label','Je','value',Je,'color','blue')
%SDMTRLNO.addmatrix('label','Jf','value',Jf,'color','orange')

SDMTRLNO.addcoupling('mat','J1','bond',1)
SDMTRLNO.addcoupling('mat','J1','bond',2)
SDMTRLNO.addcoupling('mat','J1','bond',3)
%SDMTRLNO.addcoupling('mat','Ja','bond',1)
%SDMTRLNO.addcoupling('mat','Jb','bond',12)
%SDMTRLNO.addcoupling('mat','Jc','bond',44)
%SDMTRLNO.addcoupling('mat','Jd','bond',6)
%SDMTRLNO.addcoupling('mat','Je','bond',4)
%SDMTRLNO.addcoupling('mat','Jf','bond',2)


% Creating the magnetic structure
SDMTRLNO.genmagstr('mode', 'helical', 'S', [1;0;0], 'k',[0 0 0], 'n', [0 0 1], 'nExt', [1 1 1])
plot(SDMTRLNO, 'range', [3 3 1/2], 'cellMode', 'inside', 'magColor', 'red')
spec= SDMTRLNO.spinwave({[ 0.0 -0.5  0.0] [ 0.0  0.0  0.0] [ 0.5  0.0  0.0] ...
    [ 0.5  0.5  0.0] [ 0.0  0.0  0.0] ...
    500}, 'hermit', true);
%spec= SDMTRLNO.spinwave({[ 0.0 -0.5  0.0] [ 0.0  0.0  0.0] ...
%    [ 0.0  0.0  0.0] [ 0.5  0.0  0.0] ...
%    [ 0.5 -0.5  0.0] [ 0.0  0.0  0.0] ...
%    [ 0.0  0.0  0.0] [-0.5  0.0  0.5] ...
%    [-0.5 -0.5  0.5] [ 0.0  0.0  0.0] ...
%    [ 0.0  0.0  0.0] [ 0.0  0.0  0.5] ...
%    [ 0.0 -0.5  0.5] [ 0.0  0.0  0.0] ...
%    500}, 'hermit', true);

figure(2)
sw_plotspec(spec, 'mode', 'disp', 'imag', true, 'colormap', [0 0 0], 'colorbar', false)
%axis([0 1 0 5])

