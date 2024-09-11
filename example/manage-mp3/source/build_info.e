note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2024-09-10 9:10:37 GMT (Tuesday 10th September 2024)"
	revision: "2"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Build_number: NATURAL = 107

	Compatibility_mode: STRING = "Win7"
		-- Windows compatibility mode for registry entry in Layers

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

	Version_number: NATURAL = 02_05_00

end