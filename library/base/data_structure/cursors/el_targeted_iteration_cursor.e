note
	description: "[
		A supporting class for ${EL_ITERATION_CURSOR_FACTORY} providing an additional way to use an `across' loop on a structure
		that already has implements `new_cursor'.
	]"
	notes: "[
		**Examples**
		
			${JSON_ZNAME_VALUE_LIST}.pairs
			${EL_PLAIN_TEXT_FILE}.lines
			
		Both of these classes already have a definition for `new_cursor'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 14:48:55 GMT (Saturday 22nd March 2025)"
	revision: "1"


deferred class
	EL_TARGETED_ITERATION_CURSOR [G, TARGET]

inherit
	ITERATION_CURSOR [G]

feature {NONE} -- Initialization

	make (a_target: TARGET)
		deferred
		ensure
			target_assigned: target = a_target
		end

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Access

	target: TARGET

end
