note
	description: "General test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-31 9:58:01 GMT (Tuesday 31st January 2023)"
	revision: "40"

class
	GENERAL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_BASE_64; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_NAMING

	EL_MODULE_REUSEABLE

	SHARED_HEXAGRAM_STRINGS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("any_array_numeric_type_detection", agent test_any_array_numeric_type_detection)
			eval.call ("base_64_codec_1", agent test_base_64_codec_1)
			eval.call ("base_64_codec_2", agent test_base_64_codec_2)
			eval.call ("character_32_status_queries", agent test_character_32_status_queries)
			eval.call ("environment_put", agent test_environment_put)
			eval.call ("math_precision", agent test_math_precision)
			eval.call ("named_thread", agent test_named_thread)
			eval.call ("naming", agent test_naming)
			eval.call ("reusable_strings", agent test_reusable_strings)
			eval.call ("reverse_managed_pointer", agent test_reverse_managed_pointer)
			eval.call ("version_array", agent test_version_array)
			eval.call ("integer_32_bit_routines", agent test_integer_32_bit_routines)
			eval.call ("natural_32_bit_routines", agent test_natural_32_bit_routines)
		end

feature -- Tests

	test_any_array_numeric_type_detection
		local
			array: ARRAY [ANY]
		do
			array := << (1).to_reference, 1.0, (1).to_integer_64 >>
			assert ("same types", array.item (1).generating_type ~ {INTEGER_32_REF})
			assert ("same types", array.item (2).generating_type ~ {DOUBLE})
			assert ("same types", array.item (3).generating_type ~ {INTEGER_64})
		end

	test_base_64_codec_1
		-- basic test from example in https://en.wikipedia.org/wiki/Base64
		note
			testing: "covers/{EL_BASE_64_CODEC}.decoded", "covers/{EL_BASE_64_CODEC}.encoded"
		local
			str, encoded: STRING; str_encoded: ARRAY [STRING]
		do
			str_encoded := << "TQ==", "TWE=", "TWFu" >>
			from str := "Man" until str.is_empty loop
				encoded := Base_64.encoded (str, False)
				assert ("encoding OK", encoded ~ str_encoded [str.count])
				assert ("decoding OK", str ~  Base_64.decoded (encoded))
				str.remove_tail (1)
			end
		end

	test_base_64_codec_2
		-- GENERAL_TEST_SET.test_base_64_codec_2
		-- rigourous test
		note
			testing: "covers/{EL_BASE_64_CODEC}.decoded", "covers/{EL_BASE_64_CODEC}.encoded"
		local
			base_64_str, last_8_characters, trimmed, padding: STRING; zstr, zstr_2: ZSTRING
			parts: EL_ZSTRING_LIST; padding_permutation_set: EL_HASH_SET [STRING]
		do
			create padding_permutation_set.make (3)
			across Hexagram.String_arrays as array loop
				create parts.make_from_general (array.item)
				zstr := parts.joined_words
				base_64_str := Base_64.encoded (zstr.to_utf_8 (False), True)
				last_8_characters := base_64_str.substring (base_64_str.count - 8 + 1, base_64_str.count)
				last_8_characters.prune ('%N')
				trimmed := last_8_characters.twin; trimmed.prune_all_trailing ('=')
				create padding.make_filled ('=', last_8_characters.count - trimmed.count)
				lio.put_labeled_string (parts.first, last_8_characters)
				if array.cursor_index \\ 4 = 0 then
					lio.put_new_line
				else
					lio.put_character (' ')
				end
				create zstr_2.make_from_utf_8 (Base_64.decoded (base_64_str))
				assert_same_string (Void, zstr, zstr_2)
				padding_permutation_set.put (padding)
			end
			assert ("all == endings found", padding_permutation_set.count = 3 )
		end

	test_character_32_status_queries
		do
