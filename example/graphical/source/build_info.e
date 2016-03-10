note
	description: "Build specification"

	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Major_version: INTEGER = 1

	Minor_version: INTEGER = 0

	Build_number: INTEGER = 8

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/graphical"
		end

end
