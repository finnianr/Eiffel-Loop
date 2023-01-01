note
	description: "Default license notes for Eiffel source. See class [$source SOURCE_MANIFEST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-30 17:58:35 GMT (Friday 30th December 2022)"
	revision: "9"

class
	LICENSE_NOTES

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			make_default as make,
			element_node_fields as Empty_set,
			xml_naming as eiffel_naming
		end

create
	make

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := across << author, contact, copyright, license >> as field all field.item.is_empty end
		end

feature -- Access

	author: ZSTRING

	contact: ZSTRING

	copyright: ZSTRING

	license: ZSTRING

end