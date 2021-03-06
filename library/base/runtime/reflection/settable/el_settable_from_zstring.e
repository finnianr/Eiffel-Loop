note
	description: "[
		Used in conjunction with [$source EL_REFLECTIVE] to reflectively set fields
		from name-value pairs, where value conforms to [$source EL_ZSTRING] (aka `ZSTRING')
	]"
	tests: "Class [$source REFLECTIVE_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-18 11:14:02 GMT (Tuesday 18th May 2021)"
	revision: "12"

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