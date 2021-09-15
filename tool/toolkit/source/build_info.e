note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2021-09-13 14:29:56 GMT (Monday 13th September 2021)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_05_01

	Build_number: NATURAL = 564

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/toolkit"
		end

end