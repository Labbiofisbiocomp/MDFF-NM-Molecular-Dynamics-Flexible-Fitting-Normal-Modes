vmd -dispdev text -e get_ccc.tcl > out3
grep -v Info out3 | grep -v vmd  | tail -1 > correlation.txt
