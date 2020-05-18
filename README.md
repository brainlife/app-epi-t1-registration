[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.286-blue.svg)](https://doi.org/10.25663/brainlife.app.286)

# EPI T1 Registration 

This app will register DWI images to a T1 image, fit a tensor model, and create a dt6.mat file using FSL and Vistasoft. First, the dwi image is registered to the t1 image using FSL’s epi_reg and FLIRT by running the fslRegistration script. then, the dwi image is resliced back to the proper dimensions using dipy’s reslice function by running the reslice_fxn script. Next, the bvecs are rotated based on the flirt transformation by using Vistasoft’s dtiRawReorientBvecs function by running the rotateBvecs script. Then, the tensor model is fit using FSL’s dtifit function by running the fslDTIFIT script. Finally, the dt6 structure is generated using Vistasoft’s dtiMakeDt6FromFsl function by running the dt6FromFsl script. 

### Authors 

- Brad Caron (bacaron@iu.edu) 

### Contributors 

- Soichi Hayashi (hayashis@iu.edu) 

### Funding 

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations 

Please cite the following articles when publishing papers that used data, code or other resources created by the brainlife.io community. 

1. M. Jenkinson and S.M. Smith. A global optimisation method for robust affine registration of brain images. Medical Image Analysis, 5(2):143-156, 2001.
2. M. Jenkinson, P.R. Bannister, J.M. Brady, and S.M. Smith. Improved optimisation for the robust and accurate linear registration and motion correction of brain images. NeuroImage, 17(2):825-841, 2002. 

## Running the App 

### On Brainlife.io 

You can submit this App online at [https://doi.org/10.25663/brainlife.app.286](https://doi.org/10.25663/brainlife.app.286) via the 'Execute' tab. 

### Running Locally (on your machine) 

1. git clone this repo 

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files. 

```json 
{
   "t1":    "testdata/anat/t1.nii.gz",
   "dwi":    "testdata/dwi/dwi.nii.gz",
   "bvals":    "testdata/dwi/dwi.bvals",
   "bvecs":    "testdata/dwi/dwi.bvecs"
} 
``` 

### Sample Datasets 

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli). 

```
npm install -g brainlife 
bl login 
mkdir input 
bl dataset download 
``` 

3. Launch the App by executing 'main' 

```bash 
./main 
``` 

## Output 

The main output of this App is is an aligned DWI image. 

#### Product.json 

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies 

This App requires the following libraries when run locally. 

- FSL: 
- jsonlab: 
- SPM8: 
- singularity: 
- Python2: 
- Dipy: 
- Matlab: 
- Vistasoft: 
