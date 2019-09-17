s = spinw();
s.genlattice('lat_const', [7.7915, 7.7915, 16.5088], 'angled', [90,  90,  90], 'sym', 19)
s.addatom('r', [0.08183, 0.80958, 0.37295], 'S', 1, 'label', 'Co3+', 'color','b')
s.plot()

s.gencoupling('maxDistance', 50)
s.table('bond',1:50)

s.addmatrix('label', 'J1', 'value', 2*6.92)
s.addmatrix('label', 'J2', 'value', 2*6.90)
s.addmatrix('label', 'J3', 'value', -2*0.08)
s.addmatrix('label', 'J4', 'value', -2*0.07)
s.addmatrix('label', 'J5', 'value', -2*0.05)

s.addcoupling('mat','J1','bond',2)
s.addcoupling('mat','J2','bond',1)
s.addcoupling('mat','J3','bond',9)
s.addcoupling('mat','J4','bond',7)
s.addcoupling('mat','J5','bond',8)

s.plot()

s.genmagstr('mode', 'direct', 'S', [0 0 0 0; 0 0 0 0; 1 1 -1 -1])
s.plot()

spec = s.spinwave({[ 0 0 0 ], [ 0.5 0 0 ], [ 0.5 0.5 0 ], 500});
figure
sw_plotspec(spec, 'mode', 'disp', 'imag', true, 'colormap', [0 0 0], 'colorbar', false)
