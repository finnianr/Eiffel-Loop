note
	description: "Fields conforming to [$source READABLE_STRING_8] are initialized from the attribute name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_REFLECTIVE_STRING_CONSTANTS

inherit
	EL_REFLECTIVE
		rename
			field_included as is_readable_string_8
		redefine
			default_create
		end

	EL_SHARED_CLASS_ID

feature {NONE} -- Initialization

	default_create
		do
			across field_table as table loop
				table.item.set_from_string (Current, table.item.export_name)
			end
		end

feature {NONE} -- Implementation

	is_readable_string_8 (basic_type, type_id: INTEGER): BOOLEAN
		do
			if Eiffel.is_reference (basic_type) then
				Result := Class_id.readable_string_8_types.has (type_id)
			end
		end

end