--			Bug in finalized exe for compiler version 16.05
--			assert ("not is_space", not ({CHARACTER_32}'€').is_space)
--			assert ("not is_digit ", not ({CHARACTER_32}'€').is_digit)

			assert ("not is_alpha", not ({CHARACTER_32}'€').is_alpha)
			assert ("not is_punctuation", not ({CHARACTER_32}'€').is_punctuation)
			assert ("not is_control", not ({CHARACTER_32}'€').is_control)
		end

	test_environment_put
		local
			name: STRING
		do
			name := "EIFFEL_LOOP_DOC"
			Execution_environment.put ("eiffel-loop", name)
			Execution_environment.put ("", name)
			assert ("not attached", not attached Execution_environment.item (name))
		end

	test_math_precision
		local
			double: EL_DOUBLE_MATH
		do
			assert ("equal within 1 percent", double.approximately_equal (169, 170, 0.01))
			assert ("not equal within 1 percent", not double.approximately_equal (168, 170, 0.01))
		end

	test_named_thread
		local
			t: EL_NAMED_THREAD
		do
			create t
			assert ("same string", t.name.same_string ("Named Thread"))
		end

	test_naming
		note
			testing: "covers/{EL_NAMING_ROUTINES}.to_title",
						"covers/{EL_NAMING_ROUTINES}.class_description"
		local
			eif_name, title, description: STRING
			excluded_words: EL_STRING_8_LIST
		do
			eif_name := "hex_11_software"
			create title.make (eif_name.count)
			Naming.to_title (eif_name, title, ' ', Naming.empty_word_set)
			assert ("is title", title ~ "Hex 11 Software")

			excluded_words := "EL"
			description := Naming.class_description_from ({EL_SPLIT_READABLE_STRING_LIST [STRING]}, excluded_words)
			assert ("expected description", description ~ "Split readable string list for type STRING_8")

			description := Naming.class_description_from (Current, excluded_words)
			assert ("expected description", description ~ "General test SET")
		end

	test_reusable_strings
		local
			s1, s2, s3, s4: ZSTRING
		do
			across Reuseable.string as reuse loop
				s1 := reuse.item
				assert ("empty string", s1.is_empty)
				s1.append_string_general ("abc")
				across Reuseable.string as reuse2 loop
					s3 := reuse2.item
					assert ("s3 is new instance", s1 /= s3)
				end
			end
			across Reuseable.string as reuse loop
				s2 := reuse.item
				assert ("empty string", s2.is_empty)
				across Reuseable.string as reuse2 loop
					s4 := reuse2.item
				end
			end
			assert ("instance recycled", s1 = s2)
			assert ("nested instances recycled", s3 = s4)
		end

	test_reverse_managed_pointer
		local
			ptr: MANAGED_POINTER; reverse_ptr: EL_REVERSE_MANAGED_POINTER
			n_16: NATURAL_16; n_32: NATURAL_32; n_64: NATURAL_64
		do
			create ptr.make (8)
			create reverse_ptr.share_from_pointer (ptr.item, 8)

			ptr.put_natural_16 (0x11_22, 0)
			n_16 := reverse_ptr.read_natural_16 (0)
			assert ("reversed", n_16 = 0x22_11)

			ptr.put_natural_32 (0x11_22_33_44, 0)
			n_32 := reverse_ptr.read_natural_32 (0)
			assert ("reversed", n_32 = 0x44_33_22_11)

			ptr.put_natural_64 (0x11_22_33_44_55_66_77_88, 0)
			n_64 := reverse_ptr.read_natural_64 (0)
			assert ("reversed", n_64 = 0x88_77_66_55_44_33_22_11)
		end

	test_version_array
		-- GENERAL_TEST_SET.test_version_array
		local
			version, version_2: EL_VERSION_ARRAY; part_list: EL_STRING_8_LIST
			digit_count, part_count, i: INTEGER; compact_version: NATURAL
		do
			create version.make (2, 2, 1_02)
			assert_same_string (Void, version.out, "1.2")
			assert ("compact OK", version.compact = 1_02)

			create version.make (3, 2, 01_02_03)
			assert_same_string (Void, version.out, "1.2.3")
			assert ("compact OK", version.compact = 01_02_03)

			create version.make_from_string (2, "1.2.3")
			assert ("compact OK", version.compact = 01_02_03)

			create version_2.make_from_string (2, "1.2.4")

			assert ("less than version_2", version < version_2)
			assert ("not version_2 less than version", not (version_2 < version))

			create version.make_from_array (2, << 1, 2, 4 >>)
			assert ("versions equal", version ~ version_2)

			create part_list.make (4)
			across 1 |..| 4 as n loop
				digit_count := n.item; part_count := 9 // digit_count
				part_list.wipe_out
				from i := 1 until i > part_count loop
					part_list.extend (create {STRING}.make_filled ('0' + i, digit_count))
					i := i + 1
				end
				create version.make_from_string (digit_count, part_list.joined ('.'))
				lio.put_labeled_string ("version " + part_count.out + " parts of " + digit_count.out + " digits", version.out)
				lio.put_new_line

				assert_same_string ("same version string", part_list.joined ('.'), version.out)

				compact_version := version.compact
				create version_2.make (part_count, digit_count, compact_version)
				assert ("same version", version ~ version_2)
			end
		end

