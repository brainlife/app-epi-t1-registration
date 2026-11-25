<h1 align="center">EPI T1 Registration</h1>

<p align="center">
  A diffusion-weighted image aligned to a T1-weighted anatomy, with rotated bvecs and the affine transform, using FSL epi_reg and FLIRT.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.286"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.286-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Registers DWI to a T1-weighted image with FSL epi_reg and flirt using the mean b0, optionally reslices it with DIPY, rotates the bvecs and outputs the aligned DWI and affine.**

Averages the b0 volumes, skull-strips them with bet, registers them to the T1 (optionally skull-stripped with bet first) using epi_reg, applies the transform to the whole DWI with flirt, optionally reslices to an isotropic resolution and rotates the bvecs. Use it to bring DWI into T1/ACPC space before tractography. The README also mentions tensor fitting and a dt6.mat, which this branch's code does not produce.

| | |
|---|---|
| **Inputs** | `neuro/dwi` · `neuro/anat/t1w` |
| **Outputs** | `neuro/dwi` · `neuro/transform/nifti` |
| **Container** | `brainlife/fsl:5.0.9` |
| **Resources** | 8 CPUs · 40 GB memory · 4 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.286](https://doi.org/10.25663/brainlife.app.286) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | The path to the DWI datatype |
| `t1` | `neuro/anat/t1w` | yes | The path to the anat/t1w datatype |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `dwi` | `neuro/dwi` | The T1-aligned DWI |
| `transform` | `neuro/transform/nifti` | Affine transform from DWI to T1 space (affine.txt, FSL flirt matrix). |

<details>
<summary><b>Parameters</b> (2)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `resolution` | string |  | The isotropic resolution to reslice the data. If you want to leave the DWI in the native DWI space, leave this empty |
| `maskt1` | boolean | `true` | If true, skull-strip the T1 with FSL bet before registration. |

</details>

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.286](https://doi.org/10.25663/brainlife.app.286), choose a `neuro/dwi` dataset and a T1-weighted image (`neuro/anat/t1w`) from your project, set the options and press **Execute**. The App writes a T1-aligned `neuro/dwi` dataset (tagged `t1_aligned`) and the DWI-to-T1 affine (`neuro/transform/nifti`, tagged `affine` and `dwi-to-t1`) to your project. Use it to bring DWI into T1 (for example ACPC-aligned) space before tensor fitting or tractography.

- **`maskt1`** (default `true`): skull-strip the T1 with FSL `bet` before registration. Turn it off if the T1 is already skull-stripped.
- **`resolution`**: an isotropic voxel size (mm) to reslice the aligned DWI to. Leave it empty to keep the DWI at its own resolution.

### How it works

1. The b0 volumes are extracted (`select_dwi_vols`), averaged (`fslmaths -Tmean`) and skull-stripped with `bet`.
2. The mean b0 is registered to the T1 with `epi_reg`, and the resulting transform is applied to the whole DWI series with `flirt -applyxfm`.
3. If `resolution` is set, the aligned DWI is resliced with DIPY.
4. The bvecs are rotated by the registration transform with vistasoft's `dtiRawReorientBvecs` (compiled MATLAB).

The previous version of this README also described tensor fitting and a `dt6.mat` output; the registered version of the App (branch `v1.0`) does not produce them.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The App uses the `brainlife/fsl:5.0.9`, `brainlife/dipy:0.14.2` and `brainlife/mcr:neurodebian1604-r2017a` containers.

1. Clone this repository and check out the registered version (`git checkout v1.0`).
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "t1": "./input/t1/t1.nii.gz",
       "dwi": "./input/dwi/dwi.nii.gz",
       "bvals": "./input/dwi/dwi.bvals",
       "bvecs": "./input/dwi/dwi.bvecs",
       "maskt1": true,
       "resolution": ""
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

### Sample data

Download a T1-weighted image and a DWI from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download 5b96bbbf059cf900271924f2 && mv 5b96bbbf059cf900271924f2 input/t1
bl dataset download 5b96bbf2059cf900271924f3 && mv 5b96bbf2059cf900271924f3 input/dwi
```

## Outputs

```text
dwi/
├── dwi.nii.gz     DWI aligned to the T1
├── dwi.bvals      b-values
└── dwi.bvecs      bvecs rotated by the registration
transform/
└── affine.txt     DWI-to-T1 affine (FSL FLIRT matrix)
```

## Troubleshooting

- **`output missing`**: the aligned `dwi.nii.gz` was not produced. Check the log for `epi_reg` or `flirt` errors; poor brain extraction of the b0 or the T1 is a common cause (try toggling `maskt1`).

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Jenkinson M, Smith SM. A global optimisation method for robust affine registration of brain images. *Medical Image Analysis* 5(2):143–156 (2001).
- Jenkinson M, Bannister PR, Brady JM, Smith SM. Improved optimisation for the robust and accurate linear registration and motion correction of brain images. *NeuroImage* 17(2):825–841 (2002).
- EPI T1 Registration. brainlife.io App. [doi:10.25663/brainlife.app.286](https://doi.org/10.25663/brainlife.app.286)
- Jenkinson M, Smith SM. A global optimisation method for robust affine registration of brain images. Medical Image Analysis 5(2):143-156 (2001).
- Jenkinson M, Bannister PR, Brady JM, Smith SM. Improved optimisation for the robust and accurate linear registration and motion correction of brain images. NeuroImage 17(2):825-841 (2002).
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Garyfallidis et al. Dipy, a library for the analysis of diffusion MRI data. *Frontiers in Neuroinformatics* 8 (2014). [doi:10.3389/fninf.2014.00008](https://doi.org/10.3389/fninf.2014.00008)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Brad Caron
- Franco Pestilli (project director)

**Contributors:** Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

MIT (see the [`LICENSE`](https://github.com/brainlife/app-epi-t1-registration/blob/v1.0/LICENSE) file on the `v1.0` branch). FSL is distributed under its own [license](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).
