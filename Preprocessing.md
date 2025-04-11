

## Get ROI segmentation from T1w image
* SLANT ("BrainColor")
* Desikan-killany ("Freesurfer default")
* Glasser ("hcpmmp1")

## Register Seg to B0 (T1 space to DWI space)

## Get 5-tissue type segmentation from T1w image
5ttgen freesurfer sub-4591_ses-adni2year1_dx-AD/aparc+aseg_inDWIspace.nii.gz sub-4591_ses-adni2year1_dx-AD/5ttmask_inDWIspace.nii.gz

## Get Grey matter - white matter boundary from 5TT image
5tt2gmwmi 5ttmask_inDWIspace.nii.gz gmwmSeed_inDWIspace.nii.gz

## Get response functions from DWI
dwi2response dhollander dwmri.nii.gz sfwm.txt gm.txt csf.txt -fslgrad dwmri.bvec dwmri.bval

## Get FODs using response functions
dwi2fod msmt_csd dwmri.nii.gz sfwm.txt wmfod.nii.gz -fslgrad dwmri.bvec dwmri.bval

## Run tractography with probablistic tracking and get connectomes and network properties

## Run tractography with deterministic tracking and get connectomes and network properties

## QA atlas

## QA Tracks
* mrview
* MI-Brain
