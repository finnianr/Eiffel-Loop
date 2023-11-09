note
	description: "[$source ZSTRING] routines for benchmarking"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 11:55:20 GMT (Thursday 9th November 2023)"
	revision: "2"

class
	ZSTRING_ROUTINES

inherit
	STRING_ROUTINES [ZSTRING]

feature -- Concatenation

	append (target, str: ZSTRING)
		do
			target.append (str)
		end

	append_general (target: ZSTRING; str: READABLE_STRING_GENERAL)
		do
			target.append_string_general (str)
		end

	append_utf_8 (target: ZSTRING; utf_8: STRING)
		do
			target.append_utf_8 (utf_8)
		end

	prepend (target, str: ZSTRING)
		do
			target.prepend (str)
		end

	prepend_general (target: ZSTRING; str: READABLE_STRING_GENERAL)
		do
			target.prepend_string_general (str)
		end

feature -- Status query

	ends_with (target, str: ZSTRING): BOOLEAN
		do
			Result := target.ends_with (str)
		end

	ends_with_general (target: ZSTRING; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := target.ends_with_general (str)
		end

	starts_with (target, str: ZSTRING): BOOLEAN
		do
			Result := target.starts_with (str)
		end

	starts_with_general (target: ZSTRING; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := target.starts_with_general (str)
		end

feature -- Conversion

	to_utf_8 (string: ZSTRING): STRING
		do
			Result := string.to_utf_8
		end

	xml_escaped (target: ZSTRING): ZSTRING
		do
			Result := xml_escaper.escaped (target, True)
		end

feature -- Basic operations

	insert_character (target: ZSTRING; uc: CHARACTER_32; i: INTEGER)
		do
			target.insert_character (uc, i)
		end

	insert_string (target, insertion: ZSTRING; index: INTEGER)
		do
			target.insert_string (insertion, index)
		end

	prune_all (target: ZSTRING; uc: CHARACTER_32)
		do
			target.prune_all (uc)
		end

	remove_substring (target: ZSTRING; start_index, end_index: INTEGER)
		do
			target.remove_substring (start_index, end_index)
		end

	replace_character (target: ZSTRING; uc_old, uc_new: CHARACTER_32)
		do
			target.replace_character (uc_old, uc_new)
		end

	replace_substring (target, insertion: ZSTRING; start_index, end_index: INTEGER)
		do
			target.replace_substring (insertion, start_index, end_index)
		end

	replace_substring_all (target, original, new: ZSTRING)
		do
			target.replace_substring_all (original, new)
		end

	to_lower (string: ZSTRING)
		do
			string.to_lower
		end

	to_upper (string: ZSTRING)
		do
			string.to_upper
		end

	translate (target, old_characters, new_characters: ZSTRING)
		do
			target.translate (old_characters, new_characters)
		end

	translate_general (str: ZSTRING; old_characters, new_characters: READABLE_STRING_GENERAL)
		do
			str.translate (old_characters, new_characters)
		end

	wipe_out (str: ZSTRING)
		do
			str.wipe_out
		end

feature {NONE} -- Constants

	Xml_escaper: XML_ESCAPER [ZSTRING]
		once
			create Result.make_128_plus
		end
end