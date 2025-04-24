

## Get ROI segmentation from T1w image
* SLANT ("BrainColor")
* Desikan-killany ("Freesurfer default")
* Glasser ("hcpmmp1")

## Register Seg to B0 (T1 space to DWI space) using pre-computed transforms (from ADSP EVE atlas registration)
```
bash applytransform_atlas.sh atlas.nii.gz WMAtlasEVE3/
```
## Get 5-tissue type segmentation from T1w image
```
5ttgen freesurfer sub-4591_ses-adni2year1_dx-AD/aparc+aseg_inDWIspace.nii.gz sub-4591_ses-adni2year1_dx-AD/5ttmask_inDWIspace.nii.gz
```
## Get Grey matter - white matter boundary from 5TT image
```
5tt2gmwmi 5ttmask_inDWIspace.nii.gz gmwmSeed_inDWIspace.nii.gz
```
## Get response functions from DWI
```
dwi2response dhollander dwmri.nii.gz sfwm.txt gm.txt csf.txt -fslgrad dwmri.bvec dwmri.bval
```
## Get FODs using response functions
```
dwi2fod msmt_csd dwmri.nii.gz sfwm.txt wmfod.nii.gz -fslgrad dwmri.bvec dwmri.bval
```
## Run tractography with probablistic tracking and get connectomes and network properties
```
bash tractrography_prob.sh  [INPUTDIR (path)] [OUTPUTDIR (path)] [PREQUALDIR (path)] [NUMSTREAMS (integer)] [ITERATION (integer)]
(example) bash tractrography_prob.sh /home-local/WIEE/Inputs/sub-4802_ses-adni2year1_dx-AD/ /home-local/WIEE/Outputs/sub-4802_ses-adni2year1_dx-AD/ /nfs2/harmonization/BIDS/ADNI_DTI/derivatives/sub-4802/ses-adni2year1/PreQual/PREPROCESSED/../ 1000 1
```
## Run tractography with deterministic tracking and get connectomes and network properties
```
bash tractrography_determ.sh [INPUTDIR (path)] [OUTPUTDIR (path)] [PREQUALDIR (path)] [NUMSTREAMS (integer)] [ITERATION (integer)]
(example) bash tractrography_determ.sh /home-local/WIEE/Inputs/sub-4802_ses-adni2year1_dx-AD/ /home-local/WIEE/Outputs/sub-4802_ses-adni2year1_dx-AD/ /nfs2/harmonization/BIDS/ADNI_DTI/derivatives/sub-4802/ses-adni2year1/PreQual/PREPROCESSED/../ 1000 1
```
## Run tractography with probablisic tracking and SIFT2 Weighting and get connectomes and network properties
```
bash tractrography_sift2.sh  [INPUTDIR (path)] [OUTPUTDIR (path)] [PREQUALDIR (path)] [NUMSTREAMS (integer)] [ITERATION (integer)]
(example) bash tractrography_sift2.sh /home-local/WIEE/Inputs/sub-4802_ses-adni2year1_dx-AD/ /home-local/WIEE/Outputs/sub-4802_ses-adni2year1_dx-AD/ /nfs2/harmonization/BIDS/ADNI_DTI/derivatives/sub-4802/ses-adni2year1/PreQual/PREPROCESSED/../ 1000 1
```
## QA connectomes and network measures
```
python qa.py [diffusion image - will extract b0 (nii.gz)] [roi image (nii.gz)] [connectome (.npy)] [connectome (.npy)] [connectome (.npy)] [output of bct (json)] [log file - will extract the first few lines (.txt)] [output (.png)]
python qa.py wmfod.nii.gz atlas.nii.gz connectome_nos.npy connectome_length.npy connectome_fa.npy networkmeasures.json log.txt qa_document.png
```
## QA Tracks
* mrview
* MI-Brain
