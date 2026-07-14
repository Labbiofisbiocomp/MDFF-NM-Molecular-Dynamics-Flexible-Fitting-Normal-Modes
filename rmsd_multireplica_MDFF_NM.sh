#!/bin/bash

# Força o sistema a usar o ponto como separador decimal (padrão universal)
# O comando export LC_ALL=C redefine temporariamente a linguagem e 
# a localidade do terminal para o padrão internacional (POSIX/C).
export LC_ALL=C

# parameters

ref=4ake_target.pdb
init=cycle_0.pdb

# output dir
mkdir results
outdir=results

# extract CA from reference
grep CA ./inputs/${ref} > ref_ca.pdb

# extract initial coordinates 
cp 1/cycle_0.pdb .
grep CA cycle_0.pdb > init_ca.pdb

# rmsd of the initial structure
gmx rms -f init_ca.pdb -s ref_ca.pdb -o rmsd_init.xvg -fit rot+trans << EOF
C-alpha
C-alpha
EOF
grep -v @ rmsd_init.xvg | grep -v '#' | awk '{print $2*10}' > ./${outdir}/rmsd_init.txt
rm rmsd_init.xvg

# last replica
last=10

for i in `seq 1 ${last}`; do

cd ${i}
echo "$PWD"

# convert trajectories to trr
catdcd -o temp.trr -otype trr -dcd cycle_1.dcd cycle_2.dcd cycle_3.dcd cycle_4.dcd cycle_5.dcd cycle_6.dcd cycle_7.dcd cycle_8.dcd cycle_9.dcd cycle_10.dcd cycle_11.dcd cycle_12.dcd cycle_13.dcd cycle_14.dcd cycle_15.dcd cycle_16.dcd cycle_17.dcd cycle_18.dcd cycle_19.dcd cycle_20.dcd

# convert trajectories to dcd
catdcd -o temp.dcd -otype dcd -dcd cycle_1.dcd cycle_2.dcd cycle_3.dcd cycle_4.dcd cycle_5.dcd cycle_6.dcd cycle_7.dcd cycle_8.dcd cycle_9.dcd cycle_10.dcd cycle_11.dcd cycle_12.dcd cycle_13.dcd cycle_14.dcd cycle_15.dcd cycle_16.dcd cycle_17.dcd cycle_18.dcd cycle_19.dcd cycle_20.dcd

# copy concatenated structure file to outdir
cp temp.trr ../${outdir}/${i}.trr
cp temp.dcd ../${outdir}/${i}.dcd


# extact trajectories for c-alpha only
gmx trjconv -f temp.trr -s ../${init} -o temp_ca.trr  << EOF
C-alpha
EOF


# fit trajectories
gmx trjconv -f temp_ca.trr -s ../ref_ca.pdb -o temp_fit.trr -fit rot+trans << EOF
C-alpha
C-alpha
EOF

# calculate RMSD and Rg
gmx rms -f temp_fit.trr -s ../ref_ca.pdb -o rmsd.xvg << EOF
C-alpha
C-alpha
EOF

# convert to Angstrons
grep -v @ rmsd.xvg | grep -v '#' | awk '{print $2*10}' > ../${outdir}/temp

# remove temporary files
rm -f temp_fit.trr
rm \#*

# leave folder
cd ..

################################################
# add timestep information and rename
out=rmsd_${i}.txt

cd results
cat rmsd_init.txt temp > temp2
seq 0 0.5 20 > seq
paste seq temp2 > ${out}
rm temp temp2 seq
cd ../
#################################################

done
