note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-05-26 17:07:56 GMT (Thursday 26th May 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 45

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/graphical"
		end

end