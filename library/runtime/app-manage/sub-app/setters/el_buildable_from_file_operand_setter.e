note
	description: "Summary description for {EL_BUILDABLE_FROM_FILE_OPERAND_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-01 9:19:15 GMT (Thursday 1st June 2017)"
	revision: "1"

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
