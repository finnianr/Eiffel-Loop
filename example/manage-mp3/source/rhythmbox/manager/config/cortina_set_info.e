note
	description: "Cortina set info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	CORTINA_SET_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			element_node_fields as Empty_set,
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
		-- fade in duration

	fade_out: REAL
		-- fade out duration

	tango_count: INTEGER

	tangos_per_vals: INTEGER
end