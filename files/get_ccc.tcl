package require mdff
## load structure
mol new ref.pdb      
set sel [atomselect top "all"]  
## compute CC
voltool cc $sel -res 5 -i 4ake_target.dx
quit

