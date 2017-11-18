function out = rotateBvecs()

switch getenv('ENV')
case 'IUHPC'
  disp('loading paths (HPC)')
  addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
case 'VM'
  disp('loading paths (VM)')
  addpath(genpath('/usr/local/vistasoft'))
end

config = loadjson('config.json');

% Set directories
bvecs_pre = fullfile(config.bvecs);
outAcpcTransform = load(fullfile('nodif_acpc.mat'),'-ASCII');
outBvecs = fullfile('dwi.bvecs')

% Rotate bvecs
bvecs = dtiRawReorientBvecs(bvecs_pre,[],outAcpcTransform,outBvecs);
exit;
end
