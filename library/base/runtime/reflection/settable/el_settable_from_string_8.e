note
	description: "[
		Used in conjunction with [$source EL_REFLECTIVE] to reflectively set fields
		from name-value pairs, where value conforms to `STRING_8'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-19 10:30:56 GMT (Thursday 19th April 2018)"
	revision: "5"

deferred class
	EL_SETTABLE_FROM_STRING_8

inherit
	EL_SETTABLE_FROM_STRING
		rename
			string_type_id as String_8_type
		end

feature {EL_REFLECTION_HANDLER} -- Implementation

	field_string (a_field: EL_REFLECTED_FIELD): STRING_8
		do
			Result := a_field.to_string (current_reflective).to_string_8
		end

	new_string: STRING_8
		do
			create Result.make_empty
		end

feature {NONE} -- Constants

	Name_value_pair: EL_NAME_VALUE_PAIR [STRING_8]
		once
			create Result.make_empty
		end

end
