addpath /home/angus/mpspack
s = segment.smoothnonsym(200, 0.3, 0.2, 3);
d = domain(s, 1);
s.setbc(-1, 'D');
p = evp(d);
d.addlayerpot(s, 'd');                              % DLP basis (Dirichlet BC)
o.eps = 0.1; p.solvespectrum([50, 51], 'ntd', o);   % Neumann2Dirichlet method
p.weylcountcheck(p.kj(1), p.kj, d.perim, d.area);   % plot # modes vs expected
fprintf('\nfound %i eigenvalues\n', length(p.kj))
return