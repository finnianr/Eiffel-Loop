from os import path

def normalize_gcc_lib (location):
	# Turn: -L"$EIFFEL_LOOP/C_library/vtd2eiffel/spec/linux-x86-64" -lvtd-xml -lextra
	# or: -L$EIFFEL_LOOP/C_library/vtd2eiffel/spec/linux-x86-64 -lvtd-xml -lextra

	# into:	 $EIFFEL_LOOP/C_library/vtd2eiffel/spec/linux-x86-64/libvtd-xml.a
	# 		 $EIFFEL_LOOP/C_library/vtd2eiffel/spec/linux-x86-64/libextra.a

	result = []
	if location [2] == '"':
		parts = location.split ('"')
		location_dir = parts [1]
		lib_names = parts [2].split (' -l')
	else:
		parts = location.split (' -l')
		location_dir = parts [0][2:]
		lib_names = parts [1:]
	lib_names = [name for name in lib_names if name.lstrip()]
	for name in lib_names:
		result.append (path.join (location_dir, 'lib' + name + '.a'))

	return result

def lib_list (location):
	result = []
	prefix = ''
	for part in location.split():
		lib = part.strip()
		if lib.startswith ('-L'):
			prefix = lib [2:]
		else:
			if prefix:			
				result.append (path.join (prefix, lib [2:] + '.a'))
			else:
				result.append (lib)
	
	return result

for location in ['-L$EIFFEL_LOOP/C_library/vtd2eiffel/spec/linux-x86-64  -lvtd-xml -lextra', "-lpangocairo-1.0 -lxml2 -lcroco-0.6"]:
	for fp in lib_list (location):
		print fp


