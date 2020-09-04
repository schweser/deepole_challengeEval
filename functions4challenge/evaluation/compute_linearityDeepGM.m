function [ DGM_slope_ds ] = compute_linearityDeepGM(   chi_recon, chi_true, seg_ds , seg_labels)
% function [ DGM_slope_ds ] = compute_linearityDeepGM(   chi_recon, chi_true, seg_ds , seg_labels)
% computes the slope between the susceptibility groundtruth and the reconstruction when
% the mean values of the 6 different deep gray matter regions considered (averaged within region) 

k=0
for tissue= [1:6] % DGM happen to be the first 6 tissues of our label
    k=k +1;
    DGMmean_true_ds (k) = mean(chi_true(seg_ds==tissue));
    DGMmean_recon(k) = mean(chi_recon(seg_ds==tissue));
end

P = polyfit(DGMmean_true_ds,DGMmean_recon,1);
DGM_slope_ds = 1 * P(1);

