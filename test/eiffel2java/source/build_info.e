note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-02-24 18:46:05 GMT (Thursday 24th February 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 56

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel2java"
		end

end