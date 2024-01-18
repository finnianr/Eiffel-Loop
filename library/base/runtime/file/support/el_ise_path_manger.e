note
	description: "Get access to `storage' field in ${PATH} object"
	notes: "Accessible via ${EL_SHARED_PATH_MANAGER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-04 9:27:33 GMT (Saturday 4th November 2023)"
	revision: "1"

class
	EL_ISE_PATH_MANGER

inherit
	EL_OBJECT_MANGER [PATH]

feature -- Access

	as_string (a_item: PATH): ZSTRING
		do
			if {PLATFORM}.is_windows then
				create Result.make_from_utf_16_le (storage (a_item))
			else
				create Result.make_from_utf_8 (storage (a_item))
			end
		end

	storage (a_item: PATH): STRING
		do
			enclosing_object := a_item
			if attached {STRING} reference_field (field_table [Storage_index]) as str then
				Result := str
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Implementation

	new_item: PATH
		do
			create Result.make_empty
		end

feature {NONE} -- Constants

	Field_names: STRING = "storage"

	Shared_field_table: SPECIAL [INTEGER]
		once
			Result := new_field_table
		end

	Storage_index: INTEGER = 0

end