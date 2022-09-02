note
	description: "[
		Factory to convert [$source FINITE [H]] container to [$source EL_ARRAYED_LIST [G]] given 
		a conversion function [$source FUNCTION [H, G]].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-02 8:08:27 GMT (Friday 2nd September 2022)"
	revision: "2"

class
	EL_LIST_FACTORY [G, H]

feature -- Factory

	new_arrayed_list (input: FINITE [H]; converted: FUNCTION [H, G]): EL_ARRAYED_LIST [G]
		do
			create Result.make (input.count)
			if attached {ITERABLE [H]} input as iterable_input then
				across iterable_input as list loop
					Result.extend (converted (list.item))
				end
			elseif attached {LINEAR [H]} input.linear_representation as list then
				from list.start until list.after loop
					Result.extend (converted (list.item))
					list.forth
				end
			end
		end
end