note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-30 18:16:10 GMT (Wednesday 30th August 2023)"
	revision: "13"

deferred class
	MIXED_ENCODING_STRING_BENCHMARK

inherit
	STRING_BENCHMARK
		redefine
			do_performance_tests, do_memory_tests
		end

feature -- Basic operations

	do_performance_tests
		do
			do_test ("append_string", "A,B,C,A,B,C", agent test_append_prepend (True))
			do_test ("append_string_general", "A,B,C,D", agent test_append_prepend_general (True))
			do_test ("append_utf_8", "$B $C", agent test_append_utf_8)

			do_test ("as_string_32", "$A $B $C $D", agent test_as_string_32)
			do_test ("to_lower", "$A $B $C $D", agent test_to_lower_upper (True))
			do_test ("to_upper", "$A $B $C $D", agent test_to_lower_upper (False))

			do_test ("code (z_code)", "$A $B $C $D", agent test_code)
			do_test ("code (z_code)", "$B $C", agent test_code)

			do_test ("ends_with", "$A $B $C", agent test_ends_with (False))
			do_test ("ends_with_general", "$A $B $C", agent test_ends_with (True))

			do_test ("escaped (as XML)", "put_amp ($B $C)", agent test_xml_escape)

			do_test ("index_of", "$B $C", agent test_index_of)
			do_test ("is_equal", "$A $B $C", agent test_is_equal)
			do_test ("is_less (sort)", "B", agent test_sort)
			do_test ("insert_string", "$B $C", agent test_insert_string)
			do_test ("item", "$A $B $C $D", agent test_item)
			do_test ("item", "$B $C", agent test_item)

			do_test ("last_index_of", "$B $C", agent test_last_index_of)
			do_test ("left_adjust", "padded (C)", agent test_left_right_adjust (True))

			do_test ("prepend_string", "A,B,C,A,B,C", agent test_append_prepend (False))
			do_test ("prepend_string_general", "A,B,C,D", agent test_append_prepend_general (False))

			do_test ("prune_all", "$B $C", agent test_prune_all)

			do_test ("remove_substring", "$A $B $C", agent test_remove_substring)
			do_test ("replace_character", "$B $C", agent test_replace_character)
			do_test ("replace_substring", "$A $B $C", agent test_replace_substring)
			do_test ("replace_substring_all", "$A $B $C", agent test_replace_substring_all)
			do_test ("right_adjust", "padded (C)", agent test_left_right_adjust (False))

			do_test ("split, substring", "$A $B $C $D", agent test_split)
			do_test ("starts_with", "$B $C $A", agent test_starts_with (False))
			do_test ("starts_with_general", "$B $C $A", agent test_starts_with (True))
			do_test ("substring_index", "$A $B $C", agent test_substring_index)
			do_test ("substring_index", "$B $C $A", agent test_substring_index)

			do_test ("to_utf_8", "$A $B $C $D", agent test_to_utf_8)
			do_test ("translate", "$B $C", agent test_translate)

			escape_character := Pinyin_u
			do_test ("unescape (C lang string)", "escaped ($B $C)", agent test_unescape)
			escape_character := Back_slash
		end

	do_memory_tests
		do
			do_memory_test ("$B", 1)
			if test.strings_count > 1 then
				do_memory_test ("$B", 64)
			end

			do_memory_test ("$C", 1)
			if test.strings_count > 1 then
				do_memory_test ("$C", 64)
			end

			do_memory_test ("$A $B $C $D", 1)
			if test.strings_count > 1 then
				do_memory_test ("$A $B $C $D", 64)
			end
		end

end