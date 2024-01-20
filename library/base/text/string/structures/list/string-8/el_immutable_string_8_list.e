note
	description: "Sortable list of ${IMMUTABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

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
	make, make_empty, make_from_tuple

feature -- Measurement

	item_index_of (uc: CHARACTER_32): INTEGER
		do
			Result := item.character_32_index_of (uc, 1)
		end

end