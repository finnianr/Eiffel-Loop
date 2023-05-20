note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-05-19 9:51:51 GMT (Friday 19th May 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_05_01

	Build_number: NATURAL = 290

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end