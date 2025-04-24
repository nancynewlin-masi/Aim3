export IMAGE=${1}

export LUT=FreeSurferColorLUT.txt
export FS=fs_default.txt
mrconvert  ${1}  aparc+aseg.nii.gz 
labelconvert aparc+aseg.nii.gz $LUT $FS atlas_freesurfer.nii.gz 
rm aparc+aseg.nii.gz
#labelconvert ${DIR}/anat/atlas_freesurfer_b4convert.nii.gz $FS  /nfs2/newlinnr/atlas_debug//atlas_freesurfer_LUT_ordered.txt ${DIR}/anat/atlas_freesurfer.nii.gz -force
