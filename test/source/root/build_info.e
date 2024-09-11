note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2024-09-09 16:21:50 GMT (Monday 9th September 2024)"
	revision: "2"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Compatibility_mode: STRING = "Win7"
		-- Windows compatibility mode

	Version_number: NATURAL = 01_06_04

	Build_number: NATURAL = 347

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end