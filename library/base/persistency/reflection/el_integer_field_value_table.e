note
	description: "Summary description for {EL_INTEGER_FIELD_VALUE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-24 13:29:07 GMT (Tuesday 24th January 2017)"
	revision: "1"

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

	set_value (key: STRING; object: REFLECTED_REFERENCE_OBJECT; field_index: INTEGER)
		do
			set_conditional_value (key, object.integer_32_field (field_index))
		end

end
