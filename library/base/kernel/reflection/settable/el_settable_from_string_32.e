note
	description: "[
		Used in conjunction with [$source EL_REFLECTIVE] to reflectively set fields
		from name-value pairs, where value conforms to [$source STRING_32].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-05 12:55:25 GMT (Friday 5th May 2023)"
	revision: "9"

deferred class
	EL_SETTABLE_FROM_STRING_32

inherit
	EL_SETTABLE_FROM_STRING

feature {EL_REFLECTION_HANDLER} -- Implementation

	field_string (a_field: EL_REFLECTED_FIELD): STRING_32
		do
			Result := a_field.to_string (current_reflective).to_string_32
		end

	is_code_identifier (name: STRING_32): BOOLEAN
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := s.is_eiffel (name)
		end

	new_string: STRING_32
		do
			create Result.make_empty
		end

feature {NONE} -- Constants

	Name_value_pair: EL_NAME_VALUE_PAIR [STRING_32]
		once
			create Result.make_empty
		end

end