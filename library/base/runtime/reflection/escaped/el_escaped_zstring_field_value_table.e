note
	description: "[
		Implementation of [$source EL_FIELD_VALUE_TABLE] that escapes the value of [$source EL_ZSTRING]
		field attribute types.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 13:50:06 GMT (Tuesday 10th April 2018)"
	revision: "3"

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
