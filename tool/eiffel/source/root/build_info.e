note
	description: "Build specification"

	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_04_04

	Build_number: NATURAL = 388

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

end