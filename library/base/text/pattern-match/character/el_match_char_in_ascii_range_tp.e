note
	description: "Summary description for {EL_MATCH_CHAR_IN_ASCII_RANGE_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:27:26 GMT (Sunday 20th December 2015)"
	revision: "5"

class
	EL_MATCH_CHAR_IN_ASCII_RANGE_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN

create
	make

feature {NONE} -- Initialization

	make (a_lower_code, a_upper_code: NATURAL)
			--
		do
			make_default
			lower_code := a_lower_code; upper_code := a_upper_code
		end

	name: STRING
		do
			create Result.make (3)
			Result.append_character ('%'')
			Result.append_code (lower_code)
			Result.append ("'..'")
			Result.append_code (upper_code)
			Result.append_character ('%'')
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		local
			code: NATURAL
		do
			if text.count > 0 then
				code := text.code (1)
				if lower_code <= code and then code <= upper_code then
					Result := 1
				else
					Result := Match_fail
				end
			else
				Result := Match_fail
			end
		end

	lower_code: NATURAL

	upper_code: NATURAL

end
