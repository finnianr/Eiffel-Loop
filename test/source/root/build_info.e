note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-07-22 9:24:25 GMT (Friday 22nd July 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_04_02

	Build_number: NATURAL = 257

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end