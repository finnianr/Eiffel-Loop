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

	Version_number: NATURAL = 02_00_00

	Build_number: NATURAL = 133

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Leder/PF_HP"
		end

end