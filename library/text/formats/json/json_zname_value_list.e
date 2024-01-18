note
	description: "Iterable ${JSON_NAME_VALUE_LIST} with name items of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-19 13:07:09 GMT (Sunday 19th March 2023)"
	revision: "6"

class
	JSON_ZNAME_VALUE_LIST

inherit
	JSON_NAME_VALUE_LIST
		rename
			item_name as item_name_utf_8,
			new_cursor as new_intervals_cursor
		end

	ITERABLE [TUPLE [name, value: ZSTRING]]
		undefine
			copy, is_equal, out
		select
			new_cursor
		end

create
	make, make_grouped, make_parsed

feature -- Access

	item_name (keep_ref: BOOLEAN): ZSTRING
		require
			valid_item: not off
		do
			Result := Name_buffer.empty
			Result.append_utf_8 (item_name_utf_8 (False))
			Result.unescape (Unescaper)
			if keep_ref then
				Result := Result.twin
			end
		end

	new_cursor: JSON_ZNAME_VALUE_LIST_ITERATION_CURSOR
		do
			create Result.make (Current)
		end

feature {NONE} -- Constants

	Name_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end