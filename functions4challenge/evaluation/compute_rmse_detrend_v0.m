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


% P(1) * chi_recon + P(2) ~= chi_true
P = polyfit(chi_recon, chi_true, 1);

res = polyval(P, chi_recon);

rmse_detrend = 100 * norm( res - chi_true ) / norm(chi_true);

P=P(1);

end