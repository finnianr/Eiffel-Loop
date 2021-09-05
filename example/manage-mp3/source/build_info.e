note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2021-09-01 11:16:41 GMT (Wednesday 1st September 2021)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 02_03_01

	Build_number: NATURAL = 80

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end