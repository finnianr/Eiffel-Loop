note
	description: "Cortina set info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 12:01:07 GMT (Friday 6th January 2023)"
	revision: "8"

class
	CORTINA_SET_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			element_node_fields as Empty_set,
			field_included as is_any_field,
			xml_naming as eiffel_naming
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			fade_in := 3.0; fade_out := 3.0
			clip_duration := 25
			tango_count := 8
			tangos_per_vals := 4
		end

feature -- Access

	clip_duration: INTEGER

	fade_in: REAL
		-- fade-in duration in secs

	fade_out: REAL
		-- fade-out duration in secs

	tango_count: INTEGER

	tangos_per_vals: INTEGER
end