for path in $(grep --include=\*.py -r -l -e "from eiffel_loop.project import *" .);
do
	echo $path
	grep "# " $path 
	echo .
done

