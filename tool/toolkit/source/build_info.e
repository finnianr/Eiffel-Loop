note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-03-22 16:59:33 GMT (Wednesday 22nd March 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_07_01

	Build_number: NATURAL = 603

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/toolkit"
		end

end