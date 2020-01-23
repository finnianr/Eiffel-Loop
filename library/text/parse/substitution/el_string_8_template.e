note
	description: "String 8 template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:03:47 GMT (Thursday 23rd January 2020)"
	revision: "6"

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

			elseif a_general.is_string_8 then
				target.append (a_general.to_string_8)
			end
		end

	match_string (matched_text: EL_STRING_VIEW): STRING_8
		do
			Result := matched_text.to_string_8
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
