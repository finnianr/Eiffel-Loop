note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2024-02-29 9:51:08 GMT (Thursday 29th February 2024)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 02_00_11

	Build_number: NATURAL = 530

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

end