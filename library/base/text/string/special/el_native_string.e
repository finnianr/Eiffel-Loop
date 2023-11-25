note
	description: "[$source NATIVE_STRING] with support for [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-25 13:21:51 GMT (Saturday 25th November 2023)"
	revision: "1"

class
	EL_NATIVE_STRING

inherit
	NATIVE_STRING
		redefine
			set_substring
		end

	EL_SHARED_CLASS_ID; EL_SHARED_STRING_32_BUFFER_SCOPES

create
	make, make_empty, make_from_pointer, make_from_raw_string

feature -- Element change

	set_substring (a_string: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			inspect Class_id.character_bytes (a_string)
				when 'X' then
					across String_32_scope as scope loop
						count := end_index - start_index + 1
						Precursor (scope.substring_item (a_string, start_index, end_index), 1, count)
					end
			else
				Precursor (a_string, start_index, end_index)
			end
		end
end