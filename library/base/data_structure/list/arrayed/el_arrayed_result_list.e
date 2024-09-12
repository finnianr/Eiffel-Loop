note
	description: "[
		An ${EL_ARRAYED_LIST [R]} that is the result of applying a function to all the items in
		a container conforming to ${CONTAINER [G]} where **R** is the result type,
		and **G** is the function operand type.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-12 12:44:58 GMT (Thursday 12th September 2024)"
	revision: "14"

class
	EL_ARRAYED_RESULT_LIST [G, R]

inherit
	EL_ARRAYED_LIST [R]
		rename
			as_structure as as_result_structure,
			make as make_sized,
			make_from_for as make_from_container_for,
			make_from_if as make_from_container_if
		end

create
	make, make_from_for, make_from_if, make_with_tuple_1, make_with_tuple_2

convert
	make_with_tuple_1 ({TUPLE [ARRAY [G], FUNCTION [G, R]]}),
	make_with_tuple_2 ({TUPLE [EL_ARRAYED_LIST [G], FUNCTION [G, R]]})

feature {NONE} -- Initialization

	make (container: CONTAINER [G]; to_item: FUNCTION [G, R])
		require
			valid_function: operand_item (container).is_valid_for (to_item)
		do
			if attached as_structure (container) as structure
				and then attached {EL_ARRAYED_LIST [R]} structure.derived_list (to_item)
				as result_list
			then
				make_from_special (result_list.area)
			else
				make_empty
			end
		ensure
			same_count: count = container_count (container)
		end

	make_from_for (container: CONTAINER [G]; condition: EL_QUERY_CONDITION [G]; to_item: FUNCTION [G, R])
		-- initialize from `container' with conversion function `to_item'
		require
			valid_function: operand_item (container).is_valid_for (to_item)
		do
			if attached as_structure (container) as structure
				and then attached {EL_ARRAYED_LIST [R]} structure.derived_list_meeting (to_item, condition)
				as result_list
			then
				make_from_special (result_list.area)
			else
				make_empty
			end
		end

	make_from_if (container: CONTAINER [G]; condition: EL_PREDICATE_QUERY_CONDITION [G]; to_item: FUNCTION [G, R])
		do
			make_from_for (container, condition, to_item)
		end

	make_with_tuple_1 (tuple: TUPLE [array: ARRAY [G]; to_item: FUNCTION [G, R]])
		do
			make (tuple.array, tuple.to_item)
		end

	make_with_tuple_2 (tuple: TUPLE [list: EL_ARRAYED_LIST [G]; to_item: FUNCTION [G, R]])
		do
			make (tuple.list, tuple.to_item)
		end

feature -- Access

	to_list: EL_ARRAYED_LIST [R]
		do
			create Result.make_from_special (area_v2)
		end

feature -- Contract Support

	operand_item (container: CONTAINER [G]): EL_CONTAINER_ITEM [G]
		do
			create Result.make (container)
		end

feature {NONE} -- Implementation

	as_structure (container: CONTAINER [G]): EL_CONTAINER_STRUCTURE [G]
		do
			if attached {EL_CONTAINER_STRUCTURE [G]} container as structure then
				Result := structure
			else
				create {EL_CONTAINER_WRAPPER [G]} Result.make (container)
			end
		end

end