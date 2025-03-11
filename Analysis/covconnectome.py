import sys
import numpy as np
import os
import re
import numpy as np
from glob import glob
import matplotlib.pyplot as plt
import fnmatch
import math
# Directory containing the CSV files
directory= "/home-local/WIEE/Outputs_SDSTREAM/sub-4718_ses-adni2year1_dx-AD/" #sys.argv[1]
#directory= "/home-local/WIEE/Outputs/sub-4718_ses-adni2year1_dx-AD/" #sys.argv[1]
from matplotlib.colors import LinearSegmentedColormap
cmap = LinearSegmentedColormap.from_list('gr',["palegreen","lightcoral"], N=256)

for atlas in ["freesurfer","slant","hcpmmp1"]:
    for algo in ["","_Algo_SDSTREAM"]:
        for sc in [10000, 1000000, 2000000, 3000000, 4000000, 5000000, 10000000]:
            plt.clf()
            # Dictionary to store data per site
           
            #pattern = "CONNECTOME_SIFT2NUMSTREAMS_NumStreamlines_"+str(sc)+"_Atlas_"+atlas+"_Iteration_[1-5]"+algo+".npy"
            pattern = "CONNECTOME_NUMSTREAM_NumStreamlines_"+str(sc)+"_Atlas_"+atlas+"_Iteration_[1-5]"+algo+".npy"
            print(pattern)

            #files = glob.glob(file_pattern)
            files = [os.path.join(directory, f) for f in os.listdir(directory) if fnmatch.fnmatch(f, pattern)]

            if not files:
                print("No matching files found.")
                break

            matrices = [np.load(f) for f in files]
            matrices = np.stack(matrices)  # Shape: (num_files, n, n)
            
            mean_matrix = np.nanmean(matrices, axis=0)
            std_matrix = np.nanstd(matrices, axis=0)

            newmatrix = std_matrix / mean_matrix
            newmatrix = newmatrix * 100
            im = plt.imshow(newmatrix, interpolation='none',vmin=0, vmax=100, cmap=cmap)
            cb = plt.colorbar(im)

            plt.title(f'COV_'+atlas+'_'+str(sc)+'_'+algo)
            #plt.show()
            plt.savefig(f'COV_'+atlas+'_'+str(sc)+'_'+algo+'.png')
            
            matrices[matrices < (math.pow(10,-5)*sc)] = 0

            mean_matrix = np.nanmean(matrices, axis=0)
            std_matrix = np.nanstd(matrices, axis=0)

            newmatrix = std_matrix / mean_matrix
            newmatrix = newmatrix * 100
            im = plt.imshow(newmatrix, interpolation='none',vmin=0, vmax=100, cmap=cmap)
            cb = plt.colorbar(im)

            plt.title(f'COV_thresh_'+atlas+'_'+str(sc)+'_'+algo)
            #plt.show()
            plt.savefig(f'COV_thresh_'+atlas+'_'+str(sc)+'_'+algo+'.png')
            
            
