note
	description: "DJ event information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 10:02:46 GMT (Saturday 31st December 2022)"
	revision: "8"

class
	DJ_EVENT_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			field_included as is_any_field,
			xml_naming as eiffel_naming,
			element_node_fields as Empty_set
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			dj_name := "Unknown"
		end

feature -- Access

	default_title: ZSTRING

	dj_name: ZSTRING

end