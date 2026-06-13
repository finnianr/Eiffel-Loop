
#mkdir -p workarea

grep -n '^\s*\(int\|char\|unsigned\|Boolean\|long\|short\|void\*\|ptr\)' \
  ../contrib/C/VTD-XML-2.7/include/*.h
