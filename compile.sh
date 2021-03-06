#!/bin/bash
module load matlab/2017a

mkdir compiled
mkdir dt6

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/spm'))
mcc -m -R -nodisplay -d compiled rotateBvecs
mcc -m -R -nodisplay -d dt6 dt6FromFsl
exit
END
matlab -nodisplay -nosplash -r build
