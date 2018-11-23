function dt6FromFsl()

switch getenv('ENV')
case 'IUHPC'
  disp('loading paths (HPC)')
  addpath(genpath('/N/u/brlife/git/vistasoft'))
  addpath(genpath('/N/u/brlife/git/jsonlab'))
  addpath(genpath('/N/u/brlife/git/spm'))
case 'VM'
  disp('loading paths (VM)')
  addpath(genpath('/usr/local/vistasoft'))
  addpath(genpath('/usr/local/jsonlab'))
  addpath(genpath('/usr/local/spm'))
end

config = loadjson('config.json');

b0FileName = fullfile(pwd,'nodif_acpc_mean.nii.gz');
b0 = niftiRead(b0FileName);
b0 = double(b0.data);
t1FileName = config.t1;
fa = niftiRead('fa.nii.gz');
fa = double(fa.data);
md = niftiRead('md.nii.gz');
md = double(md.data);
xformToAcpc = load('dwi_aligned_trilin_acpcXform.mat','-ASCII');
outPathName = 'dt6';
autoAlign = false;

disp('creating dt6')
[] = dtiMakeDt6FromFsl(b0FileName,t1FileName,outPathName,autoAlign);
dtiRawMakeVectorRgb('dt6.mat', fullfile(pwd,'dtiinit','dti','bin','vectorRGB.nii.gz'));
close(gcf);
wmProb = dtiFindWhiteMatterFsl(fa,md,b0);
dtiWriteNiftiWrapper(uint8(round(wmProb*255)),xformToAcpc,'dtiinit/dti/bin/wmProb.nii.gz',1./255);
clear dt6;

dt6 = dtiLoadDt6('dt6.mat');
dt6.files.b0 = fullfile(pwd,'dtiinit','dwi_aligned_trilin_b0.nii.gz');
dt6.files.t1 = config.t1;
dt6.files.brainMask = fullfile(pwd,'dtiinit','dti','bin','brainMask.nii.gz');
dt6.files.tensors = fullfile(pwd,'dtiinit','dti','bin','tensors.nii.gz');
dt6.files.wmMask = fullfile(pwd,'dtiinit','dti','bin','wmMask.nii.gz');
dt6.files.wmProb = fullfile(pwd,'dtiinit','dti','bin','wmProb.nii.gz');
dt6.files.vecRgb = fullfile(pwd,'dtiinit','dti','bin','vectorRGB.nii.gz');
dt6.files.alignedDwRaw = fullfile(pwd,'dtiinit','dwi_aligned_trilin.nii.gz');
dt6.files.alignedDwBvecs = fullfile(pwd,'dtiinit','dwi_aligned_trilin.bvecs');
dt6.files.alignedDwBvals = fullfile(pwd,'dtiinit','dwi_aligned_trilin.bvals');

jsonStruct = [];
jsonStruct.files.b0 = fullfile(pwd,'dtiinit','dwi_aligned_trilin_b0.nii.gz');
jsonStruct.files.dt6 = dt6.dt6;
jsonStruct.files.t1 = config.t1;
jsonStruct.files.brainMask = fullfile(pwd,'dtiinit','dti','bin','brainMask.nii.gz');
jsonStruct.files.tensors = fullfile(pwd,'dtiinit','dti','bin','tensors.nii.gz');
jsonStruct.files.wmMask = fullfile(pwd,'dtiinit','dti','bin','brainMask.nii.gz');
jsonStruct.files.wmProb = fullfile(pwd,'dtiinit','dti','bin','wmProb.nii.gz');
jsonStruct.files.vecRgb = fullfile(pwd,'dtiinit','dti','bin','vectorRGB.nii.gz');
jsonStruct.files.alignedDwRaw = fullfile(pwd,'dtiinit','dwi_aligned_trilin.nii.gz');
jsonStruct.files.alignedDwBvecs = fullfile(pwd,'dtiinit','dwi_aligned_trilin.bvecs');
jsonStruct.files.alignedDwBvals = fullfile(pwd,'dtiinit','dwi_aligned_trilin.bvals');

disp('creating dt6.json')
savejson('', jsonStruct, 'dt6.json');

exit;
end
