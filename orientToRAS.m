function [] = orientToRAS()

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

dwRaw = niftiRead(config.dwi);
bvals = dlmread(config.bvals);
bvecs = dlmread(config.bvecs);
bvecXform = eye(3);

[dw,canXform] = niftiApplyCannonicalXform(dwRaw);

bvecXform = bvecXform * canXform(1:3,1:3);

for ii=1:size(bvecs,2) 
    bvecs(:,ii) = bvecXform * bvecs(:,ii);
end

niftiWrite(dw,'dwi.nii.gz');
dlmwrite('dwi.bvecs',bvecs);

exit;
end








