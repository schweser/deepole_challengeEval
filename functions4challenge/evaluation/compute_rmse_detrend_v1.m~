function [ rmse, rmse_detrend, P] = compute_rmse_detrend_v0( chi_recon, chi_true , msk)
% function [ rmse, rmse_detrend, P] = compute_rmse_detrend_v0( chi_recon, chi_true , msk)
% computes the RMSE bewteen two ND vectors in the region where the ND
% matrix msk is not equal to zero.
% rmse          is the normalized root mean square error after demeaning 
%               both the reconstruction and the ground truth 
% rmse_detrend  is the normalized root mean square error after demeaning and
%               detrending (often QSM algorithms tend to underestimate the true value of 
%               susceptibility once a regularization is introduced)
% P             % min ||P(1) * chi_recon + P(2) - chi_true||



% demeaning
chi_recon = chi_recon(msk~=0) - mean(chi_recon(msk~=0));
chi_true  = chi_true(msk~=0) - mean(chi_true(msk~=0));

% rmse calculation after demeaning in the masked region
rmse = 100 * norm( chi_recon  -  chi_true ) / norm(chi_true);

% giving the same weight to both sides
% coeffpca = pca(cat(2,chi_recon, chi_true))
% res = chi_recon * coeffpca(1,1)/coeffpca(1,2);


% P1(1) * chi_true + P1(2) = chi_recon
% 1/P1(1) * chi_recon -P1(2)/P1(1) = chi_true
P1 = polyfit(chi_true, chi_recon,  1);
P(1) = 1 / P1(1);
P(2) = -P1(2) / P1(1);

res = polyval(P1, chi_recon);


rmse_detrend = 100 * norm( res - chi_true ) / norm(chi_true);

P=P(1);

end