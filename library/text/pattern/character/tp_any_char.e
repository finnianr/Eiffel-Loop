note
	description: "Matches any character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 5:08:27 GMT (Monday 28th November 2022)"
	revision: "4"

class
	TP_ANY_CHAR

inherit
	TP_CHARACTER_PATTERN
		rename
			name_inserts as Empty_inserts
		end

create
	default_create

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		do
			if (text.count - a_offset) > 0 then
				Result := 1
			else
				Result := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := True
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "1 character"
		end
end