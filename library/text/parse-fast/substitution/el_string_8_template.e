note
	description: "String 8 template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-04 15:36:41 GMT (Friday 4th November 2022)"
	revision: "9"

class
	EL_STRING_8_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE

create
	make, make_default

convert
	make ({STRING})

feature {NONE} -- Implementation

	append_from_general (target: STRING_8; a_general: READABLE_STRING_GENERAL)
		do
			if attached {EL_READABLE_ZSTRING} a_general as z_str then
				z_str.append_to_string_8 (target)

			elseif a_general.is_valid_as_string_8 then
				target.append (a_general.to_string_8)
			end
		end

	match_string (start_index, end_index: INTEGER): STRING_8
		do
			create Result.make (end_index - start_index + 1)
			Result.append_substring_general (source_text, start_index, end_index)
		end

	new_parts (n: INTEGER): EL_STRING_8_LIST
		do
			create Result.make (n)
		end

	new_string (n: INTEGER): STRING_8
		do
			create Result.make (n)
		end

	wipe_out (str: STRING_8)
		do
			str.wipe_out
		end

end