note
	description: "[
		Implementation of [$source EL_FIELD_VALUE_TABLE] that escapes the value of field attribute
		string.
	]"
	descendants: "[
			EL_ESCAPED_STRING_GENERAL_FIELD_VALUE_TABLE*
				[$source EL_ESCAPED_ZSTRING_FIELD_VALUE_TABLE]
				[$source EL_ESCAPED_STRING_8_FIELD_VALUE_TABLE]
				[$source EL_ESCAPED_STRING_32_FIELD_VALUE_TABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-22 12:54:38 GMT (Sunday 22nd April 2018)"
	revision: "4"

deferred class
	EL_ESCAPED_STRING_GENERAL_FIELD_VALUE_TABLE [S -> STRING_GENERAL create make end]

inherit
	EL_REFERENCE_FIELD_VALUE_TABLE [S]
		rename
			make as make_table
		redefine
			set_conditional_value
		end

feature {NONE} -- Initialization

	make (n: INTEGER; a_escaper: like escaper)
		do
			make_table (n)
			escaper := a_escaper
		end

feature {NONE} -- Implementation

	set_conditional_value (key: STRING; new: S)
		do
			if condition /= default_condition implies condition (new) then
				extend (escaped_value (new), key)
			end
		end

	escaped_value (str: S): S
		deferred
		end

feature {NONE} -- Internal attributes

	escaper: EL_STRING_GENERAL_ESCAPER

end
