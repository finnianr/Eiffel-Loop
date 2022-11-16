note
	description: "JSON constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	JSON_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Escaper: JSON_VALUE_ESCAPER
		once
			create Result.make
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