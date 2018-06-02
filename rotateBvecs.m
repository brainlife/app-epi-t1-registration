function out = rotateBvecs()

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

% Set directories
bvecs_pre = fullfile(config.bvecs);
outAcpcTransform = load(fullfile('nodif_acpc.mat'),'-ASCII');
outBvecs = fullfile('dwi.bvecs')

% Rotate bvecs
bvecs = dtiRawReorientBvecs(bvecs_pre,[],outAcpcTransform,outBvecs);
exit;
end