feature -- Bit-routine Tests

	test_integer_32_bit_routines
		-- GENERAL_TEST_SET.test_integer_32_bit_routines
		local
			i32: EL_INTEGER_32_BIT_ROUTINES
			i, value, initial_value, mask: INTEGER
		do
--			count trailing zeros
			assert ("one has 0", i32.shift_count (1) = 0)
			assert ("zero has 32", i32.shift_count (0) = 32)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("zero count OK", i32.shift_count (mask) = i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("0xF fits in 0xF0", i32.compatible_value (0xF0, 0xF))
			assert ("0x10 does not fit in 0xF0", not i32.compatible_value (0xF0, 0x10))

			assert ("0xF0 has continous bits", i32.valid_mask (0xF0))
			assert ("0x3 has continous bits", i32.valid_mask (0x3))
			assert ("1001 bits are not continuous", not i32.valid_mask (0x90))

			assert ("set 8 shifted right by 4", i32.inserted (0x000, 0x0F0, 8) = 0x080)
			assert ("set 8 shifted right by 8", i32.inserted (0x080, 0xF00, 8) = 0x880)
			assert ("set 8 shifted right by 24", i32.inserted (0x000, 0xF0_0000, 8) = 0x80_0000)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("insert OK", i32.inserted (0, mask, 1) = initial_value |<< i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("value in position 3 is 0x8", i32.isolated (0x881, 0xF00) = 0x08)
			assert ("value in position 2 is 0x8", i32.isolated (0x881, 0x0F0) = 0x08)
			assert ("value in position 1 is 0x1", i32.isolated (0x881, 0x00F) = 0x1)
		end

	test_natural_32_bit_routines
		-- GENERAL_TEST_SET.test_natural_32_bit_routines
		local
			n32: EL_NATURAL_32_BIT_ROUTINES
			i: INTEGER; value, initial_value, mask: NATURAL_32
		do
--			count trailing zeros
			assert ("one has 0", n32.shift_count (1) = 0)
			assert ("zero has 32", n32.shift_count (0) = 32)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("zero count OK", n32.shift_count (mask) = i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("0xF fits in 0xF0", n32.compatible_value (0xF0, 0xF))
			assert ("0x10 does not fit in 0xF0", not n32.compatible_value (0xF0, 0x10))

			assert ("0xF0 has continous bits", n32.valid_mask (0xF0))
			assert ("0x3 has continous bits", n32.valid_mask (0x3))
			assert ("1001 bits are not continuous", not n32.valid_mask (0x90))

			assert ("set 8 shifted right by 4", n32.inserted (0x000, 0x0F0, 8) = 0x080)
			assert ("set 8 shifted right by 8", n32.inserted (0x080, 0xF00, 8) = 0x880)
			assert ("set 8 shifted right by 24", n32.inserted (0x000, 0xF0_0000, 8) = 0x80_0000)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("insert OK", n32.inserted (0, mask, 1) = initial_value |<< i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("value in position 3 is 0x8", n32.isolated (0x881, 0xF00) = 0x08)
			assert ("value in position 2 is 0x8", n32.isolated (0x881, 0x0F0) = 0x08)
			assert ("value in position 1 is 0x1", n32.isolated (0x881, 0x00F) = 0x1)
		end

end