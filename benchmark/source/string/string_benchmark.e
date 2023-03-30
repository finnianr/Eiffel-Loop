note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-30 12:27:27 GMT (Thursday 30th March 2023)"
	revision: "24"

deferred class
	STRING_BENCHMARK

inherit
	SHARED_HEXAGRAM_STRINGS

	MEMORY
		export
			{NONE} all
		end

	EL_BENCHMARK_ROUTINES
		export
			{NONE} all
		end

	BENCHMARK_CONSTANTS

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (command: ZSTRING_BENCHMARK_COMMAND)
		do
			trial_duration_ms := command.trial_duration_ms
			routine_filter := command.routine_filter
			create performance_tests.make (23)
			create memory_tests.make (23)
			escape_character := Back_slash

			do_performance_tests; do_memory_tests
		end

feature -- Access

	memory_tests: EL_ARRAYED_LIST [TUPLE [description, input_format: STRING; storage_size: INTEGER]]

	trial_duration_ms: INTEGER

	performance_tests: EL_ARRAYED_LIST [TUPLE [routines, input_format: STRING; repetition_count: DOUBLE]]

feature {NONE} -- Implementation

	do_memory_tests
		do
			do_memory_test ("$A $D", 1)
			if test.strings_count > 1 then
				do_memory_test ("$A $D", 64)
			end
		end

	do_performance_tests
		do
			do_performance_test ("append_string", "D", agent test_append_string)
			do_performance_test ("append_string_general", "A,D", agent test_append_string_general)
			do_performance_test ("append_utf_8", "A,D", agent test_append_utf_8)

			do_performance_test ("as_string_8", "$A $D", agent test_as_string_8)
			do_performance_test ("as_string_32", "$A $D", agent test_as_string_32)
			do_performance_test ("to_lower", "$A $D", agent test_to_lower)
			do_performance_test ("to_upper", "$A $D", agent test_to_upper)

			do_performance_test ("code (z_code)", "$A $D", agent test_code)

			do_performance_test ("ends_with", "D", agent test_ends_with)
			do_performance_test ("ends_with_general", "D", agent test_ends_with_general)

			do_performance_test ("escaped (as XML)", "put_amp (D)", agent test_xml_escape)

			do_performance_test ("index_of", "D", agent test_index_of)
			do_performance_test ("insert_string", "D", agent test_insert_string)
			do_performance_test ("is_less (sort)", "D", agent test_sort)
			do_performance_test ("is_equal", "D", agent test_is_equal)
			do_performance_test ("item", "$A $D", agent test_item)

			do_performance_test ("last_index_of", "D", agent test_last_index_of)
			do_performance_test ("left_adjust", "padded (A)", agent test_left_adjust)

			do_performance_test ("prepend_string", "D", agent test_prepend_string)
			do_performance_test ("prepend_string_general", "A,D", agent test_prepend_string_general)

			do_performance_test ("prune_all", "$A $D", agent test_prune_all)

			do_performance_test ("remove_substring", "D", agent test_remove_substring)
			do_performance_test ("replace_character", "$D", agent test_replace_character)
			do_performance_test ("replace_substring", "D", agent test_replace_substring)
			do_performance_test ("replace_substring_all", "D", agent test_replace_substring_all)
			do_performance_test ("right_adjust", "padded (A)", agent test_right_adjust)

			do_performance_test ("split, substring", "$A $D", agent test_split)
			do_performance_test ("starts_with", "D", agent test_starts_with)
			do_performance_test ("starts_with_general", "D", agent test_starts_with_general)
			do_performance_test ("substring_index", "$A $D", agent test_substring_index)

			do_performance_test ("to_utf_8", "$A $D", agent test_to_utf_8)

			do_performance_test ("translate", "D", agent test_translate)

			do_performance_test ("unescape (C lang string)", "escaped (D)", agent test_unescape)
		end

feature {NONE} -- Concatenation

	test_append_string
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		do
			concat_string (True)
		end

	test_append_string_general
		require
			valid_string_list: test.string_list.is_empty
		do
			concat_string_general (True)
		end

	test_append_utf_8
		require
			valid_utf_8_string_list: test.utf_8_string_list.count = test.strings_count
		do
			across test.utf_8_string_list as utf_8 loop
				test.append_utf_8 (test.new_string (0), utf_8.item)
			end
		end

	test_prepend_string
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		do
			concat_string (False)
		end

	test_prepend_string_general
		require
			valid_string_list: test.string_list.is_empty
		do
			concat_string_general (True)
		end

