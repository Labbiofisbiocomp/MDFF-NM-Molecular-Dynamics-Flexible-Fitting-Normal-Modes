library(bio3d)
# load required functions
source("functions_mdff_nm.R")
# read user defined parameters
source("inputs_mdff_nm.R")

###############################################################################
# PREPARATION STEP
# in this step a psf from the structure provided is generated 
# and a synthetic density map is generated from the target structure 
# users can edit this part if they want to provide their own files
system(command = paste0("sed s/INITPDB/",coor.pdb,"/g template_prepare.tcl | sed s/TARGMAP/",expmap,"/g |sed s/TARGPDB/",target.pdb,"/g | sed s/USERRES/",res,"/g > prepare.tcl"))
system(command = "sh prepare.sh")
system(command = paste0("rm correlation_cycles.txt"))
###############################################################################

###############################################################################
# MAIN LOOP CONTROL
while (cycle < maxcycles){
  message(paste0("#############################"))
############################################
# READ FILES
if (cycle == 0){
	pdbfile <- paste0("cycle_",cycle,".pdb")   
	pdb <- read.pdb(pdbfile, hex = T)
	velfile <- vel.pdb
	vel <- read.pdb(velfile, hex = T)
	vel$xyz <- vel$xyz / pdbvelfactor
}else{
	pdbfile <- paste0("cycle_",cycle,".coor")
  pdb <- read.pdb(pdbfile, hex = T)
  velfile <- paste0("cycle_",cycle,".vel")
  vel <- read.pdb(velfile, hex = T)
  vel$xyz <- vel$xyz / pdbvelfactor
}
message(paste0("read ", pdbfile," file"))

if(cycle == 0){
	mass.vec <- sqrt(read.mass.psf(topol)) 
	pdb_ptn <- trim.pdb(pdb,inds = atom.select(pdb, segid = seg.user)) 
	pdb.noh.inds <- atom.select(pdb_ptn, string = 'noh')
	pdb_noh <- trim.pdb(pdb,inds = pdb.noh.inds) 
	write.pdb(pdb = pdb_noh, xyz= pdb_noh$xyz, file = "ref.pdb", print.segid = T)
}

###############################
# loop update control
cycle = cycle + 1
message(paste0("PERFORMING CYCLE", cycle))
message('#######################################')
###############################

if (cycle == 1){
# GET SYSTEM INFO
N <- length(pdb$atom$type)
prot <- length(pdb_ptn$atom$type)
message('SUMMARY OF FILES AND PARAMETERS:')
message(paste0('coordinate file: ',coor.pdb))
message(paste0('velocity file: ',vel.pdb))
message(paste0(N,' total atoms /',prot,' protein atoms'))
}
############################################
# GET CROSS CORRELATION OF THE REFERENCE - only performed in the first cycle
if (cycle == 1){
  ref <- as.numeric(read.table("correlation.txt", header = F))
  inds <- "cycle 0"
  write.table(x = cbind(inds,ref), file = "correlation_cycles.txt",append = T,quote = F,row.names = F, col.names = F )
  print(paste0("initial correlation = ",ref))
}

message('#######################################')
message(paste0("actual operational RMS value =", rms_op))
message('#######################################')

############################################
if (rms_op>=0.5 | ref < 0.95){

# MODES
message("CALCULATING NORMAL MODES")
n.ca.modes <- 3*(sum(pdb$calpha))
subset.modes <- round(x = n.ca.modes * percent.modes, digits = 0)
last.mode = subset.modes + 7
m <-aanma.pdb(pdb_ptn, outmodes = 'noh', mass = T, keep = last.mode, rtb = T, temp = NULL)

############################################
# LINEAR COMBINATIONS- 
message("BUILDING LINEAR COMBINATIONS")
iter = 0
delta = 0
maxiter = 40
convergence = 0

# probability distribution according to eigenvalues (see step 7 in the Theory section)
subset.eigen <- m$L[7:last.mode]
inverse.subset.eigen <- 1/subset.eigen
prob <- inverse.subset.eigen/sum(inverse.subset.eigen)

# loop to build combinations and test them in a iterative procedure
while (delta < threshold){
iter = iter+1

# generate alpha values (see step 8 in the Theory section)
alpha.q <- matrix(runif(trial.vector.modes, -0.5, 0.5), ncol=trial.vector.modes)
# select modes according to probability distribution (see step 7 in the Theory section)
modes <- sample(x = 7:last.mode, prob = prob, size = trial.vector.modes)
q <- matrix(0, nr = 3*prot, nc = trial.vector.modes)
q[pdb.noh.inds$xyz,] <- m$U[,modes]
q.noh <- matrix(0, nr = 3*(length(pdb.noh.inds$atom)), nc = trial.vector.modes)
q.noh <- m$U[,modes]
# generate linear combination (see step 8 in the Theory section)
Q.aux <- combine(q.noh, alpha.q)

# displace along linear combination and generate trial structure
# (see step 9 in the Theory section)
displace.nma(pdb = pdb_noh, vec = Q.aux, rms = rms_op, selection = 'noh', outname = paste0("decoy.pdb"))
system(command = paste0("sed s/PDB/decoy.pdb/g template_get_ccc.tcl | sed s/TARGMAP/",expmap,"/g | sed s/USERRES/",res,"/g > get_ccc.tcl"))
system(command = paste0("sh ccc.sh"))
disp <- as.numeric(read.delim("correlation.txt", header = F))
delta = c(disp - ref)
message(paste0("iteration ",iter,"/ variation ",delta))
if (iter > maxiter){
  message("maximun number of iterations reached")
  iter = 0 # reset counting
  threshold = threshold/2
  message(paste0("decreasing threshold to ",threshold))
  convergence = convergence + 1
}
if (convergence > 1){
  message("#########################################################")
  message("Normal Modes excitation brought no significat increase of CC")
  message("Next step : MD")
  message("#########################################################")
  break
 }
} # end loop build combinations

threshold = 0.01 # reset threshold 
convergence = 0 # reset convergence count 
message("RESETING THRESHOLD TO 0.01")

message(paste0("#############################"))
message(paste0("ACCEPTED iteration ",iter))
write.table(file = "alphas.txt", x = alpha.q, append = F, quote = F, row.names = F, col.names = F)

############################################
# Excitation step (see step 10 in the theory section)
message("EXCITATION STEP")

lambda = sqrt(2*ek) 
Q <- t(combine(q, alpha.q)) # alpha values taken from before 
Q.exct <- Q * lambda * (1/rep(mass.vec, each = 3))

v.tot.temp = vel$xyz + Q.exct
############################################
# OUTPUT VELOCITIES in pdb format  
message("WRITING OUTPUTS")
write.pdb(pdb_ptn, xyz = v.tot.temp * pdbvelfactor, file=paste0("cycle_",cycle,".vel"), print.segid = T, end = T)
rms_op = rms_op-rms_decay
}else{
	vel = read.pdb(paste0("cycle_",cycle-1,".vel"))
	message("ONLY PERFORMAING MDFF FITTING")
	write.pdb(pdb_ptn, xyz = vel$xyz , file=paste0("cycle_",cycle,".vel"), print.segid = T, end = T)
}

###############################################################################3
# generate secondary structure and chirality restraints using VMD
if(cycle==1){
	system(command = paste0("sed s/PDB/cycle_0.pdb/g template_restraints.tcl | sed s/KPROT/",k_prot,"/g | sed s/HBONDK/",hbbondk,"/g | sed s/HBONDANGK/",hbanglek,"/g |sed s/TARGMAP/",expmap,"/g  > restraints.tcl"))
}else{
	system(command = paste0("sed s/PDB/cycle_",cycle-1,".coor/g template_restraints.tcl | sed s/KPROT/",k_prot,"/g | sed s/HBONDK/",hbbondk,"/g | sed s/HBONDANGK/",hbanglek,"/g |sed s/TARGMAP/",expmap,"/g  > restraints.tcl"))
}	
system(command = "sh restraints.sh") 

###########################################
# MDFF SIMULATION WITH EXCITED VELOCITIES
message(paste0("#############################"))
message("STARTING MD")

if(rms_op==0){
  system(command = paste0("sed s/STRUC/cycle_",cycle-1,".coor/g config.namd | sed s/LD_GAM/",langevin,"/g | sed s/STEPS/",steps.md,"/g |sed s/VEL/",cycle,"/g | sed s/SORTIE/",cycle,"/g | sed s/g_scale/",g_scale,"/g |sed s/TARGMAP/",expmap,"/g > config_run.namd"))
}
if(cycle==1){
  system(command = paste0("sed s/STRUC/cycle_0.pdb/g config.namd |  sed s/LD_GAM/",langevin,"/g |sed s/STEPS/",steps.md,"/g |sed s/VEL/",cycle,"/g | sed s/SORTIE/",cycle,"/g | sed s/g_scale/",g_scale,"/g |sed s/TARGMAP/",expmap,"/g > config_run.namd"))
}else{
  system(command = paste0("sed s/STRUC/cycle_",cycle-1,".coor/g config.namd | sed s/LD_GAM/",langevin,"/g | sed s/STEPS/",steps.md,"/g |sed s/VEL/",cycle,"/g | sed s/SORTIE/",cycle,"/g |sed s/g_scale/",g_scale,"/g |sed s/TARGMAP/",expmap,"/g > config_run.namd"))
}

system(command = paste0(namd.input," config_run.namd > cycle_",cycle,".log"))
system(command = paste0("rm *.BAK"))
system(command = paste0("rm cycle_",cycle-1,".restart*"))

###########################################
# GET CORRELATION OF THE EXCITED STATES
pdbfile <- paste0("cycle_",cycle,".coor")
pdb <- read.pdb(pdbfile, hex = T)
pdb_noh <- trim.pdb(pdb,inds = pdb.noh.inds)
write.pdb(pdb=pdb_noh, xyz = pdb_noh$xyz, file = "ref.pdb", print.segid = T)

system(command = paste0("sed s/PDB/ref.pdb/g template_get_ccc.tcl | sed s/TARGMAP/",expmap,"/g | sed s/USERRES/",res,"/g > get_ccc.tcl"))
system(command = paste0("sh ccc.sh"))

ref <- as.numeric(read.table("correlation.txt", header = F))

if(cycle==1){
  old_ref = ref
}else{
  diff = ref-old_ref
  old_ref = ref
  if(diff<0.01){
    md_convergence = md_convergence + 1
    inds <- paste0("cycle  ",cycle)
  }
} # convergence check loop	
message(paste0("#############################"))
message(paste0("After MD CC = ", ref))
message(paste0("#############################"))

inds <- paste0("cycle  ",cycle)
write.table(x = cbind(inds,ref), file = "correlation_cycles.txt",append = T,quote = F,row.names = F, col.names = F)

message(paste0("#############################"))
message(paste0("CYCLE ",cycle," FINISHED"))
} # end MAIN LOOP

message(paste0("#############################"))
message("NORMAL TERMINATION")

#################################
