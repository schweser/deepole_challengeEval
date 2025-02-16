toolboxpath='/research/schweserbox/common_matlab/initialization/autocomp/';
addpath(toolboxpath);
initializeswitoolbox('docker');



inputDir = '/research/data/Sim2Snr1';
resultFolder = '/research/data/Sim2Snr1_custom';
mkdir(resultFolder)


echoTimes = [4,12,20,28];
fieldStrength = 7;

mask = load_nii_raw(fullfile(inputDir,'MaskBrainExtracted.nii'));
mag = load_nii_raw(fullfile(inputDir,'Magnitude.nii'));
phase = load_nii_raw(fullfile(inputDir,'Phase.nii'));

phase.setEchoTimes(echoTimes)
mag.setEchoTimes(echoTimes)

phase.setMagneticFieldStrength(fieldStrength)
mag.setMagneticFieldStrength(fieldStrength)

OptsC.mode = 'brain';
OptsC.magneticFieldStrength = fieldStrength;
[C,~,Cn,~,~,~,~,~,~,~,~,~,~,~,snr2] = combinemultiechophase(phase.clone,mag.clone,OptsC);

write_nii(C.img,fullfile(resultFolder,'frequency.nii')); 
write_nii(Cn.img,fullfile(resultFolder,'std.nii')); 
write_nii(snr2,fullfile(resultFolder,'snrMeasure.nii')); 


