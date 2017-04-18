note
	description: "Summary description for {EL_STRING_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-24 10:24:25 GMT (Tuesday 24th January 2017)"
	revision: "2"

class
	EL_STRING_CONSTANTS

feature {NONE} -- Constants

	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

	Empty_string_8: STRING = ""

	Empty_string_32: STRING_32 = ""

	New_line_string: ZSTRING
		once
			Result := "%N"
		end

	Space_string: ZSTRING
		once
			Result := " "
		end

	Tab_string: ZSTRING
		once
			Result := "%T"
		end

invariant
	string_always_empty: Empty_string.is_empty
	string_8_always_empty: Empty_string_8.is_empty
	string_32_always_empty: Empty_string_32.is_empty
end
