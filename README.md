[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.37-blue.svg)](https://doi.org/10.25663/bl.app.37)

# app-epi-t1-registration
This app will register DWI images to a T1 image, fit a tensor model, and create a dt6.mat file using FSL and Vistasoft. First, the dwi image is registered to the t1 image using FSL's epi_reg and FLIRT by running the fslRegistration script. then, the dwi image is resliced back to the proper dimensions using dipy's reslice function by running the reslice_fxn script. Next, the bvecs are rotated based on the flirt transformation by using Vistasoft's dtiRawReorientBvecs function by running the rotateBvecs script. Then, the tensor model is fit using FSL's dtifit function by running the fslDTIFIT script. Finally, the dt6 structure is generated using Vistasoft's dtiMakeDt6FromFsl function by running the dt6FromFsl script.

### Authors
- Brad Caron (bacaron@iu.edu)

### Contributors
- Soichi Hayashi (hayashi@iu.edu)
- Franco Pestilli (franpest@indiana.edu)

### Funding
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/bl.app.37](https://doi.org/10.25663/bl.app.37 via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
        "t1": "./input/t1/t1.nii.gz",
        "dwi": "./input/dwi/dwi.nii.gz",
        "bvals": "./input/dwi/dwi.bvals",
        "bvecs": "./input/dwi/dwi.bvecs"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5b96bbbf059cf900271924f2 && mv 5b96bbbf059cf900271924f2 input/t1
bl dataset download 5b96bbf2059cf900271924f3 && mv 5b96bbf2059cf900271924f3 input/dwi

```


3. Launch the App by executing `main`

```bash
./main
```

## Output

The main output of this App is dt6.mat structure that can be used in any apps requiring a dtiinit input.

#### Product.json
The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App requires the following libraries when run locally.

  - singularity: https://singularity.lbl.gov/
  - VISTASOFT: https://github.com/vistalab/vistasoft/
  - SPM 8: https://www.fil.ion.ucl.ac.uk/spm/software/spm8/
  - Freesurfer: https://hub.docker.com/r/brainlife/freesurfer/tags/6.0.0
  - FSL: https://hub.docker.com/r/brainlife/fsl/tags/5.0.9
  - Dipy: https://hub.docker.com/r/brainlife/dipy/tags/0.13.0
  - jsonlab: https://github.com/fangq/jsonlab.git

