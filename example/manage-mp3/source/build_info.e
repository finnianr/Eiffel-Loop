note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-11-25 17:07:35 GMT (Saturday 25th November 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 02_05_00

	Build_number: NATURAL = 105

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end