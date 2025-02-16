function [metrics OrthoRecon OrthoReconCalc] = EvaluateRecon_ChallengeMetrics ( Reconfile , inputfilesGT )
% function [metrics OrthoRecon OrthoReconCalc] = EvaluateRecon_ChallengeMetrics ( Reconfile , inputfilesGT )
% Reconfile is the nifti file obtained by the reconstruction pipeline
% inputfilesGT is a structure which contains the address of various files to be used as ground truth 



%% load data  
chi_recon = load_nii([Reconfile]);
chi_crop = load_nii([inputfilesGT.chi_crop]);
msk = load_nii([inputfilesGT.maskEroded]);
FinalSegment = load_nii([inputfilesGT.Segment]);

chi_recon = chi_recon.img;
chi_crop = chi_crop.img;
msk = single(msk.img);
FinalSegment = FinalSegment.img;

load(inputfilesGT.label,'label');

%% making sure there are no nans or infinites on the reconstruction
chi_recon(isnan(chi_recon))=0;
chi_recon(isinf(chi_recon))=0;

%% compute metrics


% crop is the most appropriate ground truth
% general metrics based on RMSE

[metrics.rmse, metrics.rmse_detrend] = compute_rmse_detrend_v1( chi_recon, chi_crop, msk );

%% Evaluate only GM WM AND THALAMUS
msk2 = msk;
msk2( or(FinalSegment < 7 , FinalSegment > 9 ) ) = 0 ;
 
 [~, metrics.rmse_detrend_Tissue] = compute_rmse_detrend_v1( chi_recon, chi_crop, msk2 );

%% Vessels Only

msk2 = msk;
msk2( (FinalSegment ~= 11) ) = 0;
msk2=dilatemask(msk2,1); % dilates vein mask

[~, metrics.rmse_detrend_Blood] = compute_rmse_detrend_v1( chi_recon, chi_crop, msk2 );

 %%  Deep Gray Matter

msk2 = msk;
msk2( (FinalSegment >= 7) ) = 0;
 
[~, metrics.rmse_detrend_DGM] = compute_rmse_detrend_v1( chi_recon, chi_crop, msk2 );

 [DGM_slope_ds] = ...
    compute_linearityDeepGM(   chi_recon , chi_crop , FinalSegment , label);

% 
metrics.DeviationFromLinearSlope = abs(1-DGM_slope_ds) ;

%% general Metrics SSIM and HFEN -  will not be used
%   [metrics.ssim] = compute_ssim( chi_recon.*msk, chi_crop.*msk);
%   [metrics.hfen] = compute_hfen( chi_recon.*msk, chi_crop.*msk);

%% Calcification metrics
% [ metrics.CalcMoment , metrics.CalcStreak] = compute_calcification_metrics_v0 ( chi_recon , chi_crop , FinalSegment , label );

[ CalcMoment , metrics.CalcStreak] = compute_calcification_metrics_v0 ( chi_recon , chi_crop , FinalSegment , label );

%  to ensure all the metrics have to be minimized, we calculate the
%  difference between calcification obtained from image and ground truth

metrics.DeviationFromCalcMoment =  abs(inputfilesGT.CalcMoment - CalcMoment) ;

%% geting some images with the overview of the reconstruction

figureJ(10)

xrange=find(sum(sum(msk,2),3)~=0);
yrange=find(sum(sum(msk,1),3)~=0);
zrange=find(sum(sum(msk,2),1)~=0);
subplot(211)
[ tmp,OrthoRecon]=Orthoview(chi_recon(xrange,yrange,zrange),[],[-0.1 0.1]);
title('Reconstruction')

%% tight range around 
tmp=single(FinalSegment==16);
xrange=find(sum(sum(tmp,2),3)~=0);
yrange=find(sum(sum(tmp,1),3)~=0);
zrange=find(sum(sum(tmp,2),1)~=0);
xrange=(xrange(1)-2):(xrange(end)+2);
yrange=(yrange(1)-2):(yrange(end)+2);
zrange=(zrange(1)-2):(zrange(end)+2);

subplot(212)
[ tmp2,OrthoReconCalc]=Orthoview(chi_recon(xrange,yrange,zrange),[],[-0.1 0.1]);
title('Reconstruction zoomed to the region where the calcification was present')


