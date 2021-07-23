note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2021-07-23 7:55:52 GMT (Friday 23rd July 2021)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 02_03_02

	Build_number: NATURAL = 78

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end