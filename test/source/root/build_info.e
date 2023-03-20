note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-03-20 11:33:51 GMT (Monday 20th March 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_05_01

	Build_number: NATURAL = 286

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end