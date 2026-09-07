function Q = NRMSE(ye,ys)
    Ny = length(ye);
    Q = 100*sqrt(sum((ye-ys).^2)/Ny)/(max(ye)-min(ye));
end