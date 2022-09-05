note
	description: "[
		Implemention of iteration of a container conforming to [$source ITERABLE [G] using the
		syntax
			
			#foreach $<item-variable-name> in $<iterable-container> loop
				
			#end
			
		The iteration variable name references the current iteration item.
		Variable `$loop_index' references the ''cursor_index''
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-05 16:29:30 GMT (Monday 5th September 2022)"
	revision: "9"

class
	EVOLICITY_FOREACH_DIRECTIVE

inherit
	EVOLICITY_COMPOUND_DIRECTIVE
		redefine
			execute, make
		end

create
	make

feature -- Initialization

	make
			--
		do
			Precursor
			create outer_loop_variables.make_equal (3)
			create local_scope_variable_names.make_from_array (<< Loop_index_var_name >>)
		end

feature -- Element change

	put_item_name (a_item_name: STRING)
			--
		do
			local_scope_variable_names.extend (a_item_name)
		ensure
			maximum_3: (1 |..| 3).has (local_scope_variable_names.count)
		end

	set_traversable_container_variable_ref (a_traversable_container_variable_ref: EVOLICITY_VARIABLE_REFERENCE)
			--
		do
			traversable_container_variable_ref := a_traversable_container_variable_ref
		end

	has_key_item: BOOLEAN
		do
			Result := local_scope_variable_names.count = 3
		end

feature -- Contract Support

	is_valid_iterable (a_context: EVOLICITY_CONTEXT): BOOLEAN
		-- `True' if iterable object has valid items
		local
			inspected: BOOLEAN
		do
			if attached iterable_container (a_context) as iterable then
				if attached {TABLE_ITERABLE [ANY, HASHABLE]} iterable as table_iterable  then
					across table_iterable as table until inspected loop
						Result := a_context.is_valid_type (table.item) and a_context.is_valid_type (table.key)
						inspected := True
					end
				else
					across iterable as list until inspected loop
						Result := a_context.is_valid_type (list.item)
						inspected := True
					end
				end
				if not inspected then
					Result := True
				end
			end
		end

feature {NONE} -- Implementation

	execute (a_context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			loop_index: INTEGER_REF; name_space: like outer_loop_variables; cursor_index: INTEGER
			is_valid_type, is_valid_key_type: BOOLEAN; table_cursor: detachable HASH_TABLE_ITERATION_CURSOR [ANY, HASHABLE]
		do
			name_space := a_context.object_table
			if attached iterable_container (a_context) as iterable then
				save_outer_loop_variables (name_space)
				create loop_index
				put_loop_index (a_context, loop_index)

				across iterable as list loop
					cursor_index := cursor_index + 1
					if cursor_index = 1 then
						is_valid_type := a_context.is_valid_type (list.item)
						if attached {HASH_TABLE_ITERATION_CURSOR [ANY, HASHABLE]} list as l_cursor then
							table_cursor := l_cursor
							is_valid_key_type := a_context.is_valid_type (l_cursor.key)
						end
					end
					loop_index.set_item (cursor_index)
					if attached list.item as cursor_item then
						if is_valid_type then
							put_iteration_object (a_context, cursor_item)
						else
							put_iteration_object (a_context, Invalid_item #$ [cursor_item.generator, cursor_index])
						end
						if attached table_cursor as table and then has_key_item then
							if is_valid_key_type then
								put_table_key (a_context, table.key)
							else
								put_table_key (a_context, Invalid_item #$ [table.key.generator, cursor_index] )
							end
						end
					else
						name_space.remove (item_name)
					end
					Precursor (a_context, output)
				end
				name_space.remove (item_name)

				restore_outer_loop_variables (name_space)
			end
		end

	item_name: STRING
		do
			Result := local_scope_variable_names [2]
		end

	iterable_container (a_context: EVOLICITY_CONTEXT): detachable ITERABLE [ANY]
		do
			if attached {ITERABLE [ANY]} a_context.referenced_item (traversable_container_variable_ref) as iterable then
				Result := iterable
			end
		end

	key_item_name: STRING
		require
			has_key_item: has_key_item
		do
			Result := local_scope_variable_names [3]
		end

	put_iteration_object (a_context: EVOLICITY_CONTEXT; cursor_item: ANY)
		do
			a_context.put_variable (cursor_item, item_name)
		end

	put_table_key (a_context: EVOLICITY_CONTEXT; key_item: ANY)
		do
			a_context.put_variable (key_item, key_item_name)
		end

	put_loop_index (a_context: EVOLICITY_CONTEXT; a_loop_index: INTEGER_REF)
		do
			a_context.put_variable (a_loop_index, Loop_index_var_name)
		end

	restore_outer_loop_variables (name_space: like outer_loop_variables)
			-- Restore any previous objects that had the same name as objects used in this loop
		do
			if attached outer_loop_variables as list then
				from list.start until list.after loop
					name_space [list.key_for_iteration] := list.item_for_iteration
					list.forth
				end
				list.wipe_out
			end
		end

	save_outer_loop_variables (name_space: like outer_loop_variables)
			-- Save value of context objects with same names as objects used in this loop
		require
			empty_saved_objects_context: outer_loop_variables.is_empty
		local
			i: INTEGER; name: STRING
		do
			if attached local_scope_variable_names as list then
				from i := 1 until i > list.count loop
					name := list [i]
					if name_space.has_key (name) then
						outer_loop_variables.extend (name_space.found_item, name)
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	local_scope_variable_names: EL_STRING_8_LIST

	outer_loop_variables: HASH_TABLE [ANY, STRING]
		-- Variables in outer loop that may have names clashing with this loop

	traversable_container_variable_ref: EVOLICITY_VARIABLE_REFERENCE

feature -- Constants

	Invalid_item: ZSTRING
		once
			Result := "{%S} [%S]"
		end

	Loop_index_var_name: STRING
		once
			Result := "loop_index"
		end

end