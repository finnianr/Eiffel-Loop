note
	description: "Convenience routines for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 15:25:28 GMT (Monday 3rd May 2021)"
	revision: "19"

expanded class
	EL_ZSTRING_ROUTINES

feature -- Character string

	character_string (uc: CHARACTER_32): ZSTRING
		-- shared instance of string with `uc' character
		do
			Result := n_character_string (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): ZSTRING
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_table.item (n.to_natural_64 |<< 32 | uc.natural_32_code)
		ensure
			valid_result: Result.occurrences (uc) = n.to_integer_32
		end

feature -- Conversion

	as_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} general as str then
				Result := str
			else
				create Result.make_from_general (general)
			end
		end

	joined (separator: CHARACTER_32; a_list: ITERABLE [READABLE_STRING_GENERAL]): ZSTRING
		local
			count: INTEGER
		do
			across a_list as list loop
				if count > 0 then
					count := count + 1
				end
				count := count + list.item.count
				list.forth
			end
			create Result.make (count)
			across a_list as list loop
				if Result.count > 0 then
					Result.append_character (separator)
				end
				if attached {ZSTRING} list.item as zstr then
					Result.append (zstr)
				else
					Result.append_string_general (list.item)
				end
			end
		end

	last_word (str: ZSTRING): ZSTRING
		-- last alpha-numeric word in `str'
		local
			i: INTEGER
		do
			create Result.make (20)
			from i := str.count until i < 1 or else str.is_alpha_numeric_item (i) loop
				i := i - 1
			end
			from until i < 1 or else not str.is_alpha_numeric_item (i) loop
				Result.append_character (str.item (i))
				i := i - 1
			end
			Result.mirror
		end

	new_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if attached {ZSTRING} general as zstr then
				Result := zstr.to_unicode
			else
				Result := general
			end
		end

feature -- Status query

	has_alpha_numeric (str: ZSTRING): BOOLEAN
		-- `True' if `str' has an alpha numeric character
		local
			i: INTEGER
		do
			from i := 1 until Result or i > str.count loop
				Result := str.is_alpha_numeric_item (i)
				i := i + 1
			end
		end

	is_variable_name (str: ZSTRING): BOOLEAN
		local
			i: INTEGER
		do
			Result := str.count > 1
			from i := 1 until not Result or i > str.count loop
				inspect i
					when 1 then
						Result := str [i] = '$'
					when 2 then
						Result := str.is_alpha_item (i)
				else
					Result := str.is_alpha_numeric_item (i) or else str [i] = '_'
				end
				i := i + 1
			end
		end

	starts_with (a, b: ZSTRING): BOOLEAN
		do
			Result := a.starts_with (b)
		end

	starts_with_drive (str: ZSTRING): BOOLEAN
		do
			inspect str.count
				when 0, 1 then
			else
				Result := str [2] = ':' and then str.is_alpha_item (1)
			end
		end

feature {NONE} -- Implemenation

	new_filled_string (key: NATURAL_64): ZSTRING
		do
			create Result.make_filled (key.to_character_32, (key |>> 32).to_integer_32)
		end

feature {NONE} -- Constants

	Character_string_table: EL_CACHE_TABLE [ZSTRING, NATURAL_64]
		once
			create Result.make_equal (7, agent new_filled_string)
		end

end