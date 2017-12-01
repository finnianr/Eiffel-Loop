note
	description: "Attribute name conversion routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 10:44:02 GMT (Monday 27th November 2017)"
	revision: "1"

class
	EL_ATTRIBUTE_NAME_ROUTINES

inherit
	EL_MODULE_STRING_8

feature {NONE} -- Implementation

	from_camel_case (name_in, name_out: STRING)
		-- Eg. "fromCamelCase"
		require
			empty_name_out: name_out.is_empty
		local
			i, count, state: INTEGER; area: SPECIAL [CHARACTER]; c: CHARACTER
		do
			count := name_in.count; area := name_in.area

			if count > 0 then
				c := area.item (0)
				if c.is_digit then
					state := State_numeric
				elseif c.is_upper then
					state := State_upper
				else
					state := State_lower
				end
			end
			from i := 0 until i = count loop
				c := area.item (i)
				if state = State_numeric and not c.is_digit then
					if c.is_lower then
						state := State_lower
					else
						state := State_upper
					end
					name_out.append_character ('_')

				elseif state = State_lower and then c.is_upper or c.is_digit then
					state := State_upper; name_out.append_character ('_')

				elseif state = State_upper and then c.is_lower or c.is_digit then
					state := State_lower
				end
				name_out.append_character (c.as_lower)
				i := i + 1
			end
		end

	from_kebab_case (name_in, name_out: STRING)
		-- Eg. "from-kebab-case"
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			String_8.replace_character (name_out, '-', '_')
		end

	from_upper_snake_case (name_in, name_out: STRING)
		-- Eg. "FROM_UPPER_SNAKE_CASE"
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			name_out.to_lower
		end

	from_lower_snake_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
		end

	to_kebab_case (name: STRING): STRING
		do
			Result := name.twin
			String_8.replace_character (Result, '_', '-')
		end

feature {NONE} -- Constants

	Standard_eiffel: PROCEDURE [STRING, STRING]
		once
			Result := agent from_lower_snake_case
		end

	State_lower: INTEGER = 2

	State_numeric: INTEGER = 3

	State_upper: INTEGER = 1

end
