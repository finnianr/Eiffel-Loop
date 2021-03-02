note
	description: "[
		Implementation of [$source EL_FIELD_VALUE_TABLE] that escapes the value of [$source STRING_32]
		field attribute types.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:52:52 GMT (Tuesday 2nd March 2021)"
	revision: "4"

class
	EL_ESCAPED_STRING_32_FIELD_VALUE_TABLE

inherit
	EL_ESCAPED_STRING_GENERAL_FIELD_VALUE_TABLE [STRING_32]
		redefine
			escaper
		end

create
	make

feature {NONE} -- Implementation

	escaped_value (str: STRING_32): STRING_32
		do
			Result := escaper.escaped (str, True)
		end

feature {NONE} -- Internal attributes

	escaper: EL_STRING_32_ESCAPER

end