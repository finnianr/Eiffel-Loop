note
	description: "Dj event info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:33:47 GMT (Saturday 31st August 2019)"
	revision: "1"

class
	DJ_EVENT_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create publisher.make
			Precursor
			dj_name := "Unknown"
		end

feature -- Access

	default_title: ZSTRING

	dj_name: ZSTRING

	publisher: DJ_EVENT_PUBLISHER_CONFIG
end
