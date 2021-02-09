note
	description: "Benchmark using pure Latin encodable string data"
	notes: "[
		Abandoned work on this benchmark after discovering major bug in {UC_UTF8_STRING}.replace_substring_all
		See: TEST_UC_UTF8_STRING
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-03 7:23:28 GMT (Wednesday 3rd February 2021)"
	revision: "9"

class
	UC_UTF8_STRING_BENCHMARK

inherit
	STRING_BENCHMARK
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (command: ZSTRING_BENCHMARK_COMMAND)
		do
			Precursor (command)
			create xml_escaper.make_128_plus
		end

feature {NONE} -- Implementation

	append (target: like new_string; s: STRING_GENERAL)
		do
			target.append_string_general (s)
		end

	ends_with (target, ending: like new_string): BOOLEAN
		do
			Result := target.ends_with (ending)
		end

	insert_string (target, insertion: like new_string; index: INTEGER)
		do
			target.insert_string (insertion, index)
		end

	item (target: like new_string; index: INTEGER): CHARACTER_32
		do
			Result := target.character_32_item (index)
		end

	prepend (target: like new_string; s: STRING_GENERAL)
		do
			target.prepend_string_general (s)
		end

	prune_all (target: like new_string; uc: CHARACTER_32)
		local
			str_32: STRING_32; readable_target: READABLE_STRING_GENERAL
		do
			readable_target := target
			str_32 := readable_target.to_string_32
			str_32.prune_all (uc)
			target.wipe_out
			target.append_string_general (str_32)
		end

	replace_character (target: like new_string; old_character, new_character: CHARACTER_32)
		do
		end

	remove_substring (target: like new_string; start_index, end_index: INTEGER)
		do
			target.remove_substring (start_index, end_index)
		end

	replace_substring (target, insertion: like new_string; start_index, end_index: INTEGER)
		do
			target.replace_substring (insertion, start_index, end_index)
		end

	replace_substring_all (target, original, new: like new_string)
		do
			target.replace_substring_all (original, new)
		end

	starts_with (target, beginning: like new_string): BOOLEAN
		do
			Result := target.starts_with (beginning)
		end

	storage_bytes (s: like new_string): INTEGER
		local
			str: STRING
		do
			str := s
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (str.area)
		end

	to_string_32 (string: like new_string): STRING_32
		local
			l_string: READABLE_STRING_GENERAL
		do
			l_string := string
			Result := l_string.to_string_32
		end

	to_utf_8 (string: like new_string): STRING
		do
			Result := string
		end

	translate (target, old_characters, new_characters: like new_string)
		do
--			String_32.translate (target, old_characters, new_characters)
		end

--	unescaped (target: like new_string): UC_UTF8_STRING
--		do
----			String_32.unescape (target, escape_character, C_escape_table)
--		end

	xml_escaped (target: UC_UTF8_STRING): UC_UTF8_STRING
		do
--			Result := xml_escaper.escaped (target)
		end

feature {NONE} -- Factory

	new_string (unicode: STRING_GENERAL): UC_UTF8_STRING
		do
			create Result.make_from_string_general (unicode)
		end

	new_string_with_count (n: INTEGER): UC_UTF8_STRING
		do
			create Result.make (n)
		end

feature {NONE} -- Internal attributes

	xml_escaper: XML_UC_UTF8_STRING_ESCAPER

feature {NONE} -- Constants

	Unescaper: EL_STRING_8_UNESCAPER
		once
			create Result.make (Back_slash, C_escape_table)
		end
end