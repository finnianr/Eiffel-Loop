note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-05-31 17:14:21 GMT (Tuesday 31st May 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 48

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/graphical"
		end

end