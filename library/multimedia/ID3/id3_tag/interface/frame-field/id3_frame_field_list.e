note
	description: "Id3 frame field list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-26 9:21:04 GMT (Saturday 26th November 2022)"
	revision: "3"

class
	ID3_FRAME_FIELD_LIST

inherit
	EL_ARRAYED_LIST [ID3_FRAME_FIELD]
		rename
			item_type as item_eiffel_type
		export
			{NONE} all
			{ANY} after, count, extend, item, i_th, put_i_th,
				first, found, forth, start, index,
				push_cursor, pop_cursor
		end

create
	make

feature -- Access

	item_type (type: NATURAL_8): ID3_FRAME_FIELD
		do
			push_cursor
			from start until after or else item.type = type loop
				forth
			end
			if after then
				Result := Default_field
			else
				Result := item
			end
			pop_cursor
		end

feature -- Status query

	has_type (type: NATURAL_8): BOOLEAN
		do
			push_cursor
			from start until after or else Result loop
				Result := type = item.type
				forth
			end
			pop_cursor
		end

feature {NONE} -- Constants

	Default_field: ID3_DEFAULT_FIELD
		once
			create Result
		end

end