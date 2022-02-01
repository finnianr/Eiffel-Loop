note
	description: "Default license notes for Eiffel source. See class [$source SOURCE_MANIFEST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-01 11:51:14 GMT (Tuesday 1st February 2022)"
	revision: "5"

class
	LICENSE_NOTES

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_names as export_default,
			make_default as make,
			element_node_fields as Empty_set
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