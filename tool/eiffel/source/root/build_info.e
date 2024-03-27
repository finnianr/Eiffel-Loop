note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2024-03-27 10:30:28 GMT (Wednesday 27th March 2024)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 02_00_15

	Build_number: NATURAL = 530

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

end