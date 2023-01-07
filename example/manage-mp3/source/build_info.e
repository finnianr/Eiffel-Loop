note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-01-06 17:06:03 GMT (Friday 6th January 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 02_04_05

	Build_number: NATURAL = 101

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end