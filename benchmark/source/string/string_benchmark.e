note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-06 18:43:16 GMT (Tuesday 6th August 2024)"
	revision: "28"

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

	EL_MODULE_LIO; EL_MODULE_EXCEPTION

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

	performance_tests: EL_ARRAYED_LIST [TUPLE [routine_name, input_format: STRING; repetition_count: DOUBLE]]

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
			do_test ("append_string", "A,D", agent test_append_prepend (True))
			do_test ("append_string_general", "A,D", agent test_append_prepend_general (True))
			do_test ("append_utf_8", "A,D", agent test_append_utf_8)

			do_test ("as_string_8", "$A $D", agent test_as_string_8)
			do_test ("as_string_32", "$A $D", agent test_as_string_32)
			do_test ("to_lower", "$A $D", agent test_to_lower_upper (True))
			do_test ("to_upper", "$A $D", agent test_to_lower_upper (False))

			do_test ("code (z_code)", "$A $D", agent test_code)

			do_test ("ends_with", "D", agent test_ends_with (False))
			do_test ("ends_with_general", "D", agent test_ends_with (True))

			do_test ("escaped (as XML)", "put_amp (D)", agent test_xml_escape)

			do_test ("index_of", "D", agent test_index_of)
			do_test ("insert_string", "D", agent test_insert_string)
			do_test ("is_less (sort)", "D", agent test_sort)
			do_test ("is_equal", "D", agent test_is_equal)
			do_test ("item", "$A $D", agent test_item)

			do_test ("last_index_of", "D", agent test_last_index_of)
			do_test ("left_adjust", "padded (A)", agent test_left_right_adjust (True))

			do_test ("prepend_string", "A,D", agent test_append_prepend (False))
			do_test ("prepend_string_general", "A,D", agent test_append_prepend_general (False))

			do_test ("prune_all", "$A $D", agent test_prune_all)

			do_test ("remove_substring", "D", agent test_remove_substring)
			do_test ("replace_character", "$D", agent test_replace_character)
			do_test ("replace_substring", "D", agent test_replace_substring)
			do_test ("replace_substring_all", "D", agent test_replace_substring_all)
			do_test ("right_adjust", "padded (A)", agent test_left_right_adjust (False))

			do_test ("split, substring", "$A $D", agent test_split)
			do_test ("starts_with", "D", agent test_starts_with (False))
			do_test ("starts_with_general", "D", agent test_starts_with (True))
			do_test ("substring_index", "$A $D", agent test_substring_index)

			do_test ("to_latin_1", "$A $D", agent test_to_latin_1)
			do_test ("to_utf_8", "$A $D", agent test_to_utf_8)

			do_test ("translate", "D", agent test_translate)

			do_test ("unescape (C lang string)", "escaped (D)", agent test_unescape)
		end

feature {NONE} -- Concatenation

	test_append_prepend (appending: BOOLEAN)
		local
			str: like test.new_string; list_has_items: BOOLEAN
		do
			str := test.new_string (100)
			if attached test.routine as routine then
				across test.array_list as array loop
					list_has_items := True
					routine.wipe_out (str)
					across test.format_columns as n loop
						if appending then
							routine.append (str, array.item [n.item])
						else
							routine.prepend (str, array.item [n.item])
						end
					end
				end
			end
			valid_test := list_has_items
		end

	test_append_prepend_general (appending: BOOLEAN)
		require
			valid_string_list: test.string_list.is_empty
		local
			str: like test.new_string; list_has_items: BOOLEAN
		do
			str := test.new_string (100)
			if attached test.routine as routine then
				across Hexagram.string_arrays as array loop
					list_has_items := True
					routine.wipe_out (str)
					across test.format_columns as n loop
						if appending then
							routine.append_general (str, array.item [n.item])
						else
							routine.prepend_general (str, array.item [n.item])
						end
					end
				end
			end
			valid_test := list_has_items
		end

	test_append_utf_8
		require
			valid_utf_8_string_list: test.utf_8_string_list.count = test.strings_count
		local
			str: like test.new_string; list_has_items: BOOLEAN
		do
			str := test.new_string (0)
			across test.utf_8_string_list as utf_8 loop
				list_has_items := True
				test.routine.wipe_out (str)
				test.routine.append_utf_8 (str, utf_8.item)
			end
			valid_test := list_has_items
		end

