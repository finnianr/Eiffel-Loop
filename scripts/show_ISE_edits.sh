
echo All edits on Eiffel Software classes by FJR
echo

pushd .

cd $ISE_LIBRARY/library

echo ISE version $ISE_VERSION libraries
ls
echo

for name in console file format_double; do
	path=$(find base -type f -name "$name.e")
	base_e=$(basename "$path")
	class_name="${base_e%.*}"
	class_name="${class_name^^}"

	echo Edits on $class_name\: $path
	grep -F "FJR:" $path
	echo
done

popd
