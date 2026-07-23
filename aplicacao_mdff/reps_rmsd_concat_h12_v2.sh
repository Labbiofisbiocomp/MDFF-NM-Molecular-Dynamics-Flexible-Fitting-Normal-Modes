#!/bin/bash

rm rmsd_replicas_h12_semalinhamento_v2.dat
rm menores_rmsd_h12.dat

ini_rep=1
final_rep=100

vmd2 -dispdev text -e rmsd_reps_sem_alinhamento_v2.tcl  > rmsd_sem_alinhamento_v2.out

for i in $(seq $ini_rep $final_rep); do
    echo "Replica $i" >> rmsd_replicas_h12_semalinhamento_v2.dat
    echo "Excitação RMSD" >> rmsd_replicas_h12_semalinhamento_v2.dat
    cat "$i/rmsd_helix12_rep${i}.dat" >> rmsd_replicas_h12_semalinhamento_v2.dat
    echo >> rmsd_replicas_h12_semalinhamento_v2.dat
done

awk '
/^Replica/ {
    if (replica != "") {
        print "Replica", replica
        print "Excitação RMSD"
        print excitacao, menor
        print ""
    }
    replica = $2
    menor = ""
    next
}

/^Excitação/ { next }

/^[0-9]/ {
    if (menor == "" || $2 < menor) {
        menor = $2
        excitacao = $1
    }
}

END {
    if (replica != "") {
        print "Replica", replica
        print "Excitação RMSD"
        print excitacao, menor
    }
}
' rmsd_replicas_h12_semalinhamento_v2.dat > menores_rmsd_h12.dat

### desenvolvido por Yolanda Marcello
