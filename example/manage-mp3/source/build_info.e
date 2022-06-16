note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-06-16 10:55:39 GMT (Thursday 16th June 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 02_04_00

	Build_number: NATURAL = 94

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end