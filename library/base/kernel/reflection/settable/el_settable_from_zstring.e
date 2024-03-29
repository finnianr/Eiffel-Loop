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
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "17"

deferred class
	EL_SETTABLE_FROM_ZSTRING

inherit
	EL_SETTABLE_FROM_STRING

feature -- Element change

	set_from_parsed (text: READABLE_STRING_GENERAL)
		-- set from parsed `text'
		do
			set_from_table (create {EL_ZSTRING_TABLE}.make (text))
		end

feature {EL_REFLECTION_HANDLER} -- Implementation

	field_string (a_field: EL_REFLECTED_FIELD): ZSTRING
		local
			str: READABLE_STRING_GENERAL
		do
			str := a_field.to_string (current_reflective)
			if attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} a_field then
				if attached {STRING} str as str_8 then
					create Result.make_from_string (str_8)
				else
					create Result.make_from_general (str)
				end
			elseif attached {ZSTRING} str as z_str then
				Result := z_str
			else
				create Result.make_from_general (str)
			end
		end

	is_ascii_identifier (name: ZSTRING): BOOLEAN
		do
			Result := name.is_ascii
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