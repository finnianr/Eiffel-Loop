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
	date: "2024-09-30 15:19:19 GMT (Monday 30th September 2024)"
	revision: "16"

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

	EL_CONTAINER_CONVERSION [G]
		undefine
			copy, is_equal
		end

	EL_CONTAINER_HANDLER

create
	make, make_from_for, make_from_if, make_with_tuple_1, make_with_tuple_2

convert
	make_with_tuple_1 ({TUPLE [ARRAY [G], FUNCTION [G, R]]}),
	make_with_tuple_2 ({TUPLE [EL_ARRAYED_LIST [G], FUNCTION [G, R]]})

feature {NONE} -- Initialization

	make (container: CONTAINER [G]; to_item: FUNCTION [G, R])
		require
			valid_function: as_structure (container).valid_open_argument (to_item)
		do
			if attached as_structure (container) as structure
				and then attached structure.new_special (True, False) as container_area
			then
				make_results (to_item, container_area, container_count (container))
			else
				make_empty
			end
		ensure
			same_count: count = container_count (container)
		end

	make_from_for (container: CONTAINER [G]; condition: EL_QUERY_CONDITION [G]; to_item: FUNCTION [G, R])
		-- initialize from `container' with conversion function `to_item'
		require
			valid_function: as_structure (container).valid_open_argument (to_item)
		do
			if attached as_structure (container).query (condition) as list then
				make_results (to_item, list.area, list.count)
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

	make_results (to_item: FUNCTION [G, R]; a_area: SPECIAL [G]; a_count: INTEGER)
		local
			i: INTEGER
		do
			make_sized (a_count)
			if attached area as l_area then
				from until i = a_count loop
					l_area.extend (to_item (a_area [i]))
					i := i + 1
				end
			end
		end

feature -- Access

	to_list: EL_ARRAYED_LIST [R]
		do
			create Result.make_from_special (area_v2)
		end

end