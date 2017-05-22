note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 10:40:33 GMT (Friday 8th July 2016)"
	revision: "1"

deferred class
	STRING_BENCHMARK

inherit
	MODULE_HEXAGRAM

	EL_MODULE_STRING_32

	EL_MODULE_EIFFEL

	EL_MODULE_LOG

	MEMORY

	EL_BENCHMARK_ROUTINES

feature {NONE} -- Initialization

	make (a_number_of_runs: like number_of_runs; a_routine_filter: ZSTRING)
		do
			number_of_runs := a_number_of_runs; routine_filter := a_routine_filter.to_unicode
			create {STRING} output_string.make (0)
			create input_string_list.make (64)
			create input_substring_list.make (64)
			create input_character_list.make (64)
			create performance_tests.make (23)
			create memory_tests.make (23)
			set_escape_character (Back_slash)
		end

feature -- Access

	performance_tests: ARRAYED_LIST [TUPLE [routines: STRING_32; input_format: STRING; average_time: DOUBLE]]

	memory_tests: ARRAYED_LIST [TUPLE [description: STRING; input_format: STRING; storage_size: INTEGER]]

feature -- Basic operations

	do_performance_tests
		do
			do_performance_test ("append_string", "D", agent test_append_string)
			do_performance_test ("append_string_general", "A,D", agent test_append_string_general)

			do_performance_test ("as_lower", "$A $D", agent test_as_lower)
			do_performance_test ("as_string_32", "$A $D", agent test_as_string_32)
			do_performance_test ("as_upper", "$A $D", agent test_as_upper)

			do_performance_test ("code (z_code)", "$A $D", agent test_code)

			do_performance_test ("ends_with", "D", agent test_ends_with)
			do_performance_test ("escaped (as XML)", "put_amp (D)", agent test_xml_escape)

			do_performance_test ("index_of", "D", agent test_index_of)
			do_performance_test ("insert_string", "D", agent test_insert_string)
			do_performance_test ("is_less (sort)", "D", agent test_sort)
			do_performance_test ("item", "$A $D", agent test_item)

			do_performance_test ("last_index_of", "D", agent test_last_index_of)
			do_performance_test ("left_adjust", "padded (A)", agent test_left_adjust)

			do_performance_test ("prepend_string", "D", agent test_prepend_string)
			do_performance_test ("prepend_string_general", "A,D", agent test_prepend_string_general)

			do_performance_test ("prune_all", "$A $D", agent test_prune_all)

			do_performance_test ("remove_substring", "D", agent test_remove_substring)
			do_performance_test ("replace_substring", "D", agent test_replace_substring)
			do_performance_test ("replace_substring_all", "D", agent test_replace_substring_all)
			do_performance_test ("right_adjust", "padded (A)", agent test_right_adjust)

			do_performance_test ("split, substring", "$A $D", agent test_split)
			do_performance_test ("starts_with", "D", agent test_starts_with)
			do_performance_test ("substring_index", "$A $D", agent test_substring_index)

			do_performance_test ("translate", "D", agent test_translate)

			do_performance_test ("unescape (C lang string)", "escaped (D)", agent test_unescape)
		end

	do_memory_tests
		do
			do_memory_test ("$A $D", 1)
			do_memory_test ("$A $D", 64)
		end

