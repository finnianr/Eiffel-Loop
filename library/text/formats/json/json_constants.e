note
	description: "JSON constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 10:02:58 GMT (Thursday 5th January 2023)"
	revision: "4"

deferred class
	JSON_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

	EL_SHARED_ESCAPE_TABLE

feature {NONE} -- Constants

	Escaper: EL_STRING_ESCAPER [ZSTRING]
		once
			create Result.make (Escape_table.JSON)
		end

	Unescaper: JSON_UNESCAPER
		once
			create Result.make
		end

	JSON: TUPLE [open_bracket, close_bracket, before_name, after_name, comma_new_line: ZSTRING]
		once
			create Result
			Tuple.fill_adjusted (Result, "{%N,%N},%T%",%": ,%N", False)
			Result.comma_new_line.insert_character (',', 1)
		end

end