FREESURFERDIR=${1}
ID=${2}
#WMEVE={3}

mkdir ${ID}//surf/
mkdir ${ID}//label/
mkdir ${ID}//mri

#mri_surf2surf --srcsubject fsaverage --trgsubject ../../../../${FREESURFERDIR} --hemi rh --sval-annot rh.HCPMMP1.annot --tval ${FREESURFERDIR}/label/rh.hcpmmp1.annot
#mri_surf2surf --srcsubject fsaverage --trgsubject ../../../../${FREESURFERDIR} --hemi lh --sval-annot lh.HCPMMP1.annot --tval ${FREESURFERDIR}/label/lh.hcpmmp1.annot
mri_surf2surf --srcsubject fsaverage --trgsubject ../../../../${FREESURFERDIR} --hemi rh --sval-annot rh.HCPMMP1.annot --tval ${ID}/label/rh.hcpmmp1.annot
mri_surf2surf --srcsubject fsaverage --trgsubject ../../../../${FREESURFERDIR} --hemi lh --sval-annot lh.HCPMMP1.annot --tval ${ID}/label/lh.hcpmmp1.annot

cp ${FREESURFERDIR}/surf/lh.white ${ID}//surf/lh.white
cp ${FREESURFERDIR}/surf/rh.white ${ID}//surf/rh.white
cp ${FREESURFERDIR}/surf/lh.white ${ID}//surf/lh.pial
cp ${FREESURFERDIR}/surf/rh.white ${ID}//surf/rh.pial
cp ${FREESURFERDIR}//mri/lh.ribbon.mgz  ${ID}//mri/lh.ribbon.mgz
cp ${FREESURFERDIR}//mri/rh.ribbon.mgz  ${ID}//mri/rh.ribbon.mgz
cp ${FREESURFERDIR}//mri/aseg.mgz ${ID}//mri/aseg.mgz

mri_aparc2aseg --old-ribbon --s ../../../..//fs5/p_masi/newlinnr/WIEE/ROISegmentation/${ID}/ --annot hcpmmp1 --o $ID/hcpmmp1.mgz
mrconvert -datatype uint32 $ID/hcpmmp1.mgz $ID/hcpmmp1.mif

echo "label convert on subject ${ID}"
labelconvert $ID/hcpmmp1.mif hcpmmp1_original.txt hcpmmp1_ordered.txt $ID/hcpmmp1_ordered.mif

mrconvert $ID/hcpmmp1_ordered.mif $ID/atlas_inT1space_hcpmmp1.nii.gz

#mrconvert -datatype uint32 $ID/Destrieux_inT1space.mgz $ID/atlas_Destrieux_inT1space.nii.gz
#mrconvert -datatype uint32 $ID/aparcaseg_inT1space.mgz $ID/aparcaseg_inT1space.nii.gz


rm $ID/hcpmmp1.mgz $ID/hcpmmp1_ordered.mif $ID/hcpmmp1.mif
#mrgrid $ID/atlas_Destrieux_inT1space.nii.gz regrid $ID/atlas_Destrieux_inT1space_regridded.nii.gz -template ${WMEVE}/dwmri%t1BET.nii.gz -strides 1,2,3 
