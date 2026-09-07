function Yss = comp_ss_value(y,N)
    N = N;
    Yss = mean(y(end-N+N:end));
end