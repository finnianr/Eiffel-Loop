note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-10-04 10:19:43 GMT (Tuesday 4th October 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_00_01

	Build_number: NATURAL = 16

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/EROS"
		end

end