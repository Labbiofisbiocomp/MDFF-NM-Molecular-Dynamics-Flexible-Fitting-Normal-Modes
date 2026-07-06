#psf for initial structure
package require autopsf
package require mdff

# target
mol new TARGPDB type pdb
autopsf -mol top -prefix first
mol new first_formatted_autopsf.pdb type pdb
mol addfile first_formatted_autopsf.psf type psf
# set selection
set sel [atomselect top all]
# create map
mdff sim $sel -res USERRES -o TARGMAP.dx
# define bias potential
mdff griddx -i TARGMAP.dx -o TARGMAP_grid.dx

## Rigid body docking of initial structure in target's map
mol new INITPDB top
autopsf -mol top -prefix pre

mol new pre_formatted_autopsf.pdb type pdb
mol addfile pre_formatted_autopsf.psf type psf
set sel [atomselect top all]  
voltool fit $sel -res USERRES -i TARGMAP.dx   
## generates pdb of the docked structure           
$sel writepdb initial-docked.pdb 
mdff ccc $sel -i TARGMAP.dx -res USERRES
echo CCC 

mol new initial-docked.pdb top 
autopsf -mol top -prefix initial

mdff gridpdb -psf initial_formatted_autopsf.psf -pdb initial_formatted_autopsf.pdb -o initial_formatted_autopsf_grid.pdb

quit

