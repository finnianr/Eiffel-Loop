note
	description: "[$source EL_ARRAYED_LIST [G]] convertable from an input of type [$source FINITE [H]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-27 19:44:54 GMT (Saturday 27th August 2022)"
	revision: "1"

class
	EL_CONVERTED_LIST [G, H]

inherit
	EL_ARRAYED_LIST [G]
		rename
			make as make_with_size
		end

create
	make

feature {NONE} -- Initialization

	make (input: FINITE [H]; converted: FUNCTION [H, G])
		do
			make_with_size (input.count)
			if attached {ITERABLE [H]} input as iterable_input then
				across iterable_input as list loop
					extend (converted (list.item))
				end
			elseif attached {LINEAR [H]} input.linear_representation as list then
				from list.start until list.after loop
					extend (converted (list.item))
					list.forth
				end
			end
		end
end