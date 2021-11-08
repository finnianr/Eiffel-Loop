note
	description: "[
		List that is the result of applying a function to all the items in a container
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-08 20:36:41 GMT (Monday 8th November 2021)"
	revision: "2"

class
	EL_ARRAYED_RESULT_LIST [R, G]

inherit
	EL_ARRAYED_LIST [R]
		rename
			make as make_sized
		end

	EL_MODULE_ITERABLE

	EL_MODULE_EIFFEL

create
	make, make_with_tuple_1, make_with_tuple_2

convert
	make_with_tuple_1 ({TUPLE [ARRAY [G], FUNCTION [G, R]]}),
	make_with_tuple_2 ({TUPLE [EL_ARRAYED_LIST [G], FUNCTION [G, R]]})

feature {NONE} -- Initialization

	make (container: CONTAINER [G]; to_item: FUNCTION [G, R])
		-- initialize from `container' with conversion function `to_item'
		require
			valid_open_argument: to_item.valid_operands ([proto_list_item])
		local
			pos: CURSOR
		do
			if attached {ITERABLE [G]} container as list then
				make_sized (Iterable.count (list))
				across list as any loop
					extend (to_item (any.item))
				end

			elseif attached {EL_CHAIN [G]} container as el_chain then
				el_chain.push_cursor
				make_sized (el_chain.count)
				from el_chain.start until el_chain.after loop
					extend (to_item (el_chain.item))
					el_chain.forth
				end
				el_chain.pop_cursor

			elseif attached {CHAIN [G]} container as chain then
				pos := chain.cursor
				make_sized (chain.count)
				from chain.start until chain.after loop
					extend (to_item (chain.item))
					chain.forth
				end
				chain.go_to (cursor)

			elseif attached {FINITE [G]} container as finite and
				then attached finite.linear_representation as list then
				make (list, to_item)
			end
		ensure
			same_count: attached {FINITE [G]} container as finite implies count = finite.count
			same_iterable_count: attached {ITERABLE [G]} container as list implies count = Iterable.count (list)
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

	proto_list_item: G
		-- uninitialized item for contract support
		do
			if attached {G} Eiffel.new_instance_of (({G}).type_id) as new then
				Result := new
			end
		end
end