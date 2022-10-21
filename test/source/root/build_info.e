note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2022-10-21 13:40:05 GMT (Friday 21st October 2022)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_04_05

	Build_number: NATURAL = 266

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end