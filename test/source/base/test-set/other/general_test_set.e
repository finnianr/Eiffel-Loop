note
	description: "General test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-01 9:53:13 GMT (Saturday 1st July 2023)"
	revision: "47"

class
	GENERAL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_BASE_64; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_DIRECTORY

	EL_MODULE_NAMING; EL_MODULE_REUSEABLE

	SHARED_HEXAGRAM_STRINGS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["any_array_numeric_type_detection", agent test_any_array_numeric_type_detection],
				["base_64_codec_1",						 agent test_base_64_codec_1],
				["base_64_codec_2",						 agent test_base_64_codec_2],
				["environment_put",						 agent test_environment_put],
				["math_precision",						 agent test_math_precision],
				["is_file_writable",						 agent test_is_file_writable],
				["named_thread",							 agent test_named_thread],
				["reverse_managed_pointer",			 agent test_reverse_managed_pointer],
				["version_array",							 agent test_version_array],
				["version_bump",							 agent test_version_bump]
			>>)
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

	test_environment_put
		local
			name: STRING
		do
			name := "EIFFEL_LOOP_DOC"
			Execution_environment.put ("eiffel-loop", name)
			Execution_environment.put ("", name)
			assert ("not attached", not attached Execution_environment.item (name))
		end

	test_is_file_writable
		-- GENERAL_TEST_SET.test_is_file_writable
		local
			ec_path, test_ecf: FILE_PATH
		do
			ec_path := "$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin/ec"
			ec_path.expand
			if {PLATFORM}.is_windows then
				ec_path.add_extension ("exe")
			end
			test_ecf := Directory.current_working + "test.ecf"

			assert ("ec.exe is not writable", not File.is_writable (ec_path))
			assert ("test.ecf is writable", File.is_writable (test_ecf))
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

	test_version_bump
		-- GENERAL_TEST_SET.test_version_bump
		local
			software: EL_SOFTWARE_VERSION; assertion_ok: STRING
		do
			assertion_ok := "expected version"
			create software.make_parts (1, 2, 3, 4)
			software.bump_release

			assert (assertion_ok, software.compact_version = 01_02_04)
			software.bump_minor

			assert (assertion_ok, software.compact_version = 01_03_00)
			software.bump_major

			assert (assertion_ok, software.compact_version = 02_00_00)
		end

end