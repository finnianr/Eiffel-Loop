note
	description: "[
		${EL_STRING_X_ROUTINES} implemented for ${EL_READABLE_ZSTRING}
		plus a few extra convenience routines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 15:53:16 GMT (Tuesday 15th April 2025)"
	revision: "51"

class
	EL_ZSTRING_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [ZSTRING, EL_READABLE_ZSTRING, CHARACTER_32]
		rename
			to_code as to_z_code,
			ZString_searcher as String_searcher
		undefine
			bit_count
		redefine
			to_z_code
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

	EL_SHARED_ESCAPE_TABLE; EL_SHARED_IMMUTABLE_32_MANAGER

	EL_SHARED_ZSTRING_CODEC

feature -- Factory

	new_list (comma_separated: ZSTRING): EL_ZSTRING_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

feature -- Comparison

	occurs_at (big, small: ZSTRING; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: ZSTRING; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

	same_string (a, b: EL_READABLE_ZSTRING): BOOLEAN
		do
			Result := a.same_string (b)
		end

feature -- Conversion

	new_paragraph_list (text: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		-- `text' lines joined together as paragraphs with
		-- an empty line interpreted as a paragraph delimiter
		local
			lines, sub_list: EL_ZSTRING_LIST
		do
			create lines.make_with_lines (text)

			create Result.make (lines.count_of (agent {ZSTRING}.is_empty) + 1)
			create sub_list.make (lines.count // Result.capacity + 1)
			across lines as l loop
				if not l.item.is_empty then
					sub_list.extend (l.item)
				end
				if l.item.is_empty or l.is_last then
					Result.extend (sub_list.joined (' '))
					sub_list.wipe_out
				end
			end
		end

feature -- Basic operations

	append_to (str: ZSTRING; extra: READABLE_STRING_GENERAL)
		do
			str.append_string_general (extra)
		end

	set_upper (str: ZSTRING; i: INTEGER)
		do
			str.put (str [i].upper, i)
		end

	unescape_substitution_marks (target: ZSTRING)
		-- replace "%S" substrings with '%S'
		do
			if target.has ('%%') then
				target.unescape (Substitution_mark_unescaper)
			end
		end

feature {NONE} -- Implementation

	append_utf_8_to (utf_8: READABLE_STRING_8; output: ZSTRING)
		do
			output.append_utf_8 (utf_8)
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: EL_READABLE_ZSTRING; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string (target, pattern, 0)
		end

	split_on_character (str: EL_READABLE_ZSTRING; separator: CHARACTER_32): EL_SPLIT_ON_CHARACTER [EL_READABLE_ZSTRING]
		do
			Result := Split_string
			Result.set_target (str); Result.set_separator (separator)
		end

	to_z_code (character: CHARACTER_32): NATURAL_32
		do
			Result := Codec.as_z_code (character)
		end

feature {NONE} -- Constants

	Split_string: EL_SPLIT_ZSTRING_ON_CHARACTER
		once
			create Result.make (Empty_string, '_')
		end

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (Escape_table.Substitution)
		end

end