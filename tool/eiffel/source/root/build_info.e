note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-02-06 16:42:19 GMT (Sunday 6th February 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_04_12

	Build_number: NATURAL = 434

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

end