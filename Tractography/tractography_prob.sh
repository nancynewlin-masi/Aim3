
# Take in atlas
# Take in diffusion directory (dwi, bvec, bval)
# singularity run --bind ${workingpath_accre}/PreQual/:/DIFFUSION/,${workingpath_accre}/Slant/:/SLANT/,${workingpath_accre}/Output/:/OUTPUTS/ ${singularity_path}
# bash tractrography.sh /home-local/WIEE/Inputs/sub-4802_ses-adni2year1_dx-AD/ /home-local/WIEE/Outputs/sub-4802_ses-adni2year1_dx-AD/ /nfs2/harmonization/BIDS/ADNI_DTI/derivatives/sub-4802/ses-adni2year1/PreQual/PREPROCESSED/../ 1000 1

export INPUTDIR=${1}
export OUTPUTDIR=${2}
export PREQUALDIR=${3}
export NUMSTREAMS=${4}
export ITERATION=${5}
export WORKINGDIR=/home-local/newlinnr/WIEE/ #/home-local/WIEE/

CHECKFILE=${OUTPUTDIR}/graphmeasures_nodes_NumStreamlines_${NUMSTREAMS}_Atlas_hcpmmp1_Iteration_${ITERATION}.json
if test -f "${OUTPUTDIR}/graphmeasures_nodes_NumStreamlines_${NUMSTREAMS}_Atlas_hcpmmp1_Iteration_${ITERATION}.json"; then
    echo "File found - skipping this iteration."
    exit;
fi

echo "Start tracking using probabilistic ACT... Warning: this step will be storage and time intensive." >> ${OUTPUTDIR}/log.txt
# Generate 10 million streamlines
# Takes time, and will be several GB of space
tckgen -act ${INPUTDIR}/5ttmask_inDWIspace.nii.gz -backtrack -seed_gmwmi ${INPUTDIR}/gmwmSeed_inDWIspace.nii.gz -select ${NUMSTREAMS} ${INPUTDIR}/wmfod.nii.gz ${OUTPUTDIR}/tractogram_${NUMSTREAMS}_iteration_${ITERATION}.tck

if test -f "${OUTPUTDIR}/tractogram_${NUMSTREAMS}_iteration_${ITERATION}.tck"; then
    echo "Successfully tracked 10 million streamlines." >> ${OUTPUTDIR}/log.txt
    echo "Save tck file as TCK_FILE=${TEMPDIR}/tractogram_${NUMSTREAMS}.tck..."  >> ${OUTPUTDIR}/log.txt
    export TCK_FILE=${OUTPUTDIR}/tractogram_${NUMSTREAMS}_iteration_${ITERATION}.tck
else
    echo "FAILED: Did create tractogram. Check storage space available." >> ${OUTPUTDIR}/log.txt
    exit 0;
fi

