note
	description: "[
		An [$source EL_ARRAYED_LIST [R]] that is the result of applying a function to all the items in
		a container conforming to [$source CONTAINER [G]] where **R** is the result type,
		and **G** is the function operand type.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-15 6:35:45 GMT (Saturday 15th October 2022)"
	revision: "5"

class
	EL_ARRAYED_RESULT_LIST [G, R]

inherit
	EL_ARRAYED_LIST [R]
		rename
			make as make_sized
		end

create
	make, make_with_tuple_1, make_with_tuple_2

convert
	make_with_tuple_1 ({TUPLE [ARRAY [G], FUNCTION [G, R]]}),
	make_with_tuple_2 ({TUPLE [EL_ARRAYED_LIST [G], FUNCTION [G, R]]})

feature {NONE} -- Initialization

	make (container: CONTAINER [G]; to_item: FUNCTION [G, R])
		-- initialize from `container' with conversion function `to_item'
		require
			valid_function: operand_item (container).is_valid_for (to_item)
		local
			pos: CURSOR; saved_cursor: EL_SAVED_CURSOR [G]
		do
			make_sized (container_count (container))
			if attached {LINEAR [G]} container as list then
				create saved_cursor.make (list)
				from list.start until list.after loop
					extend (to_item (list.item))
					list.forth
				end
				saved_cursor.restore

			elseif attached {ITERABLE [G]} container as list then
				across list as any loop
					extend (to_item (any.item))
				end

			elseif attached container.linear_representation as list then
				from list.start until list.after loop
					extend (to_item (list.item))
					list.forth
				end
			end
		ensure
			same_count: count = container_count (container)
		end

	make_with_tuple_1 (tuple: TUPLE [array: ARRAY [G]; to_item: FUNCTION [G, R]])
		do
			make (tuple.array, tuple.to_item)
		end

	make_with_tuple_2 (tuple: TUPLE [list: EL_ARRAYED_LIST [G]; to_item: FUNCTION [G, R]])
		do
			make (tuple.list, tuple.to_item)
		end

feature -- Contract Support

	operand_item (container: CONTAINER [G]): EL_CONTAINER_ITEM [G]
		do
			create Result.make (container)
		end

end