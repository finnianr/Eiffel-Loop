note
	description: "Abstraction for range parameters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-07 14:17:04 GMT (Friday 7th March 2025)"
	revision: "1"

deferred class
	RANGE_LIST_PARAMETER [N -> NUMERIC]

inherit
	LIST_PARAMETER [EL_ARRAYED_LIST [N]]

	EL_MODULE_NAMING

feature -- Basic operations

	display_item
		local
			name: ZSTRING
		do
			name := Naming.class_as_snake_lower (Current, 0, 3)
			name.to_proper
			if attached item.string_8_list (agent numeric_string).joined_words as number_string then
				log.put_index_labeled_string (index.to_reference, name + " range [%S]", number_string)
			end
			log.put_new_line
		end

feature {NONE} -- Build from XML

	extend_from_node
		local
			last_range: like item
		do
			if attached node.adjusted (False) as value_list then
				create last_range.make (value_list.occurrences (',') + 1)
				across value_list.split (',') as str loop
					last_range.extend (to_numeric (str.item))
				end
			end
			extend (last_range)
		end

feature {NONE} -- Deferred

	numeric_string (v: N): STRING
		deferred
		end

	to_numeric (string: ZSTRING): N
		deferred
		end

end