note
	description: "Iterable [$source JSON_NAME_VALUE_LIST] with name items of type [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 8:28:44 GMT (Wednesday 22nd June 2022)"
	revision: "2"

class
	JSON_ZNAME_VALUE_LIST

inherit
	JSON_NAME_VALUE_LIST
		rename
			name_item as name_item_8,
			new_cursor as new_intervals_cursor
		end

	ITERABLE [TUPLE [name, value: ZSTRING]]
		undefine
			copy, is_equal, out
		select
			new_cursor
		end

create
	make

feature -- Access

	name_item (keep_ref: BOOLEAN): ZSTRING
		require
			valid_item: not off
		do
			Result := Name_buffer.empty
			Result.append_utf_8 (name_item_8 (False))
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

