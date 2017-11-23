note
	description: "[
		Object with string attributes that can be set using Eiffel reflection
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 15:07:05 GMT (Friday 10th November 2017)"
	revision: "1"

deferred class
	EL_REFLECTIVELY_SETTABLE_STRINGS [S -> STRING_GENERAL create make_empty end]

inherit
	EL_REFLECTIVELY_SETTABLE [S]
		redefine
			extend_field_table
		end

feature {NONE} -- Implementation

	extend_field_table (table: like new_field_index_table; object: like current_object; i: INTEGER)
		local
			name: STRING
		do
			if object.field_static_type (i) = string_type_id then
				name := object.field_name (i)
				name.prune_all_trailing ('_')
				table.extend (i, name)
			end
		end

end
