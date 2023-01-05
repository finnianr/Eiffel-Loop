note
	description: "[
		Implementation of [$source EL_REFERENCE_FIELD_VALUE_TABLE] that escapes the value of field attribute
		string.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 11:27:48 GMT (Thursday 5th January 2023)"
	revision: "8"

class
	EL_ESCAPED_STRING_FIELD_VALUE_TABLE [S -> STRING_GENERAL create make end]

inherit
	EL_REFERENCE_FIELD_VALUE_TABLE [S]
		rename
			make as make_table
		redefine
			set_conditional_value
		end

create
	make

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
		do
			Result := escaper.escaped (str, True)
		end

feature {NONE} -- Internal attributes

	escaper: EL_STRING_ESCAPER [S]

end