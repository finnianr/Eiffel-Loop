note
	description: "Summary description for {STRING_32_BENCHMARK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-11 10:39:59 GMT (Friday 11th March 2016)"
	revision: "5"

class
	STRING_32_BENCHMARK

inherit
	STRING_BENCHMARK
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_number_of_runs: like number_of_runs; a_routine_filter: ZSTRING)
		do
			Precursor (a_number_of_runs, a_routine_filter)
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
			Result := target [index]
		end

	prepend (target: like new_string; s: STRING_GENERAL)
		do
			target.prepend_string_general (s)
		end

	prune_all (target: like new_string; uc: CHARACTER_32)
		do
			target.prune_all (uc)
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
		do
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
		end

	to_string_32 (string: like new_string): STRING_32
		do
			Result := string
		end

	translate (target, old_characters, new_characters: like new_string)
		do
			String_32.translate (target, old_characters, new_characters)
		end

	unescape (target: like new_string)
		do
			String_32.unescape (target, escape_character, C_escape_table)
		end

	xml_escaped (target: STRING_32): STRING_32
		do
			Result := xml_escaper.escaped (target)
		end

feature {NONE} -- Factory

	new_string (unicode: STRING_GENERAL): STRING_32
		do
			create Result.make_from_string_general (unicode)
		end

	new_string_with_count (n: INTEGER): STRING_32
		do
			create Result.make (n)
		end

feature {NONE} -- Internal attributes

	xml_escaper: EL_XML_CHARACTER_ESCAPER [STRING_32]
end

