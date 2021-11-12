note
	description: "Convert an iterable list to an arrayed list with `to_item' function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-26 12:28:16 GMT (Sunday 26th January 2020)"
	revision: "3"

class
	EL_ITERABLE_CONVERTER [F, G]

obsolete
	"Use EL_ARRAYED_RESULT_LIST"

inherit
	ANY

	EL_MODULE_ITERABLE

	EL_MODULE_EIFFEL

feature -- Contract Support

	proto_item: F
		-- uninitialized item for contract support
		do
			if attached {F} Eiffel.new_instance_of (({F}).type_id) as new then
				Result := new
			end
		end

feature -- Factory

	new_linear_list (list: LINEAR [F]; to_item: FUNCTION [F, G]): EL_ARRAYED_LIST [G]
		-- Convert `container.linear_representation' to an arrayed list with `to_item' function
		require
			valid_open_argument: to_item.valid_operands ([proto_item])
		local
			count: INTEGER
		do
			if attached {FINITE [ANY]} list as finite then
				count := finite.count
			else
				from list.start until list.after loop
					count := count + 1
					list.forth
				end
			end
			create Result.make (count)
			from list.start until list.after loop
				Result.extend (to_item (list.item))
				list.forth
			end
		end

	new_list (list: ITERABLE [F]; to_item: FUNCTION [F, G]): EL_ARRAYED_LIST [G]
		-- Convert iterable `list' to an arrayed list with `to_item' function
		require
			valid_open_argument: to_item.valid_operands ([proto_item])
		do
			create Result.make (Iterable.count (list))
			across list as any loop
				Result.extend (to_item (any.item))
			end
		end

end
