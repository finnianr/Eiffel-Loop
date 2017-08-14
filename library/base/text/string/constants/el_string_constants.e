note
	description: "Common string constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-24 10:24:25 GMT (Tuesday 24th January 2017)"
	revision: "2"

class
	EL_STRING_CONSTANTS

feature {NONE} -- ZSTRING

	Ellipsis_string: ZSTRING
		once
			Result := Empty_string_8
		end

	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

	New_line_string: ZSTRING
		once
			Result := New_line_string_8
		end

	Space_string: ZSTRING
		once
			Result := Space_string_8
		end

	Tab_string: ZSTRING
		once
			Result := Tab_string_8
		end

feature {NONE} -- STRING_8

	Empty_string_8: STRING = ""

	Ellipsis_string_8: STRING = ".."

	New_line_string_8: STRING = "%N"

	Space_string_8: STRING = " "

	Tab_string_8: STRING = "%T"

feature {NONE} -- STRING_32

	Empty_string_32: STRING_32
		once
			Result := Empty_string_8
		end

	Space_string_32: STRING_32
		once
			Result := Space_string_8
		end

	Tab_string_32: STRING_32
		once
			Result := Tab_string_8
		end

invariant
	string_always_empty: Empty_string.is_empty
	string_8_always_empty: Empty_string_8.is_empty
	string_32_always_empty: Empty_string_32.is_empty
	ellipsis_size_is_two: Ellipsis_string_8.count = 2
end
