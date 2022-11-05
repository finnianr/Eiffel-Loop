note
	description: "Zstring template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:12:08 GMT (Sunday 19th December 2021)"
	revision: "7"

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

	match_string (matched_text: EL_STRING_VIEW): ZSTRING
		do
			Result := matched_text.to_string
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