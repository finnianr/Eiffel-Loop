note
	description: "[
		Syntax for looping over a sequence:
			
			#foreach <iteration object variable name> in <sequence name> loop
				
			#end
			
		The iteration object variable name references the current sequence item.
		Variable 'loop_index' references the sequence index
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

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

feature {NONE} -- Implementation

	execute (a_context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			loop_index: INTEGER_REF; i: INTEGER; l_cursor: ITERATION_CURSOR [ANY]
			name_space: like outer_loop_variables
		do
			name_space := a_context.objects
			if attached {ITERABLE [ANY]} a_context.referenced_item (traversable_container_variable_ref) as iterable then
				save_outer_loop_variables (name_space)
				create loop_index
				put_loop_index (a_context, loop_index)

				from l_cursor := iterable.new_cursor; i := 1 until l_cursor.after loop
					loop_index.set_item (i)
					if attached {ANY} l_cursor.item as cursor_item then
--						if attached {EVOLICITY_CONTEXT} cursor_item as container_context then
--							put_iteration_object (a_context, l_cursor, container_context)

--						elseif attached {STRING} cursor_item as string_item then
--							put_iteration_object (a_context, l_cursor, string_item)

--						elseif attached {ITERABLE [ANY]} cursor_item as nested_iterable then
--							put_iteration_object (a_context, l_cursor, nested_iterable)

--						else
--							put_iteration_object (a_context, l_cursor, cursor_item.out)
--						end
						if a_context.is_valid_type (cursor_item) then
							put_iteration_object (a_context, l_cursor, cursor_item)
						else
							put_iteration_object (a_context, l_cursor, cursor_item.out)
						end
					else
						name_space.remove (iterator_var_name)
					end
					Precursor (a_context, output)
					l_cursor.forth; i := i + 1
				end
				name_space.remove (iterator_var_name)

				restore_outer_loop_variables (name_space)
			end
		end

	put_iteration_object (a_context: EVOLICITY_CONTEXT; a_cursor: ITERATION_CURSOR [ANY]; a_iteration_object: ANY)
		do
			a_context.put_variable (a_iteration_object, iterator_var_name)
		end

	put_loop_index (a_context: EVOLICITY_CONTEXT; a_loop_index: INTEGER_REF)
		do
			a_context.put_variable (a_loop_index, Loop_index_var_name)
		end

	restore_outer_loop_variables (name_space: like outer_loop_variables)
			-- Restore any previous objects that had the same name as objects used in this loop
		local
			variables: like outer_loop_variables
		do
			variables := outer_loop_variables
			from variables.start until variables.after loop
				name_space [variables.key_for_iteration] := variables.item_for_iteration
				variables.forth
			end
			variables.wipe_out
		end

	save_outer_loop_variables (name_space: like outer_loop_variables)
			-- Save value of context objects with same names as objects used in this loop
		require
			empty_saved_objects_context: outer_loop_variables.is_empty
		local
			i: INTEGER; name: ZSTRING; names: like local_scope_variable_names
		do
			names := local_scope_variable_names
			from i := 1 until i > names.count loop
				name := names [i]
				if name_space.has_key (name) then
					outer_loop_variables.extend (name_space.found_item, name)
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	iterator_var_name: ZSTRING

	local_scope_variable_names: ARRAY [ZSTRING]

	outer_loop_variables: EVOLICITY_OBJECT_TABLE [ANY]
		-- Variables in outer loop that may have names clashing with this loop

	traversable_container_variable_ref: EVOLICITY_VARIABLE_REFERENCE

feature -- Constants

	Loop_index_var_name: ZSTRING
		once
			Result := "loop_index"
		end

end
