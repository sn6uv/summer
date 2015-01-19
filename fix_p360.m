addpath /home/angus/mpspack
s = segment.smoothnonsym(100, 0.3, 0.2, 3);
d = domain(s, 1);
s.setbc(-1, 'D');
p = evp(d);
d.addlayerpot(s, 'd');                              % DLP basis (Dirichlet BC)
% p.solvespectrum([50, 51], 'ntd');                   % Neumann2Dirichlet method
o.khat = '1'; o.eps = 0.1; p.solvespectrum([10 11], 'ntd', o);
p.weylcountcheck(p.kj(1), p.kj, d.perim, d.area);   % plot # modes vs expected
length(p.kj)                                        % number found eigenvalues
return
