note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-02-18 18:19:17 GMT (Saturday 18th February 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_04_06

	Build_number: NATURAL = 279

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end