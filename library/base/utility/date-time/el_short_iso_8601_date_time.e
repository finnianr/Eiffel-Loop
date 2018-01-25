note
	description: "[
		Date-time object makeable from short-form ISO-8601 formatted string
	]"
	notes: "[
		Due to [https://groups.google.com/forum/#!topic/eiffel-users/XdLwHGX_X7c formatting problems]
		with `DATE_TIME' we cannot have a space in the `Default_format_string' like in the parent class.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 12:27:53 GMT (Saturday 16th December 2017)"
	revision: "1"

class
	EL_SHORT_ISO_8601_DATE_TIME

inherit
	EL_ISO_8601_DATE_TIME
		redefine
			append_space, Default_format_string, Input_string_count, place_time_delimiter, T_index
		end

create
	make, make_now

feature {NONE} -- Implementation

	append_space (modified: STRING)
		do
		end

	place_time_delimiter (string: STRING)
		do
			string.insert_character ('T', T_index)
		end

feature {EL_DATE_TEXT} -- Constant

	Default_format_string: STRING
			-- Default output format string
		once
			Result := "yyyy[0]mm[0]dd[0]hh[0]mi[0]ss"
		end

	T_index: INTEGER
		once
			Result := 9
		end

	Input_string_count: INTEGER
		once
			Result := 16
		end
end
