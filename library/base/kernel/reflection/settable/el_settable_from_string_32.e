note
	description: "[
		Used in conjunction with ${EL_REFLECTIVE} to reflectively set fields
		from name-value pairs, where value conforms to ${STRING_32}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 16:36:18 GMT (Saturday 5th April 2025)"
	revision: "13"

deferred class
	EL_SETTABLE_FROM_STRING_32

inherit
	EL_SETTABLE_FROM_STRING
		rename
			extended_string as super_32
		end

feature {EL_REFLECTION_HANDLER} -- Implementation

	field_string (a_field: EL_REFLECTED_FIELD): STRING_32
		do
			Result := a_field.to_string (current_reflective).to_string_32
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