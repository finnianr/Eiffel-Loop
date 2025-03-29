note
	description: "Sortable list of ${IMMUTABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 14:46:32 GMT (Saturday 29th March 2025)"
	revision: "5"

class
	EL_IMMUTABLE_STRING_8_LIST

inherit
	EL_SORTABLE_ARRAYED_LIST [IMMUTABLE_STRING_8]

	EL_SORTABLE_STRING_LIST [IMMUTABLE_STRING_8]
		rename
			item as i_th alias "[]",
			upper as count
		undefine
			copy, is_equal, new_cursor
		end

create
	make, make_empty, make_filled, make_from_for, make_from, make_from_if, make_from_tuple

feature -- Measurement

	item_index_of (uc: CHARACTER_32): INTEGER
		do
			Result := item.character_32_index_of (uc, 1)
		end

end