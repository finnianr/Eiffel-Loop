note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2021-06-15 8:53:19 GMT (Tuesday 15th June 2021)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_04_06

	Build_number: NATURAL = 551

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/toolkit"
		end

end