ATLASNAMES="slant freesurfer hcpmmp1"
for CURRATLAS in $ATLASNAMES
do
    echo "Mapping to connectomes using $CURRATLAS labels..."
    export ATLAS=${INPUTDIR}/atlas_inDWIspace_${CURRATLAS}.nii.gz
    echo "Map tracks to Connectomes -NOS, Mean Length, FA-, guided by atlas..." >> ${OUTPUTDIR}/log.txt
    # Map tracks to connectome (weighted by NOS)
    tck2connectome ${TCK_FILE} ${ATLAS} ${OUTPUTDIR}/CONNECTOME_Weight_NUMSTREAMLINES_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv -symmetric
    if test -f "${OUTPUTDIR}/CONNECTOME_Weight_NUMSTREAMLINES_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv"; then
        echo "Successfully created connectome weighted by number of streamlines. Saiving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${INPUTDIR}/CONNECTOME_Weight_NUMSTREAMLINES_NumStreamlines_${NUMSTREAMS}_Atlas_SLANT.csv ${OUTPUTDIR}
    else
        echo "FAILED: Did not create connectome weighted by number of streamlines." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi

    python ${WORKINGDIR}/Code/convertconnectometonp_nos.py  ${OUTPUTDIR}/CONNECTOME_Weight_NUMSTREAMLINES_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv ${OUTPUTDIR}/CONNECTOME_NUMSTREAM_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy ${NUMSTREAMS}
    if test -f "${OUTPUTDIR}/CONNECTOME_NUMSTREAM_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy"; then
        echo "Successfully converted csv to npy and performed adaptive thresholding. Saiving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${INPUTDIR}/CONNECTOME_NUMSTREAM.npy ${OUTPUTDIR}
    else
        echo "FAILED: Did not convert connectome." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi

    # Map tracks to connectome (weighted by Mean Length of streamline)
    tck2connectome ${TCK_FILE} ${ATLAS} ${OUTPUTDIR}/CONNECTOME_Weight_MEANLENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv -scale_length -stat_edge mean -symmetric
    if test -f "${OUTPUTDIR}/CONNECTOME_Weight_MEANLENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv"; then
        echo "Successfully created connectome weighted by mean length of streamlines. Saiving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${INPUTDIR}/CONNECTOME_Weight_NUMSTREAMLINES_NumStreamlines_${NUMSTREAMS}_Atlas_SLANT.csv ${OUTPUTDIR}
    else
        echo "FAILED: Did not create connectome weighted by number of streamlines." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi

    # Convert to npy
    python ${WORKINGDIR}/Code/convertconnectometonp.py  ${OUTPUTDIR}/CONNECTOME_Weight_MEANLENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv ${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy
    if test -f "${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy"; then
        echo "Successfully converted csv to npy. Saving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${INPUTDIR}/CONNECTOME_LENGTH.npy ${OUTPUTDIR}
    else
        echo "FAILED: Did not convert connectome." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi

    echo "Compute FA per streamline and create the FA weighted connectome..." >> ${OUTPUTDIR}/log.txt
    tcksample ${TCK_FILE} ${PREQUALDIR}/../SCALARS/dwmri_tensor_fa.nii.gz ${OUTPUTDIR}/mean_FA_per_streamline_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv -stat_tck mean
    tck2connectome ${TCK_FILE} ${ATLAS} ${OUTPUTDIR}/CONNECTOME_Weight_MEANFA_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv -scale_file ${OUTPUTDIR}/mean_FA_per_streamline_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv -stat_edge mean -symmetric
    if test -f "${OUTPUTDIR}/CONNECTOME_Weight_MEANFA_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv"; then
        echo "Successfully created connectome weighted by mean FA. Saiving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${INPUTDIR}/CONNECTOME_Weight_MeanFA_NumStreamlines_${NUMSTREAMS}_Atlas_SLANT.csv ${OUTPUTDIR}
    else
        echo "FAILED: Did not create connectome weighted by number of streamlines." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi 

    python ${WORKINGDIR}/Code/convertconnectometonp.py  ${OUTPUTDIR}/CONNECTOME_Weight_MEANFA_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.csv ${OUTPUTDIR}/CONNECTOME_FA_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy
    if test -f "${OUTPUTDIR}/CONNECTOME_FA_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy"; then
        echo "Successfully converted csv to npy. Saving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${INPUTDIR}/CONNECTOME_FA.npy ${OUTPUTDIR}
    else
        echo "FAILED: Did not convert connectome." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi

    # Get graph measure
    #python /APPS/scilpy/getgraphmeasures.py  ${OUTPUTDIR}/CONNECTOME_NUMSTREAM_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy ${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy  ${OUTPUTDIR}/graphmeasures_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.json --avg_node_wise
    #python /APPS/scilpy/getgraphmeasures.py  ${OUTPUTDIR}/CONNECTOME_NUMSTREAM_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy ${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy  ${OUTPUTDIR}/graphmeasures_nodes_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.json
    echo "Get graph measures..."
    singularity exec --bind ${OUTPUTDIR} ${WORKINGDIR}/scilus_1.5.0.sif scil_evaluate_connectivity_graph_measures.py  ${OUTPUTDIR}/CONNECTOME_NUMSTREAM_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy ${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy  ${OUTPUTDIR}/graphmeasures_nodes_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.json
    singularity exec --bind ${OUTPUTDIR} ${WORKINGDIR}/scilus_1.5.0.sif scil_evaluate_connectivity_graph_measures.py  ${OUTPUTDIR}/CONNECTOME_NUMSTREAM_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy ${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy  ${OUTPUTDIR}/graphmeasures_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.json --avg_node_wise
    echo "Done computing graph measures..."	
    if test -f "${OUTPUTDIR}/graphmeasures_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.json"; then
        echo "Successfully computed global graph measures. Saving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${OUTPUTDIR}/graphmeasures.json ${OUTPUTDIR}
    else
        echo "FAILED: Did not compute global graph measures." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi

    if test -f "${OUTPUTDIR}/graphmeasures_nodes_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.json"; then
        echo "Successfully computed nodal graph measures. Saving to /OUTPUTS/." >> ${OUTPUTDIR}/log.txt
        #cp ${INPUTDIR}/graphmeasures_nodes.json ${OUTPUTDIR}
    else
        echo "FAILED: Did not compute nodal graph measures." >> ${OUTPUTDIR}/log.txt
        exit 0;
    fi


    echo "Completed Connectome special." >> ${OUTPUTDIR}/log.txt
    date >> ${OUTPUTDIR}/log.txt

    echo "Creating QA document..." >> ${OUTPUTDIR}/log.txt
    #singularity exec --bind /home-local/WIEE/ /home-local/WIEE/NancysDiffusionSingularity.sif python /home-local/WIEE//Code/qa.py ${INPUTDIR}/wmfod.nii.gz ${ATLAS} ${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy  ${OUTPUTDIR}/CONNECTOME_LENGTH_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy ${OUTPUTDIR}/CONNECTOME_FA_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.npy ${OUTPUTDIR}/graphmeasures_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.json ${OUTPUTDIR}/log.txt ${OUTPUTDIR}/ConnectomeQA_NumStreamlines_${NUMSTREAMS}_Atlas_${CURRATLAS}_Iteration_${ITERATION}.png >> ${OUTPUTDIR}/log.txt
        
done
#rm -r ${INPUTDIR}
rm ${OUTPUTDIR}/tractogram_${NUMSTREAMS}_iteration_${ITERATION}.tck
rm ${OUTPUTDIR}/CONNECTOME*.csv
rm ${OUTPUTDIR}/mean_FA_per_streamline_*
