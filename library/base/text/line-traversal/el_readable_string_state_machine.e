note
	description: "State machine for processing strings conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_READABLE_STRING_STATE_MACHINE [S -> READABLE_STRING_GENERAL]

inherit
	EL_STATE_MACHINE [S]

feature -- Basic operations

	do_with_split (initial: like state; splitter: EL_ITERABLE_SPLIT [S, ANY]; keep_ref: BOOLEAN)
		local
			l_final: like final
		do
			item_number := 0; l_final := final; state := initial
			across splitter as split until state = l_final loop
				item_number := split.cursor_index
				if keep_ref then
					call (split.item_copy)
				else
					call (split.item)
				end
			end
		end

end