feature {NONE} -- Mutation tests

	test_insert_string
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		local
			i: INTEGER
		do
			across test.string_list as string loop
				i := string.cursor_index
				if attached string.item.twin as str then
					test.insert_string (str, test.substring_list [i].last_word, str.count // 2)
				end
			end
		end

	test_left_adjust
		do
			across test.string_list as string loop
				if attached string.item.twin as str then
					str.left_adjust
				end
			end
		end

	test_prune_all
		require
			valid_character_pair_list: test.character_pair_list.count = test.strings_count
		do
			across test.string_list as str loop
				test.prune_all (str.item, test.character_pair_list [str.cursor_index].last_character)
				test.prune_all (str.item, ' ')
			end
		end

	test_replace_character
		require
			valid_set_list: not test.character_set_list.is_empty
		do
			across test.string_list as str loop
				if attached test.character_set_list [str.cursor_index] as character_set then
					across character_set as set loop
						test.replace_character (str.item, set.item, ' ')
					end
				end
			end
		end

	test_remove_substring
		local
			str: like test.new_string
		do
			across test.string_list as string loop
				str := string.item.twin
				test.remove_substring (str, str.count // 3, str.count * 2 // 3)
			end
		end

	test_replace_substring
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		local
			start_index, end_index: INTEGER; str: like test.new_string
		do
			across test.string_list as string loop
				str := string.item.twin
				start_index := str.count // 2 - 1
				end_index:= str.count // 2 + 1
				test.replace_substring (str, test.substring_list [string.cursor_index].last_word, start_index, end_index)
			end
		end

	test_replace_substring_all
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		do
			across test.string_list as string loop
				if attached test.substring_list [string.cursor_index] as substring then
					test.replace_substring_all (string.item.twin, substring.middle_word, substring.last_word)
				end
			end
		end

	test_right_adjust
		do
			across test.string_list as str loop
				str.item.right_adjust
			end
		end

	test_to_lower
		do
			across test.string_list as string loop
				test.to_lower (string.item)
			end
		end

	test_to_upper
		do
			across test.string_list as string loop
				test.to_upper (string.item)
			end
		end

	test_translate
		require
			valid_substring_list: test.substring_list.count = test.strings_count
			valid_substitution_list: test.substitution_list.count = test.strings_count
		local
			old_characters, new_characters: like test.new_string
		do
			across test.string_list as string loop
				old_characters := test.substitution_list [string.cursor_index].old_characters
				new_characters := test.substitution_list [string.cursor_index].new_characters
				if attached string.item.twin as str then
					test.translate (str, old_characters, new_characters)
				end
			end
		end

feature {NONE} -- Query tests

	test_as_string_8
		do
			across test.string_list as string loop
				call (string.item.as_string_8)
			end
		end

	test_as_string_32
		do
			across test.string_list as string loop
				call (string.item.as_string_32)
			end
		end

	test_code
		local
			i: INTEGER; str: like test.new_string
		do
			across test.string_list as string loop
				str := string.item
				from i := 1 until i > str.count loop
					call (str.code (i))
					i := i + 1
				end
			end
		end

	test_ends_with
		require
			valid_substring_list: test.tail_words_list.count = test.strings_count
		do
			across test.string_list as string loop
				if attached test.tail_words_list [string.cursor_index] as tail_words then
					if string.item.ends_with (tail_words.last_two) then
						do_nothing
					end
				end
			end
		end

	test_ends_with_general
		require
			valid_substring_list: test.tail_words_list.count = test.strings_count
		do
			across test.string_list as string loop
				if attached test.tail_words_list [string.cursor_index] as tail_words then
					if string.item.ends_with (tail_words.last_two_32) then
						do_nothing
					end
				end
			end
		end

	test_index_of
		require
			valid_character_pair_list: test.character_pair_list.count = test.strings_count
		local
			uc: CHARACTER_32
		do
			across test.string_list as str loop
				uc := test.character_pair_list [str.cursor_index].last_character
				call (str.item.index_of (uc, 1))
			end
		end

	test_item
		local
			i: INTEGER; str: like test.new_string
		do
			across test.string_list as string loop
				str := string.item
				from i := 1 until i > str.count loop
					call (str [i])
					i := i + 1
				end
			end
		end

	test_is_equal
		require
			valid_string_list_twin: test.string_list_twin.count = test.strings_count
		do
			across test.string_list as str loop
				if str.item.is_equal (test.string_list_twin [str.cursor_index]) then
					do_nothing
				end
			end
		end

	test_last_index_of
		require
			valid_character_pair_list: test.character_pair_list.count = test.strings_count
		local
			str: like test.new_string; uc: CHARACTER_32
		do
			across test.string_list as string loop
				str := string.item
				uc := test.character_pair_list [string.cursor_index].first_character
				call (str.last_index_of (uc, str.count))
			end
		end

	test_sort
		local
			sortable: EL_SORTABLE_ARRAYED_LIST [STRING_GENERAL]
		do
			create sortable.make (test.string_list.count)
			across test.string_list as string loop
				sortable.extend (string.item)
			end
			sortable.ascending_sort
		end

	test_split
		local
			first: STRING_GENERAL
		do
			across test.string_list as string loop
				first := string.item
				call (first.split (' '))
			end
		end

	test_starts_with
		require
			valid_substring_list: test.head_words_list.count = test.strings_count
		do
			across test.string_list as string loop
				if attached test.head_words_list [string.cursor_index] as head_words then
					if string.item.starts_with (head_words.first_two) then
						do_nothing
					end
				end
			end
		end

	test_starts_with_general
		require
			valid_substring_list: test.head_words_list.count = test.strings_count
		do
			across test.string_list as string loop
				if attached test.head_words_list [string.cursor_index] as head_words then
					if string.item.starts_with (head_words.first_two_32) then
						do_nothing
					end
				end
			end
		end

	test_substring_index
		require
			valid_substring_list: test.search_string_list.count = test.strings_count
		do
			across test.string_list as string loop
				if attached test.search_string_list [string.cursor_index] as string_list then
					across string_list as list loop
						call (string.item.substring_index (list.item, 1))
					end
				end
			end
		end

	test_to_utf_8
		do
			across test.string_list as string loop
				call (test.to_utf_8 (string.item))
			end
		end

	test_unescape
		local
			str: READABLE_STRING_GENERAL
		do
			across test.string_list as string loop
				str := test.unescaped (string.item)
			end
		end

	test_xml_escape
		do
			across test.string_list as string loop
				call (test.xml_escaped (string.item.twin))
			end
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

	concat_string_general (append: BOOLEAN)
		require
			valid_string_list: test.string_list.is_empty
		local
			str: like test.new_string
		do
			str := test.new_string (100)
			across Hexagram.string_arrays as array loop
				test.wipe_out (str)
				across test.format_columns as column loop
					if append then
						str.append (array.item [column.item])
					else
						str.prepend (array.item [column.item])
					end
				end
			end
		end

	concat_string (append: BOOLEAN)
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		local
			str: like test.new_string
		do
			str := test.new_string (100)
			across test.string_list as string loop
				test.wipe_out (str)
				if append then
					str.append (string.item)
					str.append (test.substring_list [string.cursor_index].first_word)
				else
					str.prepend (string.item)
					str.prepend (test.substring_list [string.cursor_index].first_word)
				end
			end
		end

	do_memory_test (a_format: STRING; rows: INTEGER)
		local
			i: INTEGER; l_description: STRING; output_string: like test.new_string
		do
			if rows = 1 then
				l_description := "First line only"
			else
				l_description := "Lines 1 to " + rows.out
			end
			lio.put_labeled_string (generator, l_description); lio.put_labeled_string (" input", a_format)
			lio.put_new_line
			test := new_test_strings ("append_string", a_format)
			output_string := test.string_list.first.twin
			from i := 2 until i > rows loop
				output_string.append_code (32)
				output_string.append (test.string_list [i])
				i := i + 1
			end
			memory_tests.extend ([l_description, test.display_format, test.storage_bytes (output_string)])
		end

	do_performance_test (routines, a_format: STRING; procedure: PROCEDURE)
		local
			count: DOUBLE
		do
			if routines.has_substring (routine_filter) then
				test := new_test_strings (routines, a_format)

				lio.put_labeled_string (generator, routines);
				lio.put_labeled_substitution (" input", "%"%S%" x %S", [a_format, test.strings_count])
				lio.put_new_line
				count := application_count (procedure, trial_duration_ms).to_real_64
				performance_tests.extend ([routines, test.display_format, count])
			end
		end

	new_test_strings (routines, a_format: STRING): TEST_STRINGS [STRING_GENERAL]
		deferred
		end

feature {NONE} -- Internal attributes

	escape_character: CHARACTER_32

	test: like new_test_strings

	routine_filter: STRING

end