note
	description: "[
		Builds an operand conforming to ${EL_BUILDABLE_FROM_FILE} in `make' routine argument tuple
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_BUILDABLE_FROM_FILE_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [FILE_PATH]
		rename
			put_reference as build_object,
			value as file_path
		redefine
			build_object
		end

create
	make

feature {NONE} -- Implementation

	build_object (a_file_path: like file_path)
		do
			if attached {EL_BUILDABLE_FROM_FILE} operands.reference_item (index) as buildable then
				buildable.build_from_file (a_file_path)
			end
		end

end