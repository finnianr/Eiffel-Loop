note
	description: "Implements an **across** loop imitating Eiffel syntax as alternative to **foreach** syntax"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-04 15:15:56 GMT (Sunday 4th September 2022)"
	revision: "6"

class
	EVOLICITY_ACROSS_DIRECTIVE

inherit
	EVOLICITY_FOREACH_DIRECTIVE
		redefine
			is_valid_iterable, make, put_loop_index, put_iteration_object, Loop_index_var_name
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
			create local_scope_variable_names.make_filled ("", 1, 1)
		end

feature -- Contract Support

	is_valid_iterable (a_context: EVOLICITY_CONTEXT): BOOLEAN
		-- `True' if iterable object has valid items
		local
			inspected: BOOLEAN
		do
			if attached {TABLE_ITERABLE [ANY, HASHABLE]} iterable_container (a_context) as iterable_table then
				across iterable_table as table until inspected loop
					Result := a_context.is_valid_type (table.item) and a_context.is_valid_type (table.key)
					inspected := True
				end
				if not inspected then
					Result := True
				end
			else
				Result := Precursor (a_context)
			end
		end

feature {NONE} -- Implementation

	put_loop_index (a_context: EVOLICITY_CONTEXT; a_loop_index: INTEGER_REF)
		do
			iterater_context.put_variable (a_loop_index, Loop_index_var_name)
		end

	put_iteration_object (a_context: EVOLICITY_CONTEXT; a_cursor: ITERATION_CURSOR [ANY]; cursor_item: ANY)
		do
			iterater_context.put_variable (cursor_item, Iteration_object_name)
			if attached {HASH_TABLE_ITERATION_CURSOR [ANY, HASHABLE]} a_cursor as table then
				if a_context.is_valid_type (table.key) then
					iterater_context.put_variable (table.key, Iteration_key_object_name)

				elseif attached (Invalid_item #$ [table.key.generator, table.cursor_index]) as object then
					iterater_context.put_variable (object, Iteration_key_object_name)
				end
			end
			a_context.put_variable (iterater_context, iterator_var_name)
		end

	iterater_context: EVOLICITY_CONTEXT_IMP

feature {NONE} -- Constants

	Iteration_object_name: STRING = "item"

	Iteration_key_object_name: STRING = "key"
		-- Hash table iterator key name

	Loop_index_var_name: STRING = "cursor_index"

end