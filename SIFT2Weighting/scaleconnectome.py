import sys
import numpy as np
import os
import re
import numpy as np
from glob import glob
import matplotlib.pyplot as plt


# Directory containing the CSV files
average_array = np.load(sys.argv[1])
mu = np.readtxt(sys.argv[2])
average_array = average_array * mu
np.save(sys.argv[3],average_array)
#plt.imshow(average_array, interpolation='none',vmin=0, vmax=np.max(average_array)*0.001)
#plt.show()
#plt.savefig(sys.argv[3])
#exit(0)
