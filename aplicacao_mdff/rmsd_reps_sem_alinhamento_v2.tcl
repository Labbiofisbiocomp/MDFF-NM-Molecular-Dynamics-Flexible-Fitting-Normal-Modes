for {set i 1} {$i <= 100} {incr i} {
    set id [mol new initial.psf]
    mol addfile inputs/open.pdb 
    
    cd $i
    
    for {set j 1} {$j <= 20} {incr j} {
        cp cycle_$j.coor cycle_$j.pdb
        mol addfile cycle_$j.pdb waitfor all molid $id;       
    }
    
    set n_frames [molinfo $id get numframes]
        
    set reference [atomselect top "resid 467 468 469 470 471 472 473 474 475 476 477" frame 0]

    set out_rmsd [open "rmsd_helix12_rep$i.dat" w+]
    
    for {set current_frame 1} {$current_frame < $n_frames} {incr current_frame} {

        set compare [atomselect top "resid 464 465 466 467 468 469 470 471 472 473 474 475 476 477" frame $current_frame]

        #set transformation_matrix [measure fit $compare $reference]
        #$compare move $transformation_matrix
    
        set rmsd_value [measure rmsd $compare $reference]
        puts $out_rmsd "$current_frame $rmsd_value"
    }
    
    close $out_rmsd
    cd ..
    mol delete $id
}    

quit
