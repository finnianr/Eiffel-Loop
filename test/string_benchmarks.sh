for n in {1..3}
do
	. run_test.sh -zstring_benchmark -codec 15 -runs 2000
	mv workarea/ZSTRING-benchmarks-latin-15.html workarea/ZSTRING-benchmarks-latin-15.$n.html
done
