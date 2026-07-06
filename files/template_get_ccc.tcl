package require mdff
## load structure
mol new PDB      
set sel [atomselect top "all"]  
## compute CC
voltool cc $sel -res USERRES -i TARGMAP.dx
quit

