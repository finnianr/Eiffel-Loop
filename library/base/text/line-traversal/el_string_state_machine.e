note
	description: "State machine for handling strings conforming to [$source STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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