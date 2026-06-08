
echo All edits on Eiffel Software classes by FJR
echo

file_paths=(
    "$ISE_LIBRARY/library/base/elks/support/format_double.e"
)

for path in "${file_paths[@]}"; do
    base_e=$(basename "$path")
    class_name="${base_e%.*}"
    class_name="${class_name^^}"
    
    echo "Source: $path"
    echo $class_name edits\:
    grep -F "FJR:" $path
    echo
done


