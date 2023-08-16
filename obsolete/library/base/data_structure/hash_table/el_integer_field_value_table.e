note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for the [$source INTEGER_32] type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 16:13:50 GMT (Sunday 16th July 2023)"
	revision: "8"

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

	set_value (key: READABLE_STRING_8; value: INTEGER)
		do
			set_conditional_value (key, value)
		end

end