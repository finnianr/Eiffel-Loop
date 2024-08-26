note
	description: "${STRING_32} routines for benchmarking"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 12:47:49 GMT (Monday 26th August 2024)"
	revision: "4"

class
	STRING_32_ROUTINES

inherit
	STRING_ROUTINES [STRING_32]

feature -- Concatenation

	append (target, str: STRING_32)
		do
			target.append (str)
		end

	append_general (target: STRING_32; str: READABLE_STRING_GENERAL)
		do
			target.append_string_general (str)
		end

	append_utf_8 (target: STRING_32; utf_8_string: STRING)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			utf_8.string_8_into_string_general (utf_8_string, target)
		end

	prepend (target, str: STRING_32)
		do
			target.prepend (str)
		end

	prepend_general (target: STRING_32; str: READABLE_STRING_GENERAL)
		do
			target.prepend_string_general (str)
		end

feature -- Status query

	ends_with (target, str: STRING_32): BOOLEAN
		do
			Result := target.ends_with (str)
		end

	ends_with_general (target: STRING_32; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := target.ends_with_general (str)
		end

	starts_with (target, str: STRING_32): BOOLEAN
		do
			Result := target.starts_with (str)
		end

	starts_with_general (target: STRING_32; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := target.starts_with_general (str)
		end

feature -- Conversion

	xml_escaped (target: STRING_32): STRING_32
		do
			Result := xml_escaper.escaped (target, True)
		end

	to_latin_1 (string: STRING_32): STRING
		do
			Result := string.to_string_8
		end

	to_utf_8 (string: STRING_32): STRING
		local
			c: EL_UTF_CONVERTER
		do
			Result := c.string_32_to_utf_8_string_8 (string)
		end

feature -- Basic operations

	insert_character (target: STRING_32; uc: CHARACTER_32; i: INTEGER)
		do
			target.insert_character (uc, i)
		end

	insert_string (target, insertion: STRING_32; index: INTEGER)
		do
			target.insert_string (insertion, index)
		end

	prune_all (target: STRING_32; uc: CHARACTER_32)
		do
			target.prune_all (uc)
		end

	remove_substring (target: STRING_32; start_index, end_index: INTEGER)
		do
			target.remove_substring (start_index, end_index)
		end

	replace_character (target: STRING_32; uc_old, uc_new: CHARACTER_32)
		local
			s: EL_STRING_32_ROUTINES
		do
			s.replace_character (target, uc_old, uc_new)
		end

	replace_substring (target, insertion: STRING_32; start_index, end_index: INTEGER)
		do
			target.replace_substring (insertion, start_index, end_index)
		end

	replace_substring_all (target, original, new: STRING_32)
		do
			target.replace_substring_all (original, new)
		end

	to_lower (string: STRING_32)
		do
			string.to_lower
		end

	to_upper (string: STRING_32)
		do
			string.to_upper
		end

	translate (target, old_characters, new_characters: STRING_32)
		local
			s: EL_STRING_32_ROUTINES
		do
			s.translate (target, old_characters, new_characters)
		end

	translate_general (str: STRING_32; old_characters, new_characters: READABLE_STRING_GENERAL)
		local
			s: EL_STRING_32_ROUTINES
		do
			s.translate (str, old_characters.to_string_8, new_characters.to_string_8)
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end

feature {NONE} -- Constants

	Xml_escaper: XML_ESCAPER [STRING_32]
		once
			create Result.make_128_plus
		end
end