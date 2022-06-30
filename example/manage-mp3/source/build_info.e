note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-06-30 11:59:17 GMT (Thursday 30th June 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 02_04_01

	Build_number: NATURAL = 96

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end