WMATLASDIR=${2}
ID=${1}


export epi_transform=${WMATLASDIR}/dwmri%ANTS_t1tob0.txt
export t1_to_template_affine=${WMATLASDIR}/dwmri%0GenericAffine.mat
export t1_to_template_invwarp=${WMATLASDIR}/dwmri%1InverseWarp.nii.gz


#antsApplyTransforms -d 3 -i $ID/atlas_Destrieux_inT1space.nii.gz -r ${WMATLASDIR}/dwmri%b0.nii.gz -n NearestNeighbor \
#    -t ${epi_transform} -t [${t1_to_template_affine},1] -t ${t1_to_template_invwarp} -o $ID/atlas_Destrieux_inDWIspace.nii.gz

antsApplyTransforms -d 3 -i $ID/atlas_inT1space_hcpmmp1.nii.gz -r ${WMATLASDIR}/dwmri%b0.nii.gz -n NearestNeighbor \
    -t ${epi_transform} -t ${t1_to_template_invwarp} -o $ID/atlas_inDWIspace_hcpmmp1.nii.gz
antsApplyTransforms -d 3 -i $ID/atlas_inT1space_freesurfer.nii.gz -r ${WMATLASDIR}/dwmri%b0.nii.gz -n NearestNeighbor \
    -t ${epi_transform} -t ${t1_to_template_invwarp} -o $ID/atlas_inDWIspace_freesurfer.nii.gz
antsApplyTransforms -d 3 -i $ID/atlas_inT1space_slant.nii.gz -r ${WMATLASDIR}/dwmri%b0.nii.gz -n NearestNeighbor \
    -t ${epi_transform} -t ${t1_to_template_invwarp} -o $ID/atlas_inDWIspace_slant.nii.gz
    
antsApplyTransforms -d 3 -i $ID/aparc+aseg_inT1space.nii.gz -r ${WMATLASDIR}/dwmri%b0.nii.gz -n NearestNeighbor \
    -t ${epi_transform} -t ${t1_to_template_invwarp} -o $ID/aparc+aseg_inDWIspace.nii.gz
