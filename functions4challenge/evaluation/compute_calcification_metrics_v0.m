
function [calcificationMoment,steaktingArtifactLevelMetric] = compute_calcification_metrics( chi_recon , chi_true , seg_ds , seg_labels)
% function [calcificationMoment,steaktingArtifactLevelMetric] = compute_calcification_metrics( chi_recon , chi_true , seg_ds , seg_labels)

%% calcification
tissue= [16];
dims = size(seg_ds);
calc_mask = single(seg_ds==tissue);
%%

%creating a box around calcification N voxel larger in each direction, this will allow computing correlation or dice coefficients
N=3;
calc_mask = single(seg_ds==tissue);

ROIx=find(max(max(calc_mask,[],2),[],3));
ROIx=(ROIx(1)-N):(ROIx(end)+N);

ROIy=find(max(max(calc_mask,[],1),[],3));
ROIy=(ROIy(1)-N):(ROIy(end)+N);

ROIz=find(max(max(calc_mask,[],1),[],2));
ROIz=(ROIz(1)-N):(ROIz(end)+N);

squareAroundCalcification=zeros(dims);
squareAroundCalcification(ROIx,ROIy,ROIz)=1; % roi has three voxels arround the region of interest
N=4;
ROIx=(ROIx(1)-N):(ROIx(end)+N);
ROIy=(ROIy(1)-N):(ROIy(end)+N);
ROIz=(ROIz(1)-N):(ROIz(end)+N);
rimMask=zeros(dims);
rimMask(ROIx,ROIy,ROIz)=1;
rimMask=rimMask-squareAroundCalcification;

N=4;
ROIx=(ROIx(1)-N):(ROIx(end)+N);
ROIy=(ROIy(1)-N):(ROIy(end)+N);
ROIz=(ROIz(1)-N):(ROIz(end)+N);
maskCloseU=zeros(dims);
maskCloseU(ROIx,ROIy,ROIz)=1;

qsmCube = chi_recon (squareAroundCalcification==1);
qsmNoCube = chi_recon (squareAroundCalcification==0 & maskCloseU==1);


% determine best threshold

clear volumeVec
thresholds = 0:-0.01:-1.5; % keep in mind that masked region is 0
for jThreshold = 1:numel(thresholds)
    volumeVec(jThreshold) = nnz(qsmCube < thresholds(jThreshold)); 
    % number of voxels where QSM values is smaller than threshold inside the ROI
    volumeOutsideVec(jThreshold) = nnz(qsmNoCube < thresholds(jThreshold));
    % number of voxels where QSM values is smaller than threshold outside the ROI
end

indexWithNosegmentationOutsideCube = find(volumeOutsideVec==0);
thresholdUse = thresholds(indexWithNosegmentationOutsideCube(1));

% analyze

calcificationSegmented = qsmCube < thresholdUse; % defines some sort of segmentation that might be too large..
calcificationVolume = nnz(calcificationSegmented);

calcificationMoment = calcificationVolume .* mean(qsmCube(calcificationSegmented)); 
calcificationMoment = calcificationVolume .* mean((qsmCube(calcificationSegmented))); 
% mean of susceptibility inside the region * volume segmented

P = polyfit(chi_true(rimMask==1), chi_recon(rimMask==1), 1);
res = polyval(P, chi_true);
% Looks at the standard deviation in a rim region once any suscepibility
% related variations have been regressed out. Furthermore this errors are
% normalized by the calcification moment to make sure that over regularized
% solutions are not overrated.
steaktingArtifactLevelMetric = std(chi_recon(rimMask==1)-res(rimMask==1)) / abs(mean(qsmCube(calcificationSegmented)));





