note
	description: "General test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 7:42:25 GMT (Friday 20th September 2024)"
	revision: "60"

class
	GENERAL_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_MODULE_BASE_64; EL_MODULE_CONSOLE; EL_MODULE_EXECUTABLE

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_NAMING

	EL_SHARED_ENCODINGS; EL_SHARED_TEST_TEXT; EL_SHARED_STRING_8_BUFFER_SCOPES

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
				["encodeables",					 agent test_encodeables],
				["environment_put",				 agent test_environment_put],
				["is_file_writable",				 agent test_is_file_writable],
				["make_relative_directory",	 agent test_make_relative_directory],
				["math_precision",				 agent test_math_precision],
				["named_thread",					 agent test_named_thread],
				["output_medium_encoding",		 agent test_output_medium_encoding],
				["plain_text_line_source",		 agent test_plain_text_line_source],
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
			across Hexagram.String_arrays as array loop
				create parts.make_from_general (array.item)
				zstr := parts.joined_words
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

	test_encodeables
		-- GENERAL_TEST_SET.test_encodeables
		note
			testing: "[
				covers/{EL_OUTPUT_MEDIUM}.put_other,
				covers/{EL_ENCODING_BASE}.set_from_name
			]"
		local
			buffer: EL_STRING_8_IO_MEDIUM; encoding: ENCODING
			is_ansi: BOOLEAN; line: EL_STRING_8
		do
			create buffer.make (50)
			buffer.set_encoding_other (Encodings.Utf_8)
			assert ("is utf-8", buffer.encoded_as_utf (8))

			create encoding.make ("850")
			buffer.set_encoding_from_name ("cp850")
			assert ("same encoding", buffer.encoding_other ~ encoding)

			buffer.set_encoding_other (Console.Encoding)
			is_ansi := Console.code_page.has_substring ("ANSI")

			across Text.lines_8 as list loop
				create line.make_from_string (list.item)
				if attached Encodings.Unicode as unicode then
					if is_ansi implies line.is_ascii then
						Buffer.wipe_out
						Buffer.put_string_8 (line)
						unicode.convert_to (Console.Encoding, line)
						assert ("conversion successful", unicode.last_conversion_successful)
						assert_same_string (Void, Buffer.text, unicode.last_converted_string_8)
					end
				end
			end
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

	test_is_file_writable
		-- GENERAL_TEST_SET.test_is_file_writable
		local
			ec_path, test_ecf: FILE_PATH
		do
			create ec_path.make_expanded ("$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin/ec")
			if {PLATFORM}.is_windows then
				ec_path.add_extension ("exe")
			end
			test_ecf := Directory.current_working + "test.ecf"

			assert ("ec.exe is not writable", not File.is_writable (ec_path))
			assert ("test.ecf is writable", File.is_writable (test_ecf))
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

	test_output_medium_encoding
		-- GENERAL_TEST_SET.test_output_medium_encoding
		note
			testing: "[
				covers/{EL_OUTPUT_MEDIUM}.put_string,
				covers/{EL_OUTPUT_MEDIUM}.put_string_32,
				covers/{EL_OUTPUT_MEDIUM}.put_string_8,
				covers/{EL_PLAIN_TEXT_LINE_SOURCE}.to_array,
				covers/{EL_PLAIN_TEXT_FILE}.read_line,
				covers/{EL_FILE_OPEN_ROUTINES}.open_lines,
				covers/{EL_FILE_GENERAL_LINE_SOURCE}.extend_special,
				covers/{EL_ZCODEC}.encode_substring, covers/{EL_ZCODEC}.encode_substring_32,
				covers/{EL_ZCODEC}.encode_sub_zstring
			]"
		local
			encoding: EL_ENCODEABLE_AS_TEXT; file_out: EL_PLAIN_TEXT_FILE
			path: FILE_PATH; str, str_item: ZSTRING; str_8: detachable STRING
		do
			across << Windows_class, Latin_class, Utf_8 >> as encoding_type loop
				across Text.lines_32 as list loop
					if attached list.item as str_32 then
						str := str_32
						if str_32.is_valid_as_string_8 then
							str_8 := str_32
						else
							str_8 := Void
						end
						encoding := Text.natural_encoding (str_32, encoding_type.item)
						path := Work_area_dir + (encoding.encoding_name + ".txt")
						create file_out.make_open_write (path)
						file_out.set_encoding (encoding)
						file_out.put_line (str)
						if attached str_8 as s8 then
							file_out.put_string_8 (s8)
						else
							file_out.put_line (str_32)
						end
						file_out.close
						if attached open_lines (path, encoding.encoding).to_array as array then
							assert ("two lines", array.count = 2)
							str_item := array [1]
							assert ("equal to ZSTRING", str ~ str_item)
							if attached str_8 as s8 then
								assert ("is latin-1", array [2].is_valid_as_string_8)
								assert ("equal to STRING_8", str_8 ~ array [2].to_string_8)
							else
								assert ("equal to STRING_32", str_32 ~ array [2].to_string_32)
							end
						end
					end
				end
			end
		end

	test_plain_text_line_source
		-- GENERAL_TEST_SET.test_plain_text_line_source
		note
			testing: "[
				covers/{EL_FILE_OPEN_ROUTINES}.open,
				covers/{EL_LINE_SOURCE_ITERATION_CURSOR}.forth,
				covers/{EL_PLAIN_TEXT_LINE_SOURCE}.make,
				covers/{EL_PLAIN_TEXT_LINE_SOURCE}.forth,
				covers/{EL_PLAIN_TEXT_LINE_SOURCE}.as_list,
				covers/{EL_PLAIN_TEXT_FILE}.average_line_count,
				covers/{EL_READABLE_ZSTRING}.substring_to_reversed,
				covers/{EL_SPLIT_ZSTRING_ON_STRING}.make
			]"
		local
			header_path, output_path: FILE_PATH; description, part: ZSTRING; code: STRING
			line_list: EL_ZSTRING_LIST; count: INTEGER
		do
			header_path := Dev_environ.El_test_data_dir + "code/C/unix/error-codes.h"
			output_path := Work_area_dir + header_path.base
			output_path.replace_extension ("txt")

			if attached open_lines (header_path, Latin_1) as line_source
				and then attached open (output_path, Write) as output
			then
				output.set_latin_encoding (1)
				across line_source as line loop
					across line.shared_item.split_on_string (C_comment_mark) as list loop
						part := list.item
						if part.count > 0 then
							part.adjust
							if list.cursor_index = 1 then
								code := part.substring_to_reversed ('%T')
								code.left_adjust
							else
								part.remove_tail (3)
								description := part
							end
						end
					end
					if code.is_integer_32 then
						if output.count > 0 then
							output.put_new_line
						end
						output.put_string_8 (code); output.put_string_8 (":%N%T")
						output.put_string (description)
					end
					count := count + 1
				end
				output.close
				assert_same_digest (Plain_text, output_path, "RLAGdnzdvWEwm0pukVZZ7Q==")
				create line_list.make (count)
				if attached line_source as list then
					from list.start until list.after loop
						line_list.extend (list.item_copy)
						list.forth
					end
					assert ("closed", line_source.is_closed)
					assert ("same list", line_list ~ line_source.as_list)
				end
			end
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

feature {NONE} -- Constants

	C_comment_mark: ZSTRING
		once
			Result := "/*"
		end
end