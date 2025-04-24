Hello! Here is the documentation for my project "Impact of Tractography Algorithm, Streamline Counts, and Brain Parcellation on Connectome Reliability in Aging Studies" (AKA When is enough, enough? w.r.t Streamlines in tractography). 
The backbone of this project is tractography and relies heavily on the following tools: [MRTrix](https://www.mrtrix.org/), and the [Brain Connectivity Toolbox](https://sites.google.com/site/bctnet/). 
I've included commands and code that I used in this project. The main steps are:
1. Get brain ROI parcellations: First, run Freesurfer. Then use those subject specific labels to get the Glasser and Desikna-killany parcellations. These ROI maps are in "T1-space". To use them in tractography, we need to register this ROI map to Diffusion space so that it lines up wth tractography.
2. Get segmentations to inform tractography: We need a 5 tissue type mask to segment the grey-matter white-matter boundary (where we will seed tractography).
3. Get fiber orientation distribution functions: First, we must estimate what each tissue looks like (if you have b0 and two unique b-values, you can estimate grey matter (GM), white matter (WM), and cerebral spinal fluid (CSF). If you have b-0 and 1 other unique b-value, you can estimate CSF and WM. Then, we will deconvolve the diffusion signal in each voxel with this tissue fingerprint/basic model.
4. Run tractography: There are many ways to set up your tractography. Here we have code for probablistic, deterministic, and probablistic with SIFT2 filtering. See the MRTrix documentation to look at the parameters and options you have: [MRTrix Docs](https://mrtrix.readthedocs.io/en/latest/reference/commands/tckgen.html)
5. Combine atlas and tractography to get a connectome: This step is wrapped into each tractography script in `Tractography`.
6. Network analysis: This step is wrapped into each tractography script in `Tractography`. Uses the BCT to generate a json of network properties and definitions. 

## Get ROI segmentation from T1w image
* SLANT ("BrainColor"), see [SLANT](https://github.com/MASILab/SLANTbrainSeg)
* Desikan-killany ("Freesurfer default"), See `Tractography/get_desikiankillany_atlas.sh`
* Glasser ("hcpmmp1"), See `Tractography/get_glasser_atlas.sh`

## Reorder the labels and remove white matter regions
```
labelconvert [orig atlas (nii.gz)] [orig lut (txt)] [target lut (txt)] [output atlas with updated labels (nii.gz)]
```
## You may need to change file formats between NIFTI, mgz or mif
```
mrconvert [IN (mif, mgz, nii.gz)] [OUT (mif, mgz, nii.gz)]
```
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
