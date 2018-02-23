note
	description: "[
		Builds an operand conforming to [$source EL_BUILDABLE_FROM_FILE] in `make' routine argument tuple
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-14 12:01:15 GMT (Saturday 14th October 2017)"
	revision: "2"

class
	EL_BUILDABLE_FROM_FILE_OPERAND_SETTER

inherit
	EL_FILE_PATH_OPERAND_SETTER
		rename
			put_reference as build_object,
			value as file_path
		redefine
			build_object
		end

create
	make

feature {NONE} -- Implementation

	build_object (a_file_path: like file_path; i: INTEGER)
		do
			if attached {EL_BUILDABLE_FROM_FILE} app.operands.reference_item (i) as buildable then
				buildable.build_from_file (a_file_path)
			end
		end

end
