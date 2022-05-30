note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-05-29 13:56:05 GMT (Sunday 29th May 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 47

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/graphical"
		end

end