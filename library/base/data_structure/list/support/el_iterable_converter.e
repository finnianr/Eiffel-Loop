note
	description: "Convert an iterable list to an arrayed list with `to_item' function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-13 10:33:55 GMT (Tuesday 13th November 2018)"
	revision: "1"

class
	EL_ITERABLE_CONVERTER [F, G]

feature -- Factory

	new_list (list: ITERABLE [F]; to_item: FUNCTION [F, G]): EL_ARRAYED_LIST [G]
		-- Convert an iterable list to an arrayed list with `to_item' function
		require
			valid_open_argument: (attached {CHAIN [F]} list as chain and then not chain.is_empty)
				implies to_item.valid_operands ([chain.first])
		local
			operands: TUPLE [F]; operands_set: BOOLEAN
		do
			if attached {FINITE [F]} list as finite then
				create Result.make (finite.count)
			else
				create Result.make_empty
			end
			across list as any loop
				if operands_set then
					operands.put (any.item, 1)
				else
					operands := [any.item]
					to_item.set_operands (operands)
					operands_set := True
				end
				to_item.apply
				Result.extend (to_item.last_result)
			end
		end
end
