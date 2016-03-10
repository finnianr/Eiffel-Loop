note
	description: "[
		across loop duplicating Eiffel syntax
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-25 23:13:14 GMT (Thursday 25th July 2013)"
	revision: "3"

class
	EVOLICITY_ACROSS_DIRECTIVE

inherit
	EVOLICITY_FOREACH_DIRECTIVE
		redefine
			make, put_loop_index, put_iteration_object, Loop_index_var_name
		end

create
	make

feature -- Initialization

	make
			--
		do
			Precursor
			create iterater_context.make
			create local_scope_variable_names.make_filled ("", 1, 1)
		end

feature {NONE} -- Implementation

	put_loop_index (a_context: EVOLICITY_CONTEXT; a_loop_index: INTEGER_REF)
		do
			iterater_context.put_variable (a_loop_index, Loop_index_var_name)
		end

	put_iteration_object (a_context: EVOLICITY_CONTEXT; a_cursor: ITERATION_CURSOR [ANY]; a_iteration_object: ANY)
		do
			iterater_context.put_variable (a_iteration_object, Iteration_object_name)
			if attached {HASH_TABLE_ITERATION_CURSOR [ANY, HASHABLE]} a_cursor as hash_table_cursor then
				if attached {STRING} hash_table_cursor.key as string_key then
					iterater_context.put_variable (string_key, Iteration_key_object_name)
				else
					iterater_context.put_variable (hash_table_cursor.key.out, Iteration_key_object_name)
				end
			end
			a_context.put_variable (iterater_context, iterator_var_name)
		end

	iterater_context: EVOLICITY_CONTEXT_IMPL

feature {NONE} -- Constants

	Iteration_object_name: STRING = "item"

	Iteration_key_object_name: STRING = "key"
		-- Hash table iterator key name

	Loop_index_var_name: STRING = "cursor_index"

end