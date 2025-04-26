This step follows what happens in `tractography_sift2.sh`. In that step, we 1) generate tractography, 2) use tcksift2 to get streamline weights, then 3) weights the connectome in the tck2connectome step.
mu.txt is an output of tcksift2. We need to globally scale the connectome with this value. This is the script to do that. 
