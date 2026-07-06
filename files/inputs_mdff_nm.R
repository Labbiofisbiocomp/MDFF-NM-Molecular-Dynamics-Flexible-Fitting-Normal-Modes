######################################################################
# user defined PARAMETERS
coor.pdb = "adk-equi.pdb"  # initial coordinates of the system (PDB format)
vel.pdb = "adk-equi.vel" # initial velocities of the system (PDB format)
seg.user = 'AP1' # segment of the protein to be considered
expmap = "4ake_target" # filename for the experimental map
target.pdb = "4ake_target.pdb"
topol = "initial.psf"
res = 5  # resolution of the EM density map
######################################################################

##########  NM-driven exploration ###################################
steps.md = 1000   # steps per MD excitation cycle
percent.modes = 0.01   # percentage of modes to define a subsert of relevant directions
trial.vector.modes = 3 # number of modes to be considered when building linear cobinations
ek = 50           # kintic energy to be added along the linear combination of modes
maxcycles = 20    # maximun number of cycles
######################################################################

####### NAMD parameters##############################################
g_scale = 0.3     # grid scaling forces - biasing potential
k_prot = 200      # force constant for protein dihedrals (default: 200)
hbbondk	= 20	  # force constant for H-bonds> (default: 20.0)
hbanglek = 20	  # force constant for H-bonds> (default: 20.0)
freq.out = 20     # frequency of MD outputs
langevin = 1      # langevin thermostat gamma parameter
######################################################################

######################  execution MD  ######################################
# the command line for executing MD should be inserted 
# in quotes as given in the example below
# users may change this according to the resources available

# example for CPU usage
namd.input = "namd2 +p2"
# example for GPU usage
#namd.input = "namd2  +idlepoll +p4 +devices 0"
###########################################################

######################################################################
# internal parameters - DO NOT EDIT 
cycle = 0         # initial cycle
rms = 2           # initial RMSD displacement along linear combinations
rms_decay = 0.25  # decay of RMSD for subsequent displacements 
rms_op = rms      #operational rms
threshold = 0.01  # minimum increase in cross correlation to accept the linear combination of NMs
md_convergence = 0 # convergence control
pdbvelfactor = 20.4548270  # factor to convert velocity units to NAMD

######################################################################
