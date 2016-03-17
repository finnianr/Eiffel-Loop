note
	description: "Summary description for {EL_STRING_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 14:21:28 GMT (Friday 18th December 2015)"
	revision: "5"

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
	always_empty: Empty_string.is_empty and Empty_string_8.is_empty and Empty_string_8.is_empty
end
