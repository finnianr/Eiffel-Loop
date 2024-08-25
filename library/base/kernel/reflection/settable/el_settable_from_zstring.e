note
	description: "[
		Used in conjunction with ${EL_REFLECTIVE} to reflectively set fields
		from name-value pairs, where value conforms to ${EL_ZSTRING} (aka ''ZSTRING'')
	]"
	tests: "Class ${REFLECTION_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 18:31:12 GMT (Sunday 25th August 2024)"
	revision: "18"

deferred class
	EL_SETTABLE_FROM_ZSTRING

inherit
	EL_SETTABLE_FROM_STRING
		rename
			cursor as cursor_z
		end

	EL_SHARED_ZSTRING_CURSOR

feature {EL_REFLECTION_HANDLER} -- Implementation

	field_string (a_field: EL_REFLECTED_FIELD): ZSTRING
		local
			str: READABLE_STRING_GENERAL
		do
			str := a_field.to_string (current_reflective)
			inspect string_storage_type (str)
				when '1' then
					if attached {READABLE_STRING_8} str as str_8 then
						if a_field.is_expanded then
						-- fastest for ASCII encodings
							create Result.make_from_string_8 (str_8)
						else
							create Result.make_from_general (str_8)
						end
					end
				when 'X' then
					if attached {ZSTRING} str as z_str then
						Result := z_str
					end
			else
				create Result.make_from_general (str)
			end
		end

	new_string: ZSTRING
		do
			create Result.make_empty
		end

feature {NONE} -- Constants

	Name_value_pair: EL_NAME_VALUE_PAIR [ZSTRING]
		once
			create Result.make_empty
		end

end