note
	description: "[
		${EL_STRING_X_ROUTINES} implemented for ${EL_READABLE_ZSTRING}
		plus a few extra convenience routines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 7:29:45 GMT (Sunday 27th April 2025)"
	revision: "58"

class EL_ZSTRING_ROUTINES_IMP inherit ANY

	EL_STRING_X_ROUTINES [ZSTRING, EL_READABLE_ZSTRING, CHARACTER_32]
		rename
			to_code as to_z_code
		undefine
			bit_count
		redefine
			to_z_code
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

	EL_SHARED_ZSTRING_CODEC

feature -- Factory

	new_list (comma_separated: ZSTRING): EL_ZSTRING_LIST
		do
			create Result.make_comma_split (comma_separated)
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

feature {NONE} -- Implementation

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: EL_READABLE_ZSTRING; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string (target, pattern, 0)
		end

	to_z_code (character: CHARACTER_32): NATURAL_32
		do
			Result := Codec.as_z_code (character)
		end

end