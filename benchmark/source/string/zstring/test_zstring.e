note
	description: "Test zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 17:13:21 GMT (Thursday 17th August 2023)"
	revision: "5"

class
	TEST_ZSTRING

inherit
	TEST_STRINGS [ZSTRING]

create
	make

feature -- Measurement

	storage_bytes (s: ZSTRING): INTEGER
		do
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
			if s.has_mixed_encoding then
				Result := Result + Eiffel.physical_size (s.unencoded_area)
			end
		end

feature -- Conversion

	to_utf_8 (string: ZSTRING): STRING
		do
			Result := string.to_utf_8 (True)
		end

	xml_escaped (target: ZSTRING): ZSTRING
		do
			Result := xml_escaper.escaped (target, True)
		end

feature -- Basic operations

	append_utf_8 (target: ZSTRING; utf_8: STRING)
		do
			target.append_utf_8 (utf_8)
		end

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

feature {NONE} -- Factory

	new_character_set (str: ZSTRING): EL_HASH_SET [CHARACTER_32]
		do
			create Result.make_size (str.count // 2)
			across str as uc loop
				Result.put (uc.item)
			end
		end

feature {NONE} -- Constants

	Unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (C_escape_table)
		end

	Xml_escaper: XML_ESCAPER [ZSTRING]
		once
			create Result.make_128_plus
		end

end