note
	description: "Object with attribute names that are translateable TO and FROM another naming convention"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 10:28:57 GMT (Wednesday 6th December 2017)"
	revision: "2"

class
	EL_ATTRIBUTE_NAME_TRANSLATEABLE

inherit
	EL_MODULE_STRING_8

feature {NONE} -- Import names

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
			name_out.to_lower
			String_8.replace_character (name_out, '-', '_')
		end

	from_lower_snake_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
		end

	from_upper_snake_case (name_in, name_out: STRING)
		-- Eg. "FROM_UPPER_SNAKE_CASE"
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			name_out.to_lower
		end

feature {NONE} -- Export names

	to_camel_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		local
			i, count: INTEGER; area: SPECIAL [CHARACTER]; c: CHARACTER
		do
			if name_in.has ('_') then
				count := name_in.count; area := name_in.area
				from i := 0 until i = count loop
					c := area [i]
					if c = '_' then
						i := i + 1
						if i < count then
							name_out.append_character (area.item (i).as_upper)
						end
					else
						name_out.append_character (c)
					end
					i := i + 1
				end
			else
				name_out.append (name_in)
			end
		end

	to_english (name_in, english_out: STRING)
		require
			empty_name_out: english_out.is_empty
		local
			words: EL_SPLIT_STRING_LIST [STRING]
		do
			create words.make (name_in, once "_")
			words.do_all (agent append_english_word (?, english_out))
			english_out [1] := english_out.item (1).as_upper
		end

	to_kebab_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			String_8.replace_character (name_out, '_', '-')
		end

	to_upper_snake_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			name_out.to_upper
		end

feature {NONE} -- Implementation

	append_english_word (word: STRING; str: STRING)
		do
			if not str.is_empty then
				if str.ends_with (once "non") then
					str.append_character ('-')
				else
					str.append_character (' ')
				end
			end
			if upper_case_english_words.has (word) then
				word.to_upper
			end
			str.append (word)
		end

	import_name: like Default_import_name
		-- returns a procedure to import names using a foreing naming convention to the Eiffel convention.
		--  `Standard_eiffel' means the external name already follows the Eiffel convention
		do
			Result := Default_import_name
		end

	export_name: like Default_import_name
		-- returns a procedure to export names to a foreign naming convention.
		--  `Standard_eiffel' means that external names already follow the Eiffel convention
		do
			Result := Default_import_name
		end

feature {NONE} -- Constants

	Default_import_name: PROCEDURE [STRING, STRING]
		once
			Result := agent from_lower_snake_case
		end

	State_lower: INTEGER = 2

	State_numeric: INTEGER = 3

	State_upper: INTEGER = 1

	upper_case_english_words: ARRAY [STRING]
		-- words to be upper cased in `code_name'
		-- (must be listed in lowercase)
		once
			create Result.make_empty
			Result.compare_objects
		ensure
			object_comparison: Result.object_comparison
		end

end
