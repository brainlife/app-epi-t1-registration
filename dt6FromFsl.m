function dt6FromFsl()

switch getenv('ENV')
case 'IUHPC'
  disp('loading paths (HPC)')
  addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
  addpath(genpath('/N/u/brlife/git/jsonlab'))
case 'VM'
  disp('loading paths (VM)')
  addpath(genpath('/usr/local/vistasoft'))
  addpath(genpath('/usr/local/jsonlab'))
end

config = loadjson('config.json');

b0FileName = fullfile(pwd,'nodif_acpc_mean.nii.gz');
t1FileName = config.t1;
outPathName = 'dt6';
autoAlign = false;

disp('creating dt6')
dt6 = dtiMakeDt6FromFsl(b0FileName,t1FileName,outPathName,autoAlign);

jsonStruct = [];
jsonStruct.files.b0 = fullfile(pwd,'dwi_aligned_trilin_b0.nii.gz');
jsonStruct.files.dt6 = dt6;
jsonStruct.files.t1 = config.t1;
jsonStruct.files.alignedDwRaw = fullfile(pwd,'dwi_aligned_trilin.nii.gz');
jsonStruct.files.alignedDwBvecs = fullfile(pwd,'dwi_aligned_trilin.bvecs');
jsonStruct.files.alignedDwBvals = fullfile(pwd,'dwi_aligned_trilin.bvals');


disp('creating dt6.json')
savejson('', jsonStruct, 'dt6.json');

exit;
end