feature -- Benchmark tests

	test_append_string
		local
			str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item.twin
				append (str, input_substring_list.i_th (string.cursor_index).first_word)
			end
		end

	test_append_string_general
		do
			add_string_general (True)
		end

	test_as_lower
		do
			change_case (True)
		end

	test_as_string_32
		local
			str: like new_string; i: INTEGER
		do
			across input_string_list as string loop
				i := string.cursor_index
				str := string.item
				call (str.as_string_32)
			end
		end

	test_as_upper
		do
			change_case (False)
		end

	test_code
		local
			i: INTEGER; str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item
				from i := 1 until i > str.count loop
					call (str.code (i))
					i := i + 1
				end
			end
		end

	test_ends_with
		local
			ending: STRING_GENERAL; substring: like input_substring_list.item
		do
			across input_string_list as string loop
				substring := input_substring_list [string.cursor_index]
				call (ends_with (string.item, substring.first_word))
				call (ends_with (string.item, substring.last_word))
			end
		end

	test_index_of
		local
			str: STRING_GENERAL; uc: CHARACTER_32
		do
			across input_string_list as string loop
				str := string.item
				uc := input_character_list.i_th (string.cursor_index).last_character
				call (str.index_of (uc, 1))
			end
		end

	test_item
		local
			i: INTEGER; str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item
				from i := 1 until i > str.count loop
					call (item (str, i))
					i := i + 1
				end
			end
		end

	test_insert_string
		local
			str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item.twin
				insert_string (str, input_substring_list.i_th (string.cursor_index).last_word, str.count // 2)
			end
		end

	test_last_index_of
		local
			str: STRING_GENERAL;  uc: CHARACTER_32
		do
			across input_string_list as string loop
				str := string.item
				uc := input_character_list.i_th (string.cursor_index).first_character
				call (str.last_index_of (uc, str.count))
			end
		end

	test_left_adjust
		do
			adjust (True)
		end

	test_prepend_string
		do
			across input_string_list as string loop
				prepend (string.item.twin, input_substring_list.i_th (string.cursor_index).last_word)
			end
		end

	test_prepend_string_general
		do
			add_string_general (False)
		end

	test_prune_all
		local
			str: STRING_GENERAL; i: INTEGER
		do
			across input_string_list as string loop
				str := string.item.twin
				prune_all (str, input_character_list.i_th (string.cursor_index).last_character)
				prune_all (str, ' ')
			end
		end

	test_remove_substring
		local
			str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item.twin
				remove_substring (str, str.count // 3, str.count * 2 // 3)
			end
		end

	test_replace_substring
		local
			start_index, end_index: INTEGER; str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item.twin
				start_index := str.count // 2 - 1
				end_index:= str.count // 2 + 1
				replace_substring (str, input_substring_list.i_th (string.cursor_index).last_word, start_index, end_index)
			end
		end

	test_replace_substring_all
		local
			substring: like input_substring_list.item
		do
			across input_string_list as string loop
				substring := input_substring_list [string.cursor_index]
				replace_substring_all (string.item.twin, substring.middle_word, substring.last_word)
			end
		end

	test_right_adjust
		do
			adjust (False)
		end

	test_sort
		local
			sortable: EL_SORTABLE_ARRAYED_LIST [STRING_GENERAL]
		do
			create sortable.make (input_string_list.count)
			across input_string_list as string loop
				sortable.extend (string.item)
			end
			sortable.sort
		end

	test_split
		local
			first: STRING_GENERAL
		do
			across input_string_list as string loop
				first := string.item
				call (first.split (' '))
			end
		end

	test_starts_with
		local
			substring: like input_substring_list.item
		do
			across input_string_list as string loop
				substring := input_substring_list [string.cursor_index]
				call (starts_with (string.item, substring.first_word))
				call (starts_with (string.item, substring.last_word))
			end
		end

	test_substring_index
		local
			substring: like input_substring_list.item
		do
			across input_string_list as string loop
				substring := input_substring_list [string.cursor_index]
				call (string.item.substring_index (substring.last_word, 1))
			end
		end

	test_translate
		local
			str: STRING_GENERAL; old_characters, new_characters: STRING_GENERAL
			substring: like input_substring_list.item; l_count: INTEGER
		do
			across input_string_list as string loop
				str := string.item.twin
				substring := input_substring_list [string.cursor_index]
				old_characters := substring.last_word.twin
				new_characters := substring.first_word.twin
				l_count := old_characters.count.min (new_characters.count)
				old_characters.keep_head (l_count)
				new_characters.keep_head (l_count)
				translate (str, old_characters, new_characters)
			end
		end

	test_unescape
		local
			str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item.twin
				unescape (str)
			end
		end

	test_xml_escape
		do
			across input_string_list as string loop
				call (xml_escaped (string.item.twin))
			end
		end

feature {NONE} -- Factory

	new_string (unicode: STRING_GENERAL): STRING_GENERAL
		deferred
		end

	new_string_with_count (n: INTEGER): STRING_GENERAL
		deferred
		end

feature {NONE} -- Implementation

	add_string_general (do_append: BOOLEAN)
		local
			str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item; str.keep_head (0)
				across format_columns as column loop
					if attached {READABLE_STRING_GENERAL} Hexagram.string_arrays [column.item] as readable_string then
						if do_append then
							str.append (readable_string)
						else
							str.prepend (readable_string)
						end
					end
				end
			end
		end

	adjust (left: BOOLEAN)
		local
			str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item.twin
				if left then
					str.left_adjust
				else
					str.right_adjust
				end
			end
		end

	call (object: ANY)
		do
		end

	change_case (as_lower: BOOLEAN)
		local
			str: STRING_GENERAL
		do
			across input_string_list as string loop
				str := string.item.twin
				if as_lower then
					call (str.as_lower)
				else
					call (str.as_upper)
				end
			end
		end

	do_performance_test (routines: STRING_32; a_input_format: STRING; procedure: PROCEDURE)
		require
			valid_input_format: across input_arguments (a_input_format) as c all c.item.is_alpha implies c.item.is_upper end
		local
			timer: EL_EXECUTION_TIMER; i: INTEGER
		do
			if routines.has_substring (routine_filter) then
				log.enter_no_header ("do_performance_test")
				lio.put_labeled_string (generator, routines); lio.put_labeled_string (" input", a_input_format)
				lio.put_new_line
				input_format := a_input_format
				fill_input_strings (routines)
				full_collect
				create timer.make
				from i := 1 until i > number_of_runs loop
					procedure.apply; full_collect
					i := i + 1
				end
				timer.stop
				performance_tests.extend ([routines, displayed_input_format, timer.elapsed_millisecs / number_of_runs])
				log.exit_no_trailer
			end
		end

	do_memory_test (a_input_format: STRING; rows: INTEGER)
		require
			valid_input_format: across input_arguments (a_input_format) as c all c.item.is_alpha implies c.item.is_upper end
		local
			i: INTEGER; description: STRING
		do
			log.enter_no_header ("do_memory_test")
			if rows = 1 then
				description := "First line only"
			else
				description := "Lines 1 to " + rows.out
			end
			lio.put_labeled_string (generator, description); lio.put_labeled_string (" input", a_input_format)
			lio.put_new_line
			input_format := a_input_format
			fill_input_strings ("append_string")
			output_string := input_string_list.first.twin
			from i := 2 until i > rows loop
				output_string.append_code (32)
				append (output_string, input_string_list [i])
				i := i + 1
			end
			memory_tests.extend ([description, displayed_input_format, storage_bytes (output_string)])
			log.exit_no_trailer
		end

	displayed_input_format: STRING
		local
			pos_first, pos_last: INTEGER
		do
			pos_first := input_format.index_of ('$', 1)
			if pos_first > 0 then
				Result := input_format.twin
				Result.insert_character ('"', pos_first)
				pos_last := Result.last_index_of ('$', Result.count)
				Result.insert_character ('"', pos_last + 2)
			else
				Result := input_format
			end
		end

	escape_input_strings
		local
			i: INTEGER
		do
			across input_string_list as string loop
				if attached {EL_ZSTRING} string.item  as str_z then
					str_z.translate_general (" ", "\")
				elseif attached {STRING_32} string.item  as str_32 then
					String_32.translate (str_32, " ", "\")
				end
				from i := string.item.index_of (Pinyin_u, 1) until i = 0 loop
					if attached {EL_ZSTRING} string.item  as str_z then
						str_z.insert_character (Back_slash, i)
					elseif attached {STRING_32} string.item  as str_32 then
						str_32.insert_character (Back_slash, i)
					end
					i := string.item.index_of (Pinyin_u, i + 2)
				end
			end
		end

	fill_input_strings (routines: STRING_32)
		local
			parts_32: ARRAYED_LIST [STRING_GENERAL]; words: LIST [STRING_GENERAL]
			format_args: STRING; i, count: INTEGER
			str, first_word, last_word, first_character, last_character: STRING_GENERAL
		do
			input_string_list.wipe_out; input_substring_list.wipe_out; input_character_list.wipe_out
			format_args := input_arguments (input_format)
			format_columns := input_columns (format_args)
			if routines.has_substring ("pend_general") then
				across 1 |..| 64 as n loop
					input_string_list.extend (new_string_with_count (0))
				end
			else
				across Hexagram.string_arrays as array loop
					create parts_32.make (format_columns.count)
					from i := 1  until i > format_columns.upper loop
						parts_32.extend (new_string (array.item [format_columns [i]]))
						i := i + 1
					end
					input_string_list.extend (joined_string (parts_32))
				end
			end
			if input_format.starts_with (Padded) then
				pad_input_strings (format_args)
			elseif input_format.starts_with (Put_amp) then
				put_ampersands_input_strings
			elseif input_format.starts_with (Escaped) then
				escape_input_strings
			end
			across input_string_list as string loop
				str := string.item; count := str.count
				first_character := str.substring (1, 1)
				last_character := str.substring (count, count)
				words := str.split (' ')
				input_substring_list.extend ([words [1], words [(words.count // 2) + 1], words [words.count], first_character, last_character])
				input_character_list.extend ([str [1], str [count]])
			end
		end

	put_ampersands_input_strings
		do
			across input_string_list as string loop
				if attached {STRING_32} string.item as str_32 then
					str_32.replace_substring_all (" ", "&")
				elseif attached {EL_ZSTRING} string.item as str_z then
					str_z.replace_character (' ', '&')
				end
			end
		end

	input_arguments (format: STRING): STRING
		local
			pos_left_bracket: INTEGER
		do
			pos_left_bracket := format.index_of ('(', 1)
			if pos_left_bracket > 0 then
				Result := format.substring (pos_left_bracket + 1, format.count - 1)
			else
				Result := format
			end
		end

	input_columns (format: STRING): ARRAY [INTEGER]
		local
			c: CHARACTER; l_array: ARRAYED_LIST [CHARACTER]; i: INTEGER
		do
			create l_array.make (4)
			if format.has ('$') then
				across format.split (' ') as str loop
					l_array.extend (str.item [str.item.count])
				end
			else
				across format.split (',') as str loop
					l_array.extend (str.item [1])
				end
			end
			create Result.make (1, l_array.count)
			from i := 1 until i > l_array.count loop
				c := l_array [i]
				Result [i] := c.natural_32_code.to_integer_32 - {ASCII}.upper_a + 1
				i := i + 1
			end
		end

	joined_count (parts: LIST [READABLE_STRING_GENERAL]; with_separators: BOOLEAN): INTEGER
		do
			if with_separators then
				Result := parts.count - 1
			end
			across parts as part loop
				Result := Result + part.item.count
			end
		end

	joined_string (parts_32: ARRAYED_LIST [STRING_GENERAL]): STRING_GENERAL
		do
			Result := new_string_with_count (joined_count (parts_32, True))
			across parts_32 as part loop
				if part.cursor_index > 1 then
					Result.append_code (32)
				end
				append (Result, part.item)
			end
		end

	pad_input_strings (format_args: STRING)
		do
			across input_string_list as string loop
				if across "BC" as letter some format_args.has (letter.item) end then
					prepend (string.item, Ogham_padding); append (string.item, Ogham_padding)
				else
					prepend (string.item, Space_padding); append (string.item, Space_padding)
				end
			end
		end

	set_escape_character (a_escape_character: like escape_character)
		do
			C_escape_table.remove (escape_character)
			escape_character := a_escape_character
			C_escape_table [a_escape_character] := a_escape_character
		end

feature {NONE} -- Deferred implementation

	append (target: STRING_GENERAL; s: STRING_GENERAL)
		deferred
		end

	ends_with (target, ending: STRING_GENERAL): BOOLEAN
		deferred
		end

	insert_string (target, insertion: STRING_GENERAL; index: INTEGER)
		deferred
		end

	item (target: STRING_GENERAL; index: INTEGER): CHARACTER_32
		deferred
		end

	prepend (target: STRING_GENERAL; s: STRING_GENERAL)
		deferred
		end

	prune_all (target: STRING_GENERAL; uc: CHARACTER_32)
		deferred
		end

	remove_substring (target: STRING_GENERAL; start_index, end_index: INTEGER)
		deferred
		end

	replace_substring (target, insertion: STRING_GENERAL; start_index, end_index: INTEGER)
		deferred
		end

	replace_substring_all (target, original, new: STRING_GENERAL)
		deferred
		end

	starts_with (target, beginning: STRING_GENERAL): BOOLEAN
		deferred
		end

	storage_bytes (s: STRING_GENERAL): INTEGER
		deferred
		end

	to_string_32 (string: STRING_GENERAL): STRING_32
		deferred
		end

	translate (target, old_characters, new_characters: STRING_GENERAL)
		deferred
		end

	unescape (target: STRING_GENERAL)
		deferred
		end

	xml_escaped (target: STRING_GENERAL): STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	escape_character: CHARACTER_32

	format_columns: ARRAY [INTEGER]

	input_character_list: ARRAYED_LIST [TUPLE [first_character, last_character: CHARACTER_32]]

	input_format: STRING

	input_string_list: ARRAYED_LIST [STRING_GENERAL]
		-- first column of `input_string_list'

	input_substring_list: ARRAYED_LIST [TUPLE [first_word, middle_word, last_word, first_character, last_character: STRING_GENERAL]]

	number_of_runs: INTEGER

	output_string: STRING_GENERAL

	routine_filter: STRING_32

feature {NONE} -- Constants

	Back_slash: CHARACTER = '\'

	C_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (7)
			Result ['n'] := '%N'
			Result ['r'] := '%R'
			Result ['t'] := '%T'

			Result ['N'] := '%N'
			Result ['R'] := '%R'
			Result ['T'] := '%T'
 		end

	Escaped: STRING = "escaped"

	Ogham_padding: STRING_32
		once
			create Result.make_filled ((1680).to_character_32, 5)
		end

	Padded: STRING = "padded"

	Put_amp: STRING = "put_amp"

	Pinyin_u: CHARACTER_32 = 'ū'

	Space_padding: STRING_32
		once
			create Result.make_filled (' ', 5)
		end

end
