#!/bin/bash

## This will fit the tensor to the aligned dwi data using FSL dtifit(https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT).

if [ -f "nodif_acpc_L1.nii.gz" ];then
	echo "File exists. Skipping tensor fit"
else
	echo "Fitting tensor model"
	## create b0 image
	select_dwi_vols \
		dwi.nii.gz \
		dwi.bvals \
		nodif_acpc.nii.gz \
		0;

	## Create mean b0 image
	fslmaths nodif_acpc.nii.gz \
		-Tmean \
		nodif_acpc_mean;

	## creates brainmask for DTIFIT
	bet nodif_acpc_mean.nii.gz \
		nodif_acpc_mean_brain \
		-f 0.4 \
		-g 0 \
		-m;

	## fits tensor model
	dtifit --data=dwi \
		--out=nodif_acpc \
		--mask=nodif_acpc_mean_brain_mask \
		--bvecs=dwi.bvecs \
		--bvals=dwi.bvals;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Tensor fit failed"
		echo $ret > finished
		exit $ret
	fi
fi

cp dwi.nii.gz dwi_aligned_trilin.nii.gz;
cp dwi.bvecs dwi_aligned_trilin.bvecs;
cp dwi.bvals dwi_aligned_trilin.bvals;
cp nodif_acpc_mean.nii.gz dwi_aligned_trilin_b0.nii.gz;
mv nodif_acpc.mat dwi_aligned_trilin_acpcXform.mat;

echo "Registration Pipeline Complete"
