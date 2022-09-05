note
	description: "Implements an **across** loop imitating Eiffel syntax as alternative to **foreach** syntax"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-05 9:17:18 GMT (Monday 5th September 2022)"
	revision: "7"

class
	EVOLICITY_ACROSS_DIRECTIVE

inherit
	EVOLICITY_FOREACH_DIRECTIVE
		redefine
			has_key_item, item_name, make, put_loop_index, put_table_key, put_iteration_object,
			Loop_index_var_name
		end

	EL_ZSTRING_CONSTANTS

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

	put_iteration_object (a_context: EVOLICITY_CONTEXT; cursor_item: ANY)
		do
			iterater_context.put_variable (cursor_item, Iteration_object_name)
			a_context.put_variable (iterater_context, item_name)
		end

	put_table_key (a_context: EVOLICITY_CONTEXT; key_item: ANY)
		do
			iterater_context.put_variable (key_item, Iteration_key_object_name)
		end

	put_loop_index (a_context: EVOLICITY_CONTEXT; a_loop_index: INTEGER_REF)
		do
			iterater_context.put_variable (a_loop_index, Loop_index_var_name)
		end

feature {NONE} -- Internal attributes

	iterater_context: EVOLICITY_CONTEXT_IMP

feature {NONE} -- Constants

	Iteration_key_object_name: STRING = "key"
		-- Hash table iterator key name

	Iteration_object_name: STRING = "item"

	Loop_index_var_name: STRING = "cursor_index"

end