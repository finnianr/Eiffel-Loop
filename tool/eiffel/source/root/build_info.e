note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-09-16 12:39:22 GMT (Saturday 16th September 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_05_00

	Build_number: NATURAL = 531

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

end