note
	description: "Iteration_cursor for ${EL_COMPACT_ZSTRING_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_COMPACT_ZSTRING_ITERATION_CURSOR

inherit
	EL_SPLIT_READABLE_STRING_ITERATION_CURSOR [ZSTRING]
		redefine
			item, make
		end

create
	make

feature {NONE} -- Initialization

	make (t: EL_COMPACT_ZSTRING_LIST)
		do
			Precursor (t)
			utf_8_list := t.utf_8_list
		end

feature -- Access

	item: ZSTRING
		do
			create Result.make_from_utf_8 (utf_8_list [index])
		end

	item_utf_8: IMMUTABLE_STRING_8
		do
			Result := utf_8_list [index]
		end

feature {NONE} -- Internal attributes

	utf_8_list: EL_SORTABLE_STRING_LIST [IMMUTABLE_STRING_8]
end