feature {NONE} -- Mutation tests

	test_insert_string
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		local
			list_has_items: BOOLEAN; i: INTEGER
		do
			across test.string_list as string loop
				list_has_items := True
				i := string.cursor_index
				if attached string.item.twin as str then
					test.routine.insert_string (str, test.substring_list [i].last_word, str.count // 2)
				end
			end
			valid_test := list_has_items
		end

	test_left_right_adjust (left: BOOLEAN)
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as string loop
				list_has_items := True
				if attached string.item.twin as str then
					if left then
						str.left_adjust
					else
						str.right_adjust
					end
				end
			end
			valid_test := list_has_items
		end

	test_prune_all
		require
			valid_character_pair_list: test.character_pair_list.count = test.strings_count
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached list.item.twin as str then
					test.routine.prune_all (str, test.character_pair_list [list.cursor_index].last_character)
					test.routine.prune_all (str, ' ')
				end
			end
			valid_test := list_has_items
		end

	test_replace_character
		require
			valid_set_list: not test.character_set_list.is_empty
		local
			str: like test.new_string; list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				str := list.item.twin
				if attached test.character_set_list [list.cursor_index] as character_set then
					across character_set as set loop
						test.routine.replace_character (str, set.item, ' ')
					end
				end
			end
			valid_test := list_has_items
		end

	test_remove_substring
		local
			str: like test.new_string; list_has_items: BOOLEAN
		do
			across test.string_list as string loop
				list_has_items := True
				str := string.item.twin
				test.routine.remove_substring (str, str.count // 3, str.count * 2 // 3)
			end
			valid_test := list_has_items
		end

	test_replace_substring
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		local
			start_index, end_index: INTEGER; str: like test.new_string; list_has_items: BOOLEAN
		do
			across test.string_list as string loop
				list_has_items := True
				str := string.item.twin
				start_index := str.count // 2 - 1
				end_index:= str.count // 2 + 1
				test.routine.replace_substring (
					str, test.substring_list [string.cursor_index].last_word, start_index, end_index
				)
			end
			valid_test := list_has_items
		end

	test_replace_substring_all
		require
			valid_substring_list: test.substring_list.count = test.strings_count
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached test.substring_list [list.cursor_index] as substring then
					test.routine.replace_substring_all (list.item.twin, substring.middle_word, substring.last_word)
				end
			end
			valid_test := list_has_items
		end

	test_to_lower_upper (as_lower: BOOLEAN)
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached list.item.twin as str then
					if as_lower then
						test.routine.to_lower (str)
					else
						test.routine.to_upper (str)
					end
				end
			end
			valid_test := list_has_items
		end

	test_translate
		require
			valid_substring_list: test.substring_list.count = test.strings_count
			valid_substitution_list: test.substitution_list.count = test.strings_count
		local
			old_characters, new_characters: like test.new_string
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				old_characters := test.substitution_list [list.cursor_index].old_characters
				new_characters := test.substitution_list [list.cursor_index].new_characters
				if attached list.item.twin as str then
					test.routine.translate (str, old_characters, new_characters)
				end
			end
			valid_test := list_has_items
		end

feature {NONE} -- Query tests

	test_as_string_8
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached list.item.as_string_8 as str_8 then
					do_nothing
				end
			end
			valid_test := list_has_items
		end

	test_as_string_32
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached list.item.as_string_32 then
					do_nothing
				end
			end
			valid_test := list_has_items
		end

	test_code
		local
			i: INTEGER; str: like test.new_string; list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				str := list.item
				from i := 1 until i > str.count loop
					if str.code (i) = 0 then
						do_nothing
					end
					i := i + 1
				end
			end
			valid_test := list_has_items
		end

	test_ends_with (general: BOOLEAN)
		require
			valid_substring_list: test.tail_words_list.count = test.strings_count
		local
			list_has_items: BOOLEAN
		do
			if attached test.routine as routine then
				across test.string_list as list loop
					list_has_items := True
					if attached test.tail_words_list [list.cursor_index] as tail_words then
						if general then
							if routine.ends_with_general (list.item, tail_words.last_two_32) then
								do_nothing
							end
						else
							if routine.ends_with (list.item, tail_words.last_two) then
								do_nothing
							end
						end
					end
				end
			end
			valid_test := list_has_items
		end

	test_index_of
		require
			valid_character_pair_list: test.character_pair_list.count = test.strings_count
		local
			uc: CHARACTER_32; list_has_items: BOOLEAN
		do
			across test.string_list as str loop
				list_has_items := True
				uc := test.character_pair_list [str.cursor_index].last_character
				if str.item.index_of (uc, 1) = 0 then
					do_nothing
				end
			end
			valid_test := list_has_items
		end

	test_item
		local
			i: INTEGER; str: like test.new_string; list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				str := list.item
				from i := 1 until i > str.count loop
					call (str [i])
					i := i + 1
				end
			end
			valid_test := list_has_items
		end

	test_is_equal
		require
			valid_string_list_twin: test.string_list_twin.count = test.strings_count
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as str loop
				list_has_items := True
				if str.item.is_equal (test.string_list_twin [str.cursor_index]) then
					do_nothing
				end
			end
			valid_test := list_has_items
		end

	test_last_index_of
		require
			valid_character_pair_list: test.character_pair_list.count = test.strings_count
		local
			str: like test.new_string; list_has_items: BOOLEAN; uc: CHARACTER_32
		do
			across test.string_list as list loop
				list_has_items := True
				str := list.item
				uc := test.character_pair_list [list.cursor_index].first_character
				call (str.last_index_of (uc, str.count))
			end
			valid_test := list_has_items
		end

	test_sort
		local
			sortable: EL_SORTABLE_ARRAYED_LIST [STRING_GENERAL]; list_has_items: BOOLEAN
		do
			create sortable.make (test.string_list.count)
			across test.string_list as list loop
				list_has_items := True
				sortable.extend (list.item)
			end
			sortable.ascending_sort
			valid_test := list_has_items
		end

	test_split
		local
			first: STRING_GENERAL; list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				first := list.item
				call (first.split (' '))
			end
			valid_test := list_has_items
		end

	test_starts_with (general: BOOLEAN)
		require
			valid_substring_list: test.head_words_list.count = test.strings_count
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached test.head_words_list [list.cursor_index] as head_words then
					if general then
						if list.item.starts_with (head_words.first_two_32) then
							do_nothing
						end
					else
						if list.item.starts_with (head_words.first_two) then
							do_nothing
						end
					end
				end
			end
			valid_test := list_has_items
		end

	test_substring_index
		require
			valid_substring_list: test.search_string_list.count = test.strings_count
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached test.search_string_list [list.cursor_index] as search_list then
					across search_list as search loop
						call (list.item.substring_index (search.item, 1))
					end
				end
			end
			valid_test := list_has_items
		end

	test_to_latin_1
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				call (test.routine.to_latin_1 (list.item))
			end
			valid_test := list_has_items
		end

	test_to_utf_8
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				call (test.routine.to_utf_8 (list.item))
			end
			valid_test := list_has_items
		end

	test_unescape
		local
			str: READABLE_STRING_GENERAL; list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				str := test.unescaped (list.item)
			end
			valid_test := list_has_items
		end

	test_xml_escape
		local
			list_has_items: BOOLEAN
		do
			across test.string_list as list loop
				list_has_items := True
				if attached test.routine.xml_escaped (list.item.twin) as str then
					do_nothing
				end
			end
			valid_test := list_has_items
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
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
			test := new_test_strings ("remove_substring", a_format)
			output_string := test.string_list.first.twin
			from i := 2 until i > rows loop
				output_string.append_code (32)
				output_string.append (test.string_list [i])
				i := i + 1
			end
			memory_tests.extend ([l_description, test.display_format, test.storage_bytes (output_string)])
		end

	do_test (routine_name, a_format: STRING; procedure: PROCEDURE)
		local
			count: DOUBLE; s: EL_STRING_8_ROUTINES
		do
			if routine_filter.count > 0 implies s.matches_wildcard (routine_name, routine_filter) then
				test := new_test_strings (routine_name, a_format)

				lio.put_labeled_string (generator, routine_name);
				lio.put_labeled_substitution (" input", "%"%S%" x %S", [a_format, test.strings_count])
				lio.put_new_line
				valid_test := False
				count := application_count (procedure, trial_duration_ms).to_real_64
				if not valid_test then
					Exception.raise_developer ("Invalid test data list for %S", [routine_name])
				end
				performance_tests.extend ([routine_name, test.display_format, count])
			end
		end

	new_test_strings (routine_name, a_format: STRING): TEST_STRINGS [STRING_GENERAL, STRING_ROUTINES [STRING_GENERAL]]
		deferred
		end

feature {NONE} -- Internal attributes

	valid_test: BOOLEAN

	escape_character: CHARACTER_32

	test: like new_test_strings

	routine_filter: STRING

end