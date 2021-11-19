note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2021-11-19 16:50:25 GMT (Friday 19th November 2021)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_05_02

	Build_number: NATURAL = 565

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/toolkit"
		end

end