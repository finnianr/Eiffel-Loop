note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2024-09-10 8:46:59 GMT (Tuesday 10th September 2024)"
	revision: "2"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Build_number: NATURAL = 133

	Compatibility_mode: STRING = "Win7"
		-- compatibility mode for Windows for registry entry

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Leder/PF_HP"
		end

	Version_number: NATURAL = 02_00_00

end