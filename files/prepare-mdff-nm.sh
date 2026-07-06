#!/bin/bash
# number of replicates
rep=10

# create numbered folders with required files to run MDFF_NM
for i in `seq 1 ${rep}`
do

mkdir ${i}
cd ./${i}/

cp ../../../scripts_vide/*.R .
cp ../../../scripts_vide/*.sh .
cp ../../../scripts_vide/*.tcl .
cp ../../../scripts_vide/template* .
cp ../../../scripts_vide/*.namd .

#ln -s ../../../1ake-initial.pdb
ln -s ../../../equilibration-no-solvent/adk-equi.pdb 
ln -s ../../../equilibration-no-solvent/adk-equi.vel 

ln -s ../../../4ake_target.pdb
ln -s ../../../par_all36_prot.prm 

cd ../

done

