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

b0FileName = fullfile(pwd,'nodif_acpc_mean.nii.gz');
t1FileName = fullfile(pwd,'t1.nii.gz');
outPathName = 'dt6';
autoAlign = false;

disp('creating dt6')
dt6 = dtiMakeDt6FromFsl(b0FileName,t1FileName,outPathName,autoAlign);

disp('creating dt6.json')
savejson('', dt6, 'dt6.json');

exit;
end