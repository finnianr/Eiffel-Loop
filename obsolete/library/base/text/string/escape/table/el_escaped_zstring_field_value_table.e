note
	description: "[
		Implementation of [$source EL_FIELD_VALUE_TABLE] that escapes the value of [$source EL_ZSTRING]
		field attribute types.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_ESCAPED_ZSTRING_FIELD_VALUE_TABLE

inherit
	EL_ESCAPED_STRING_GENERAL_FIELD_VALUE_TABLE [ZSTRING]
		redefine
			escaper
		end

create
	make

feature {NONE} -- Implementation

	escaped_value (str: ZSTRING): ZSTRING
		do
			Result := escaper.escaped (str, True)
		end

feature {NONE} -- Internal attributes

	escaper: EL_ZSTRING_ESCAPER

end