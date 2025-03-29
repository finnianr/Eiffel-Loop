note
	description: "General test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 12:05:51 GMT (Saturday 29th March 2025)"
	revision: "66"

class
	GENERAL_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_MODULE_BASE_64; EL_MODULE_EXECUTABLE

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_NAMING

	EL_SHARED_TEST_TEXT

	SHARED_HEXAGRAM_STRINGS; SHARED_DEV_ENVIRON

	EL_PROTOCOL_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["array_item_generating_type", agent test_array_item_generating_type],
				["average_line_count",			 agent test_average_line_count],
				["base_64_codec_1",				 agent test_base_64_codec_1],
				["base_64_codec_2",				 agent test_base_64_codec_2],
				["environment_put",				 agent test_environment_put],
				["make_relative_directory",	 agent test_make_relative_directory],
				["math_precision",				 agent test_math_precision],
				["named_thread",					 agent test_named_thread],
				["object_scope",					 agent test_object_scope],
				["reverse_managed_pointer",	 agent test_reverse_managed_pointer],
				["search_path",					 agent test_search_path],
				["version_array",					 agent test_version_array],
				["version_bump",					 agent test_version_bump],
				["version_routines",				 agent test_version_routines]
			>>)
		end

feature -- Tests

	test_array_item_generating_type
		local
			array: ARRAY [ANY]
		do
			array := << (1).to_reference, 1.0, (1).to_integer_64 >>
			assert ("same types", array.item (1).generating_type ~ {INTEGER_32_REF})
			assert ("same types", array.item (2).generating_type ~ {DOUBLE})
			assert ("same types", array.item (3).generating_type ~ {INTEGER_64})
		end

	test_average_line_count
		note
			testing: "[
				covers/{EL_FILE_OPEN_ROUTINES}.open,
				covers/{EL_PLAIN_TEXT_FILE}.average_line_count,
				covers/{EL_FILE_ROUTINES_I}.average_line_count_of
			]"
		local
			pyxis_path: FILE_PATH; credits: PLAIN_TEXT_FILE
			average_1, average_2: INTEGER
		do
			pyxis_path := Dev_environ.El_test_data_dir + "pyxis/localization/credits.pyx"
			create credits.make_open_read (pyxis_path)
			average_1 := File.average_line_count_of (credits)
			credits.close
			if attached open (pyxis_path, Read) as f then
				average_2 := f.average_line_count
				f.close
			end
			assert ("average_2 < average_1", average_2 < average_1)
		end

	test_base_64_codec_1
		-- basic test from example in https://en.wikipedia.org/wiki/Base64
		note
			testing: "[
				covers/{EL_BASE_64_CODEC}.decoded,
				covers/{EL_BASE_64_CODEC}.encoded
			]"
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
			testing: "[
				covers/{EL_BASE_64_CODEC}.decoded,
				covers/{EL_BASE_64_CODEC}.encoded
			]"
		local
			base_64_str, last_8_characters, trimmed, padding: STRING; zstr, zstr_2: ZSTRING
			parts: EL_ZSTRING_LIST; padding_permutation_set: EL_HASH_SET [STRING]
		do
			create padding_permutation_set.make_equal (3)
			across Hexagram.String_arrays.new_cursor as array loop
				create parts.make_from_general (array.item)
				zstr := parts.as_word_string
				base_64_str := Base_64.encoded (zstr.to_utf_8, True)
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
		-- GENERAL_TEST_SET.test_environment_put
		local
			name: STRING; value: ZSTRING
		do
			name := "EIFFEL_LOOP_DOC"
			value := "eiffel-loop"
			Execution_environment.put (value, name)
			assert_same_string (Void, value, Execution_environment.item (name))
			Execution_environment.put ("", name)
			assert ("not attached", not attached Execution_environment.item_32 (name))
		end

	test_make_relative_directory
		-- GENERAL_TEST_SET.test_make_relative_directory
		note
			testing: "[
				covers/{EL_FILE_SYSTEM_ROUTINES_I}.make_directory,
				covers/{EL_DIR_PATH}.exists_and_is_writeable,
				covers/{EL_DIRECTORY}.named
			]"
		local
			one_two: DIR_PATH
		do
			File_system.make_directory (create {DIR_PATH}) -- check empty
			one_two := "one/two"
			File_system.make_directory (one_two)
			assert ("exists", one_two.exists)
			File_system.delete_empty_branch (one_two)
			assert ("not exists", not one_two.exists)
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

	test_object_scope
		-- GENERAL_TEST_SET.test_object_scope
		local
			app_cache: DIR_PATH; base: ZSTRING
		do
			base := Directory.App_cache.base
			app_cache := Directory.App_cache.twin
			if attached workarea_app_cache_dir_scope as scope then
				assert ("same parent", Directory.App_cache.parent ~ Work_area_dir)
				assert_same_string (Void, Directory.App_cache.base, app_cache.base)
				scope.exit
			end
			assert ("same directory", app_cache ~ Directory.App_cache)
			assert ("same base reference", base = Directory.App_cache.base)
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

	test_search_path
		do
		-- find is on both Windows and Unix (but has different purpose)
			assert ("find command available", Executable.search_path_has ("find"))
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

	test_version_routines
		-- GENERAL_TEST_SET.test_version_routines
		local
			v: EL_COMPACT_VERSION_ROUTINES
		do
			assert ("major is 1", v.major (01_02_03) = 1)
			assert ("minor is 2", v.minor (01_02_03) = 2)
			assert ("release is 3", v.release (01_02_03) = 3)
		end

feature {NONE} -- Implementation

	workarea_app_cache_dir_scope: EL_OBJECT_SCOPE [EL_DIR_PATH]
		do
			create Result.make (Directory.App_cache, Work_area_dir #+ Directory.App_cache.base)
		end

end