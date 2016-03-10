note
	description: "Build specification"

	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_02_06

	Build_number: NATURAL = 285

	Installation_sub_directory: EL_DIR_PATH
		once
			create Result.make_from_unicode ("Eiffel-Loop/manage-mp3")
		end

end