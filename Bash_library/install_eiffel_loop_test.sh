#!/usr/bin/env bash
# install_eiffel_loop_test.sh
# Usage: source build_eiffel_loop_test.sh

if [[ -z "$EIFFEL" ]]; then
	echo "ERROR: \$EIFFEL environment variable is not set."
	echo "Set in .profile to point to your Eiffel dev directory."
	return 1
fi

if [[ -z "$ISE_VERSION" ]]; then
	echo "ERROR: \$ISE_VERSION environment variable is not set. Set to current version in .profile."
	return 1
fi

library_dir="$EIFFEL/library"
eiffel_loop_dir="$library_dir/Eiffel-Loop"

echo "Creating library directory: $library_dir"
mkdir -p "$library_dir" || {
	echo "ERROR: Failed to create $library_dir"
	return 1
}

cd "$library_dir" || {
	echo "ERROR: Cannot cd to $library_dir"
	return 1
}

if [[ -d "$eiffel_loop_dir/.git" ]]; then
	echo "Eiffel-Loop already cloned at $eiffel_loop_dir — skipping clone."
else
	echo "Cloning Eiffel-Loop from GitHub..."
	git clone https://github.com/finnianr/Eiffel-Loop || {
		echo "ERROR: git clone failed."
		return 1
	}
fi

echo "Installing scons..."
sudo apt-get install -y scons || {
	echo "ERROR: Failed to install scons."
	return 1
}

echo "Installing Eiffel-Loop Python package..."
cd "$eiffel_loop_dir" || {
	echo "ERROR: Cannot cd to $eiffel_loop_dir"
	return 1
}
sudo pip install . --prefix=/usr || {
	echo "ERROR: pip install failed."
	return 1
}

c_libs=(
	"C_library/vtd2eiffel"
	"C_library/cURL"
	"contrib/C/Expat"
)

for lib in "${c_libs[@]}"; do
	lib_path="$eiffel_loop_dir/$lib"
	echo ""
	echo "Building: $lib_path"
	if [[ ! -d "$lib_path" ]]; then
		echo "ERROR: Directory not found: $lib_path"
		return 1
	fi
	if [[ ! -f "$lib_path/build.sh" ]]; then
		echo "ERROR: build.sh not found in $lib_path"
		return 1
	fi
	cd "$lib_path" || {
		echo "ERROR: Cannot cd to $lib_path"
		return 1
	}
	bash build.sh || {
		echo "ERROR: build.sh failed in $lib_path"
		return 1
	}
done

echo ""
echo "=========================================================="
echo "IMPORTANT: Before proceeding, please verify the following:"
echo ""
echo "  Check that class FORMAT_DOUBLE is NOT doing"
echo "  non-conforming inheritance."
echo ""
echo "  (In EiffelStudio 25.12 this breaks polymorphism used in"
echo "  EL_FORMAT_ROUTINES — make a copy of ISE libraries as"
echo "  workaround and adjust \$ISE_LIBRARY.)"
echo ""
echo "=========================================================="
read -r -p "Has FORMAT_DOUBLE non-conforming inheritance been resolved? [y/N] " reply
echo ""

case "$reply" in
	[yY][eE][sS]|[yY])
		echo "Confirmed. Proceeding to launch EiffelStudio..."
		;;
	*)
		echo "Aborted. Resolve the FORMAT_DOUBLE inheritance issue before launching."
		return 1
		;;
esac

test_dir="$eiffel_loop_dir/test"
if [[ ! -d "$test_dir" ]]; then
	echo "ERROR: Test directory not found: $test_dir"
	return 1
fi

cd "$test_dir" || {
	echo "ERROR: Cannot cd to $test_dir"
	return 1
}

echo "NOTE: You may want to comment out the following line in test/project.py before proceeding:"
echo ""
echo "   os.environ ['GTK_THEME'] = 'Mint-X-Teal-Custom:light'"
echo ""
read -r -p "Press Enter to continue..."

echo "Launching EiffelStudio with test.ecf..."
launch_estudio test.ecf
