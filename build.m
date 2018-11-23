addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/spm'))
mcc -m -R -nodisplay -d compiled rotateBvecs
mcc -m -R -nodisplay -d dt6 dt6FromFsl
mcc -m -R -nodisplay -d orient orientToRAS
exit
