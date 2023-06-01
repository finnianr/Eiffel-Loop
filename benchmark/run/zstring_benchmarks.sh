#!/usr/bin/env bash
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop

for n in {1..3}
do
	build/$ISE_PLATFORM/package/bin/el_benchmark -zstring_benchmark -codec 15 -runs 2000
	mv workarea/ZSTRING-benchmarks-latin-15.html workarea/ZSTRING-benchmarks-latin-15.$n.html
done
