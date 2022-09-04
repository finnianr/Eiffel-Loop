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
	date: "2022-09-04 15:15:56 GMT (Sunday 4th September 2022)"
	revision: "8"

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
			create local_scope_variable_names.make_filled ("", 1, 2)
			local_scope_variable_names [2] := Loop_index_var_name
		end

feature -- Element change

	set_traversable_container_variable_ref (a_traversable_container_variable_ref: EVOLICITY_VARIABLE_REFERENCE)
			--
		do
			traversable_container_variable_ref := a_traversable_container_variable_ref
		end

	set_var_iterator (a_iterator_var_name: ZSTRING)
			--
		do
			iterator_var_name := a_iterator_var_name
			local_scope_variable_names [1] := a_iterator_var_name
		end

feature -- Contract Support

	is_valid_iterable (a_context: EVOLICITY_CONTEXT): BOOLEAN
		-- `True' if iterable object has valid items
		local
			inspected: BOOLEAN
		do
			if attached {ITERABLE [ANY]} a_context.referenced_item (traversable_container_variable_ref) as iterable then
				across iterable as list until inspected loop
					Result := a_context.is_valid_type (list.item)
					inspected := True
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
			is_valid_type: BOOLEAN
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
					end
					loop_index.set_item (cursor_index)
					if attached list.item as cursor_item then
						if is_valid_type then
							put_iteration_object (a_context, list, cursor_item)
						else
							put_iteration_object (a_context, list, Invalid_item #$ [cursor_item.generator, cursor_index])
						end
					else
						name_space.remove (iterator_var_name)
					end
					Precursor (a_context, output)
				end
				name_space.remove (iterator_var_name)

				restore_outer_loop_variables (name_space)
			end
		end

	iterable_container (a_context: EVOLICITY_CONTEXT): detachable ITERABLE [ANY]
		do
			if attached {ITERABLE [ANY]} a_context.referenced_item (traversable_container_variable_ref) as iterable then
				Result := iterable
			end
		end

	put_iteration_object (a_context: EVOLICITY_CONTEXT; a_cursor: ITERATION_CURSOR [ANY]; cursor_item: ANY)
		do
			a_context.put_variable (cursor_item, iterator_var_name)
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

	iterator_var_name: STRING

	local_scope_variable_names: ARRAY [STRING]

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