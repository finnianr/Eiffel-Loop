note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2021-11-17 18:33:39 GMT (Wednesday 17th November 2021)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 42

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/graphical"
		end

end