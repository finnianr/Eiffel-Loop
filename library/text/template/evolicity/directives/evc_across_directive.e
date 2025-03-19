note
	description: "Implements an **across** loop imitating Eiffel syntax as alternative to **foreach** syntax"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:01:13 GMT (Tuesday 18th March 2025)"
	revision: "11"

class
	EVC_ACROSS_DIRECTIVE

inherit
	EVC_FOREACH_DIRECTIVE
		rename
			var_loop_index as var_cursor_index
		redefine
			has_key_item, item_name, make, put_loop_index, put_table_key, put_iteration_object,
			var_cursor_index
		end

create
	make

feature -- Initialization

	make
			--
		do
			Precursor
			create iterater_context.make
			local_scope_variable_names.wipe_out
		end

feature {NONE} -- Implementation

	has_key_item: BOOLEAN
		do
			Result := True
		end

	item_name: STRING
		do
			Result := local_scope_variable_names [1]
		end

	put_iteration_object (a_context: EVC_CONTEXT; cursor_item: ANY)
		do
			iterater_context.put_any (Var.item_, cursor_item)
			a_context.put_any (item_name, iterater_context)
		end

	put_table_key (a_context: EVC_CONTEXT; key_item: ANY)
		do
			iterater_context.put_any (Var.key, key_item)
		end

	put_loop_index (a_context: EVC_CONTEXT; a_loop_index: INTEGER_REF)
		do
			iterater_context.put_any (var_cursor_index, a_loop_index)
		end

	var_cursor_index: IMMUTABLE_STRING_8
	 	do
	 		Result := Var.cursor_index
	 	end

feature {NONE} -- Internal attributes

	iterater_context: EVC_CONTEXT_IMP

end