addpath /home/angus/mpspack
n_div = 21;
n_min = 100;
n_max = 500;

k_div = 50;
k_min = 4;
k_max = 200;

ns = linspace(n_min, n_max, n_div);
ks = linspace(k_min, k_max, k_div);

repeats = 5;
timings = zeros(k_div, n_div);
colours = zeros(k_div, n_div);

        
for i = [1:k_div]
    k = ks(i);
    fprintf('\nk = %3i', k)
    for j = [1:n_div]
        n = ns(j);
        s = segment.smoothnonsym(n, 0.3, 0.2, 3);
        d = domain(s, 1);

        s.setbc(-1, 'D');
        p = evp(d);
        d.addlayerpot(s, 'd');                              % DLP basis (Dirichlet BC)
        o.eps = 0.1; o.verb = 0;
        tic
        for l = [1:repeats]
            p.solvespectrum([k, k+1], 'fd', o);   % Neumann2Dirichlet method
        end
        timings(i, j) = toc / repeats;
        % p.weylcountcheck(p.kj(1), p.kj, d.perim, d.area);   % plot # modes vs expected
        
        % set the colours
        fprintf('.')        
        % actual number of eigenvalues
        n_k = length(p.kj);
        
        % no eigenvalues found
        if n_k == 0
            colours(i,j) = -1;
            continue
        end
        
        % expected number of eigenmodes (weyl)
        a = d.area / (4*pi);
        b = -d.perim / (4*pi);
        k_lo = p.kj(1);
        k_hi = p.kj(length(p.kj));
        n_weyl = a*k_hi*k_hi + b*k_hi - (a*k_lo*k_lo + b*k_lo);
        % fprintf('%.3f\n, ', abs(n_weyl-n_k))

        
        % set colurs
        if abs(n_weyl - n_k) > 3
            colours(i,j) = -1;
        else
            colours(i,j) = 1;
        end
    end
end
surf(ns, ks, timings, colours)
colormap([1 0 0; 1 1 1])
xlabel('boundary points')
ylabel('k')
zlabel('time (s)')
% save('fd_run.out', 'ks', 'ns', 'timings', 'colours')
return