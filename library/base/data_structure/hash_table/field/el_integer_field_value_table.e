note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for the [$source INTEGER_32] type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 9:33:51 GMT (Friday 9th December 2022)"
	revision: "7"

class
	EL_INTEGER_FIELD_VALUE_TABLE

inherit
	EL_FIELD_VALUE_TABLE [INTEGER]
		rename
			value_type_id as integer_type
		end

create
	make

feature {NONE} -- Implementation

	set_value (key: STRING; value: INTEGER)
		do
			set_conditional_value (key, value)
		end

end