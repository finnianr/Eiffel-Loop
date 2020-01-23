note
	description: "String 32 template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:03:33 GMT (Thursday 23rd January 2020)"
	revision: "6"

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

	match_string (matched_text: EL_STRING_VIEW): STRING_32
		do
			Result := matched_text.to_string_32
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
