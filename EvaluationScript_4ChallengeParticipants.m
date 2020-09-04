% function EvaluationScript_4ChallengeParticipants()

baseDir = '/research/';

% add functions to path
addpath(genpath(fullfile(baseDir,'scripts','functions4challenge')))


ReconName = fullfile(baseDir,'data','original_1b_chi_est_ppm.nii.gz');
ReconName = fullfile(baseDir,'data','originalCoClip_1b_chi_est_ppm.nii.gz');
ReconName = fullfile(baseDir,'data','original_deepqsm102__1b_chi_est_ppm.nii.gz');
ReconName = fullfile(baseDir,'data','original_deepqsm102Clip__1b_chi_est_ppm.nii.gz');


%%

% loading a structure that knows all about where the ground truth for the
% different models is

GTName    = fullfile(baseDir,'data','Sim2Snr1','GT','FilestructureForEval.mat');
GroundTruth = load(GTName,'filesstructure');

% compute the various metrics for each of the reconstructions models
% Sim1 and Sim2
% 'rmse'
% 'rmse_detrend'
% 'rmse_detrend_Tissue'
% 'rmse_detrend_Blood'
% 'rmse_detrend_DGM'
% 'DeviationFromLinearSlope'
% 'CalcStreak'               - only relevant for Sim2
% 'DeviationFromCalcMoment'  - only relevant for Sim2

cd(fullfile(baseDir,'data'))
ReconMetrics_Sim2 = EvaluateRecon_ChallengeFinalMetrics	 (ReconName,GroundTruth.filesstructure);
ReconMetrics_Sim2