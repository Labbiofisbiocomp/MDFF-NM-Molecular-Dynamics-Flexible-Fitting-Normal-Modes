################################################################
# script to launch VMD and generate:

# 1- psf from initial structure
# 2 -synthetic map from target structure
# 3- calculate cross correlation from the initial state

# the file prepare.tcl was generated from the mdff_nm.R script
vmd -dispdev text -e prepare.tcl > out.prepare
grep -B1 CCC out.prepare | head -1 > correlation.txt
mv initial_formatted_autopsf_grid.pdb cycle_0.pdb
mv initial_formatted_autopsf.psf initial.psf
rm pre_formatted*
rm first_formatted*
rm initial-docked.pdb
rm initial_* 

echo '#####################' 
echo 'PREPARATION STEP DONE' 
echo '#####################' 
