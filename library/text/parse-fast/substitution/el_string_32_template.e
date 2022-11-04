note
	description: "String 32 template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-04 15:36:58 GMT (Friday 4th November 2022)"
	revision: "8"

class
	EL_STRING_32_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE

create
	make, make_default

convert
	make ({STRING})

feature {NONE} -- Implementation

	append_from_general (target: STRING_32; a_general: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} a_general as z_str then
				z_str.append_to_string_32 (target)
			else
				target.append (a_general.to_string_32)
			end
		end

	match_string (start_index, end_index: INTEGER): STRING_32
		do
			create Result.make (end_index - start_index + 1)
			Result.append_substring_general (source_text, start_index, end_index)
		end

	new_parts (n: INTEGER): EL_STRING_32_LIST
		do
			create Result.make (n)
		end

	new_string (n: INTEGER): STRING_32
		do
			create Result.make (n)
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end

end