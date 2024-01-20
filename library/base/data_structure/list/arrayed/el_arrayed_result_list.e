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
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "12"

class
	EL_ARRAYED_RESULT_LIST [G, R]

inherit
	EL_ARRAYED_LIST [R]
		rename
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
		do
			make_from_for (container, create {EL_ANY_QUERY_CONDITION [G]}, to_item)
		ensure
			same_count: count = container_count (container)
		end

	make_from_for (container: CONTAINER [G]; condition: EL_QUERY_CONDITION [G]; to_item: FUNCTION [G, R])
		-- initialize from `container' with conversion function `to_item'
		require
			valid_function: operand_item (container).is_valid_for (to_item)
		local
			wrapper: EL_CONTAINER_WRAPPER [G]; i, l_count: INTEGER
			argument: G
		do
			create wrapper.make (container)
			l_count := wrapper.count
			make_sized (l_count)
			if l_count > 0 then
				if attached wrapper.to_special as container_area and then attached area as l_area then
					from until i = l_count loop
						argument := container_area [i]
						if condition.met (argument) then
							l_area.extend (to_item (argument))
						end
						i := i + 1
					end
					if l_area.count < l_count then
						make_from_special (l_area.aliased_resized_area (l_area.count))
					end
				end
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

end