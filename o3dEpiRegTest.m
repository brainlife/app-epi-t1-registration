function [] = o3dEpiRegTest()

% load appropriate repos
addpath(genpath('/usr/local/vistasoft'));
addpath(genpath('/usr/local/spm12'));
addpath(genpath('/usr/local/jsonlab'));
addpath(genpath('/usr/local/app-life'));
addpath(genpath('/usr/local/encode'));

% load dt6.mat and aligned dwi files
dt = dtiLoadDt6(fullfile('dti','dt6.mat'));
aligned_dwi = 'dwi_aligned_trilin.nii.gz';

% perform basic AFQ tracking
fg = AFQ_WholebrainTractography(dt);

% fit life on AFQ tractogram
life_discretization = 360;
num_iterations = 100;
[fe,out] = life(fg,aligned_dwi,life_discretization,num_iterations);

% run AFQ segmentation on life fe structure
remove_zero_weighted_fibers = 'before';
useinterhemisphericsplit = false;
afqSegmentation(fe,remove_zero_weighted_fibers,useinterhemisphericsplit);




