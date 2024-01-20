note
	description: "Fields conforming to ${READABLE_STRING_8} are initialized from the attribute name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

deferred class
	EL_REFLECTIVE_STRING_CONSTANTS

inherit
	EL_REFLECTIVE
		rename
			field_included as is_readable_string_8
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			across field_table as table loop
				table.item.set_from_string (Current, table.item.export_name)
			end
		end

feature {NONE} -- Implementation

	is_readable_string_8 (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.is_readable_string_8
		end

end