#!/bin/bash

## This will register the dwi image to the T1 using FSL epi_reg and flirt (M. Jenkinson and S.M. Smith. A global optimisation method for robust affine registration of brain images. Medical Image Analysis, 5(2):143-156, 2001;
## M. Jenkinson, P.R. Bannister, J.M. Brady, and S.M. Smith. Improved optimisation for the robust and accurate linear registration and motion correction of brain images. NeuroImage, 17(2):825-841, 2002; 
## https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FLIRT/UserGuide).

echo "Setting file paths"
# Grab the config.json inputs
bvals=`jq -r '.bvals' config.json`;
t1=`jq -r '.t1' config.json`;
echo "Files loaded"

if [ -f "dwi.bvals" ];then
	echo "File exists. Skipping copying of bvals file"
else
	echo "Copying bvals file"
	
	# Copy bvals file
	cp ${bvals} dwi.bvals;
	
	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Copying failed"
		echo $ret > finished
		exit $ret
	fi
fi


if [ -f "t1_brain.nii.gz" ]; then
	echo "File exists. Skipping T1 brain extraction"
else
	echo "T1 brainmask creation"
	bet ${t1} \
		t1_brain \
		-B \
		-f 0.1 \
		-g 0 \
		-m;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "T1 brain extraction failed"
		echo $ret > finished
		exit $ret
	fi
fi

if [ -f "nodif_brain.nii.gz" ]; then
	echo "File exists. Skipping b0 brainmask creation."
else	
	echo "Creating b0 brainmask for alignment"
	# Create b0 image
	select_dwi_vols \
		dwi.nii.gz \
		${bvals} \
		nodif.nii.gz \
		0;

	## Create mean b0 image
	fslmaths nodif \
		-Tmean \
		nodif_mean;

	# Brain extraction before alignment
	bet nodif_mean.nii.gz \
		nodif_brain \
		-f 0.4 \
		-g 0 \
		-m;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "b0 brainmask creation failed"
		echo $ret > finished
		exit $ret
	fi
fi
echo "b0 brainmask creation complete"

if [ -f "nodif_acpc.nii.gz" ];then
	echo "Registered file exists"
else
	echo "EPI Image to T1 Registration"
	epi_reg \
		--epi=nodif_brain \
		--t1=${t1} \
		--t1brain=t1_brain \
		--out=nodif_acpc;

	flirt \
		-ref nodif_acpc \
		-in dwi.nii.gz \
		-applyxfm \
		-init nodif_acpc.mat \
		-out dwi.nii.gz;
	
	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Registration failed"
		echo $ret > finished
		exit $ret
	fi
fi
echo "Registration complete"


