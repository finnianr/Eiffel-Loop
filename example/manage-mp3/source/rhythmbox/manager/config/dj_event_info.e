note
	description: "DJ event information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-30 11:19:59 GMT (Sunday 30th January 2022)"
	revision: "5"

class
	DJ_EVENT_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
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