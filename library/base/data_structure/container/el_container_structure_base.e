note
	description: "Implementation base routines for ${EL_CONTAINER_STRUCTURE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 18:58:30 GMT (Thursday 17th April 2025)"
	revision: "1"

deferred class
	EL_CONTAINER_STRUCTURE_BASE [G]

inherit
	EL_MODULE_EIFFEL; EL_MODULE_ITERABLE

	EL_SHARED_FACTORIES

feature -- Access

	item_type: TYPE [G]
		do
			Result := {G}
		end

feature -- Measurement

	count: INTEGER
		do
			Result := container_count (current_container)
		end

feature -- Contract Support

	object_comparison: BOOLEAN
		do
			Result := current_container.object_comparison
		end

	result_type (value: FUNCTION [G, ANY]): TYPE [ANY]

		do
			Result := value.generating_type.generic_parameter_type (2)
		end

	valid_open_argument (to_value: FUNCTION [G, ANY]): BOOLEAN
		-- `True' if `to_value' has single open argument that is the same as `item_type'
		do
			if attached to_value.generating_type.generic_parameter_type (1) as argument_types
				and then argument_types.generic_parameter_count = 1
			then
				Result := argument_types.generic_parameter_type (1) ~ item_type
			end
		end

feature {NONE} -- Implementation

	any_item: EL_ANY_QUERY_CONDITION [G]
		do
			create Result
		end

	as_structure (container: CONTAINER [G]): EL_CONTAINER_STRUCTURE [G]
		do
			if attached {EL_CONTAINER_STRUCTURE [G]} container as structure then
				Result := structure
			else
				create {EL_CONTAINER_WRAPPER [G]} Result.make (container)
			end
		end

	container_count (container: CONTAINER [ANY]): INTEGER
		do
			if attached {FINITE [ANY]} container as finite then
				Result := finite.count

			elseif attached {READABLE_INDEXABLE [ANY]} container as array then
				Result := array.upper - array.lower + 1

			elseif attached {TREE [ANY]} container as tree then
				Result := tree.count

			elseif attached {SEARCH_TABLE [HASHABLE]} container as table then
				Result := table.count

			elseif attached {ITERABLE [ANY]} container as current_iterable then
				across current_iterable as list loop
					Result := Result + 1
				end
			end
		end

	container_type (container: CONTAINER [ANY]): NATURAL_8
		local
			type_id: INTEGER
		do
			type_id := {ISE_RUNTIME}.dynamic_type (container)
			if attached Container_type_map as type_map then
				if type_map.has_key (type_id) then
					Result := type_map.found_item

				else
					if attached {TO_SPECIAL [G]} container as special
						and then attached {FINITE [G]} container as finite
					then
						if attached {STRING_GENERAL} container then
							Result := Type_string
						else
							Result := Type_special
						end

					elseif attached {LINEAR [G]} container then
					-- Better to prioritise for linked lists and also `EL_FILE_GENERAL_LINE_SOURCE'
					-- iterator uses `shared_item' and not `item_copy'
						Result := Type_linear

					elseif attached {READABLE_INDEXABLE [G]} container then
						Result := Type_indexable

					elseif attached {ITERABLE [G]} container then
						Result := Type_iterable
					else
						Result := Type_default
					end
					type_map.extend (Result, type_id)
				end
			end
		end

	container_first (container: CONTAINER [G]): G
		local
			break: BOOLEAN
		do
			if attached {READABLE_INDEXABLE [G]} container as array then
				Result :=  array [array.lower]

			elseif attached {ITERABLE [G]} container as current_iterable then
				across current_iterable as list until break loop
					Result := list.item; break := True
				end

			elseif attached {TREE [G]} container as tree then
				if attached tree.child_cursor as cursor then
					from tree.child_start until tree.child_off or break loop
						Result := tree.item; break := True
					end
					tree.child_go_to (cursor)
				end
			end
		end

	item_area: detachable SPECIAL [G]
		do
		end

	is_string_container: BOOLEAN
		do
		end

	new_special (shared: BOOLEAN; same_count: BOOLEAN): SPECIAL [G]
		local
			one_extra: INTEGER
		do
			if attached item_area as area then
				if shared then
					if same_count and then is_string_container then
						Result := area.resized_area (count)
					else
						Result := area
					end
				else
				--	one extra for string null terminator
					if is_string_container and not same_count then
						one_extra := 1
					end
					Result := area.resized_area (count + one_extra)
				end
			else
				create Result.make_empty (count)
				do_for_all (create {EL_EXTEND_SPECIAL_ACTION [G]}.make (Result))
			end
		ensure
			valid_count: same_count implies Result.count = count
		end

	type_of_container (container: CONTAINER [ANY]): NATURAL_8
		do
			Result := container_type (container)
		end

feature {EL_CONTAINER_HANDLER} -- Deferred

	current_container: CONTAINER [G]
		-- assign Current to Result in descendant
		deferred
		end

	do_for_all (action: EL_CONTAINER_ACTION [G])
		deferred
		end

feature {NONE} -- Constants

	Container_type_map: EL_HASH_TABLE [NATURAL_8, INTEGER]
		-- map dynamic type of container to one of `Type_*' categories
		once
			create Result.make (50)
		end

	Cursor_stack: ARRAYED_STACK [CURSOR]
		once
			create Result.make (5)
		end

	Index_stack: ARRAYED_STACK [INTEGER]
		once
			create Result.make (5)
		end

	Type_special: NATURAL_8 = 1

	Type_linear: NATURAL_8 = 2

	Type_indexable: NATURAL_8 = 3

	Type_iterable: NATURAL_8 = 4

	Type_string: NATURAL_8 = 5

	Type_default: NATURAL_8 = 6

end