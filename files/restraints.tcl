package require ssrestraints
package require cispeptide
package require chirality
#package require mdff

#########################
#      Restraints       #
#########################

#Restraints N atoms involved in SS and dihedrals
ssrestraints -psf initial.psf -pdb cycle_4.coor -o extrabonds.txt -hbonds  
mol new initial.psf
mol addfile cycle_4.coor type pdb
#Restrain peptide bond geometry and C* stereochem
cispeptide restrain -o cispeptide.txt
chirality restrain -o chirality.txt

quit

