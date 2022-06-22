note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 10:00:19 GMT (Wednesday 22nd June 2022)"
	revision: "13"

class
	ZSTRING_BENCHMARK

inherit
	STRING_BENCHMARK
		redefine
			make, storage_bytes
		end

	STRING_HANDLER

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
			if attached {ZSTRING} s as zstring then
				target.append (zstring)
			else
				target.append_string_general (s)
			end
		end

	append_utf_8 (target: like new_string; utf_8: STRING)
		do
			target.append_utf_8 (utf_8)
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
			Result := target [index]
		end

	is_a_equal_to_b (a, b: like new_string)
		do
			if a.is_equal (b) then
				do_nothing
			end
		end

	prepend (target: like new_string; s: STRING_GENERAL)
		do
			if attached {ZSTRING} s as zstring then
				target.prepend (zstring)
			else
				target.prepend_string_general (s)
			end
		end

	prune_all (target: like new_string; uc: CHARACTER_32)
		do
			target.prune_all (uc)
		end

	to_string_32 (string: like new_string): STRING_32
		do
			Result := string.to_string_32
		end

	replace_character (target: like new_string; uc_old, uc_new: CHARACTER_32)
		do
			target.replace_character (uc_old, uc_new)
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

	storage_bytes (s: like new_string_with_count): INTEGER
		do
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
			if s.has_mixed_encoding then
				Result := Result + Eiffel.physical_size (s.unencoded_area)
			end
		end

	to_utf_8 (string: like new_string): STRING
		do
			Result := string.to_utf_8 (True)
		end

	translate (target, old_characters, new_characters: like new_string)
		do
			target.translate (old_characters, new_characters)
		end

	xml_escaped (target: ZSTRING): ZSTRING
		do
			Result := xml_escaper.escaped (target, True)
		end

feature {NONE} -- Factory

	new_string_with_count (n: INTEGER): ZSTRING
		do
			create Result.make (n)
		end

	new_string (unicode: STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (unicode)
		end

feature {NONE} -- Internal attributes

	xml_escaper: XML_ZSTRING_ESCAPER

feature {NONE} -- Constants

	Empty_unencoded: SPECIAL [NATURAL]
		once
			create Result.make_empty (0)
		end

	Unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (Back_slash, C_escape_table)
		end
end