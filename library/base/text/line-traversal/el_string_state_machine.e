note
	description: "State machine for handling strings conforming to ${STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_STRING_STATE_MACHINE [S -> STRING_GENERAL]

inherit
	EL_READABLE_STRING_STATE_MACHINE [S]

feature -- Basic operations

	do_with_split_list (initial: like state; lines: EL_SPLIT_STRING_LIST [S]; keep_ref: BOOLEAN)
		local
			l_final: like final
		do
			item_number := 0; l_final := final
			from lines.start; state := initial until lines.after or state = l_final loop
				item_number := lines.index
				if keep_ref then
					call (lines.item_copy)
				else
					call (lines.item)
				end
				lines.forth
			end
		end

end