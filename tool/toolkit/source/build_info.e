note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-03-10 17:43:57 GMT (Friday 10th March 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_07_00

	Build_number: NATURAL = 601

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/toolkit"
		end

end