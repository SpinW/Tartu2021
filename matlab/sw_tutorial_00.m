%% Install SpinW
% Download the latest version of SpinW from https://github.com/SpinW/spinw/releases
% Or use the Add-ons option on the MATLAB toolbar.
% Unzip the file and run install_spinw from the main directory
%
% Verify that spinw is installed:

s = spinw();

%% Help on SpinW
% Use the help command to get help on any SpinW function. For any function
% that starts with 'sw_' use help swfiles, for spinw class methods use help
% spinw.function_name. For help on plotting commands, use help swplot.

help swfiles

% To find the location of the spinw library use
sw_rootdir

% To open any of the functions in the Matlab editor, use
edit spinw.plot

% To look at any of the spinw object properties, double click on the
% "Workspace" view on the name of the object. Also the data files
% (symmetry.dat, atom.dat, color.dat, magion.dat) can be easily edited, for
% example

edit symmetry.dat

%% Spin wave spectrum of the Heisenberg ferromagnetic nearest-neighbor spin chain 
% The following tutorial shows every step necessary to calculate spin wave
% spectrum through the simple example of the ferromagnetic spin chain
%
% The steps to perform a spinw computation are:
% - Define a lattice with atoms
% - Define an exchange structure to generate a Hamiltonian
% - Define a magnetic structure
%
% Then we can compute the spin-spin correlation functions and the cross
% section. This example is analogous to what was covered in Kim's lecture.


%% Define spin chain with magnetic atoms
% The shortest lattice parameter along the a-axis will give the first
% neighbor bonds along this axis. After defining the lattice, we add a
% magnetic Cu+ ion with spin S=1 at the origin of the unit cell and plot
% the lattice.

FMchain = spinw; 
FMchain.genlattice('lat_const', [3 8 8], 'angled', [90 90 90])
FMchain.addatom('r', [0 0 0], 'S', 1, 'label', 'MCu1', 'color', 'blue')
FMchain.plot('range',[3 1 1])

%% Determine the list of bonds based on length
% To consider bonds up to 7 Angstrom length we use the sw.gencoupling()
% function. Since no symmetry operators are defined, it sorts all bonds
% according to increasing length, all bonds are equivalent that has the
% same length within an error bar (0.001 Angstrom by default).

FMchain.gencoupling('maxDistance', 7)

% list the 1st and 2nd neighbor bonds
FMchain.table('bond', 1:2)

%% Defining the spin Hamiltonian
% We create a matrix with a label 'Ja', ferromagnetic heisenberg
% interaction, J = -1 meV and assing it to the first neghbor bonds as
% spin-spin exchange interaction: J*S(i)*S(i+1). And plot the crystal
% structure with the added bonds.
 
FMchain.addmatrix('value', -1, 'label', 'Ja', 'color', 'green')
% Notice we have created a 3x3 matrix for the exchange. This can be used
% for arbitary exchanges. If a single value is used, a heisenberg exchange
% is created.
FMchain.addcoupling('mat', 'Ja', 'bond', 1);
plot(FMchain, 'range', [3 0.2 0.2], 'cellMode', 'none', 'baseMode', 'none')

%% Definition of FM magnetic structure
% The classical magnetic ground state of the previously defined Hamiltonian
% is where every spin have the same direction, the direction is arbitrary
% since the Hamiltonian is isotropic. We use the following parameters:
%
% * magnetic ordering wave vector k = (0 0 0)
% * there is a single spin per unit cell S = [0 1 0]
% * an arbitrary normal vector to the spin n = [1 0 0]
%

FMchain.genmagstr('mode', 'direct', 'k', [0 0 0], 'n', [1 0 0], 'S', [0; 1; 0]); 

disp('Magnetic structure:')
FMchain.table('mag')
plot(FMchain,'range', [3 0.9 0.9], 'baseMode', 'none', 'cellMode', 'none')

%% The energy of the ground state per spin
% The spinw.energy() function gives the ground state energy per spin, the
% value is dinamically calculated at every call.

FMchain.energy()

%% Calculate spin wave dispersion and spin-spin correlation function
% We calculate spin wave dispersion and correlation function along the
% chain, momentum transfer value is Q = (H 0 0). Then we calculate the
% neutron scattering cross section and select 'Sperp' the neutron
% scattering intensity for plotting. Then we plot spin wave dispersion and
% the value of the correlation function with the 1-Q^2 neutron scattering
% cross section in units of hbar/spin.

FMspec = FMchain.spinwave({[0 0 0], [1 0 0], 200});
FMspec = sw_neutron(FMspec); 
FMspec = sw_egrid(FMspec, 'component', 'Sperp');

figure;
subplot(2, 1, 1)
sw_plotspec(FMspec, 'mode', 1, 'colorbar', false)  
axis([0 1 0 5])
subplot(2, 1, 2)
sw_plotspec(FMspec, 'mode', 2)  
axis([0 1 0 2])
swplot.subfigure(1, 3, 1)

%% Calculate powder average spectrum
% We calculate powder spectrum for Q = 0:2.5 Angstrom^-1 100 steps
% resolution 1000 random Q points for every step. Then we plot the spectrum
% convoluted with 0.1 meV Gaussian along energy.

FMpowspec = FMchain.powspec(linspace(0, 2.5, 100), ...
    'Evect', linspace(0, 4.5, 250), 'nRand', 1000, 'hermit', false);

figure;
sw_plotspec(FMpowspec, 'dE', 0.1)
axis([0 2.5 0 4.5]);
caxis([0 .05]);

%% Obtaining Kim's result
% If you have the symbolic toolbox installed you can obtain the result from
% Kim's lecture on spin-waves. To do this we convert the Hamiltonian into
% its symbolic form and then solve. In simple cases like this we can do
% this and get an inteligable result.

% Copy the spinw object
FMchainSymbolic = FMchain.copy();
% Convert into symbolic
FMchainSymbolic.symbolic(true)
% General solve the Hamiltonian
FMspecSymbolic = FMchainSymbolic.spinwave();
% Obtain Kim's result
FMspecSymbolic.omega(1)
% Notice we get 2 solutions, for +'ve and -ve energies.

% We can also visualise the result.
h  = linspace(0, 1, 501);
Ja = -1;
w = real(eval(FMspecSymbolic.omega(1)));

figure
plot(h, w)
xlabel('(H,0,0) in r.l.u.')
ylabel('Energy (meV)')
title('Spin wave dispersion of FM chain, Ja = -1, S = 1', 'fontsize', 15)

