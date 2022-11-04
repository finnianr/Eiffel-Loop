note
	description: "Zstring template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-04 15:35:20 GMT (Friday 4th November 2022)"
	revision: "8"

class
	EL_ZSTRING_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE

create
	make, make_default

convert
	make ({STRING})

feature {NONE} -- Implementation

	append_from_general (target: ZSTRING; a_general: READABLE_STRING_GENERAL)
		do
			target.append_string_general (a_general)
		end

	match_string (start_index, end_index: INTEGER): ZSTRING
		do
			create Result.make_from_substring (source_text, start_index, end_index)
		end

	new_parts (n: INTEGER): EL_ZSTRING_LIST
		do
			create Result.make (n)
		end

	new_string (n: INTEGER): ZSTRING
		do
			create Result.make (n)
		end

	wipe_out (str: ZSTRING)
		do
			str.wipe_out
		end

end