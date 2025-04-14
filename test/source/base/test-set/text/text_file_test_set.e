note
	description: "Test ${EL_PLAIN_TEXT_FILE} and related classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 7:55:47 GMT (Monday 14th April 2025)"
	revision: "4"

class
	TEXT_FILE_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_SHARED_TEST_TEXT

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["is_file_writable",				  agent test_is_file_writable],
				["output_medium_encoding",		  agent test_output_medium_encoding],
				["plain_text_decoded_iterator", agent test_plain_text_decoded_iterator],
				["plain_text_line_iterator",	  agent test_plain_text_line_iterator],
				["plain_text_line_source",		  agent test_plain_text_line_source],
				["plain_text_lines",				  agent test_plain_text_lines]
			>>)
		end

feature -- Tests

	test_is_file_writable
		-- TEXT_FILE_TEST_SET.test_is_file_writable
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

	test_output_medium_encoding
		-- TEXT_FILE_TEST_SET.test_output_medium_encoding
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

	test_plain_text_decoded_iterator
		-- TEXT_FILE_TEST_SET.test_plain_text_decoded_iterator
		note
			testing: "[
				covers/{EL_PLAIN_TEXT_FILE}.decoded,
				covers/{EL_DECODED_TEXT_FILE_LINES}.new_cursor,
				covers/{EL_TEXT_FILE_DECODED_LINE_CURSOR}.forth
			]"
		local
			help_path: FILE_PATH; count, euro_count: INTEGER
		do
			help_path := Dev_environ.El_test_data_dir + "txt/help-files.txt"

			if attached open (help_path, Read) as help_file then
				across help_file.decoded as decoded_line loop
					if attached decoded_line.shared_item as line then
						if line.has (Text.Euro_symbol) then
							lio.put_line (line)
							euro_count := euro_count + 1
						end
					end
					count := count + 1
				end
				assert ("18 lines", count = 18)
				assert ("2 euro symbols", euro_count = 2)
			end
		end

	test_plain_text_line_iterator
		-- TEXT_FILE_TEST_SET.test_plain_t	ext_line_iterator
		note
			testing: "[
				covers/{EL_TEXT_FILE_LINE_CURSOR}.forth
			]"
		local
			header_path, output_path: FILE_PATH; counter: EL_NATURAL_32_COUNTER
		do
			create counter
			header_path := error_codes_path; output_path := error_table_path

			if attached open_as (error_codes_path, Read, Latin_1) as header_file then
				write_indented_codes (output_path, header_file, counter)
				assert ("close file", header_file.is_closed)
				assert_same_digest (Plain_text, output_path, "5ivDTBX6P3UiElIR0O3KBw==")
				assert ("132 items", counter.item = 132)
			end
		end

	test_plain_text_line_source
		-- TEXT_FILE_TEST_SET.test_plain_text_line_source
		note
			testing: "[
				covers/{EL_FILE_OPEN_ROUTINES}.open,
				covers/{EL_LINE_SOURCE_ITERATION_CURSOR}.forth,
				covers/{EL_PLAIN_TEXT_LINE_SOURCE}.make,
				covers/{EL_PLAIN_TEXT_LINE_SOURCE}.forth,
				covers/{EL_PLAIN_TEXT_LINE_SOURCE}.as_list,
				covers/{EL_PLAIN_TEXT_FILE}.average_line_count,
				covers/{EL_READABLE_STRING_X_ROUTINES}.substring_to_reversed,
				covers/{EL_READABLE_STRING_X_ROUTINES}.delimited_list
			]"
		local
			header_path, output_path: FILE_PATH; line_list: EL_ZSTRING_LIST
			counter: EL_NATURAL_32_COUNTER
		do
			create counter
			header_path := error_codes_path; output_path := error_table_path

			if attached open_lines (header_path, Latin_1) as line_source then
				write_indented_codes (output_path, line_source, counter)
				assert_same_digest (Plain_text, output_path, "5ivDTBX6P3UiElIR0O3KBw==")
				assert ("132 items", counter.item = 132)

			-- Test LINEAR [ZSTRING] iteration
				create line_list.make (counter.to_integer_32)
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

	test_plain_text_lines
		-- TEXT_FILE_TEST_SET.test_plain_text_lines
		note
			testing: "[
				covers/{EL_FILE_ROUTINES_I}.plain_text_lines,
				covers/{EL_SPLIT_ON_CHARACTER_8}.new_cursor,
				covers/{EL_SPLIT_ON_CHARACTER_8_CURSOR}.forth,
				covers/{EL_READABLE_STRING_X_ROUTINES}.substring_to_reversed,
				covers/{EL_READABLE_STRING_X_ROUTINES}.delimited_list
			]"
		local
			header_path, output_path: FILE_PATH; counter: EL_NATURAL_32_COUNTER
			last_line: STRING
		do
			create counter
			header_path := error_codes_path; output_path := error_table_path

			if attached File.plain_text_lines (header_path) as lines then
				write_indented_codes (output_path, lines, counter)
				assert_same_digest (Plain_text, output_path, "5ivDTBX6P3UiElIR0O3KBw==")
				assert ("132 items", counter.item = 132)
			end
			create last_line.make_empty
			across File.plain_text_lines (header_path) as line loop
				if line.is_last then
					last_line := line.item
				end
			end
			assert ("last line OK", last_line.ends_with ("/* State not recoverable */"))
		end

feature {NONE} -- Implementation

	error_codes_path: FILE_PATH
		do
			Result := Dev_environ.El_test_data_dir + "code/C/unix/error-codes.h"
		end

	error_table_path: FILE_PATH
		do
			Result := Work_area_dir + error_codes_path.base
			Result.replace_extension ("txt")
		end

	write_indented_codes (
		output_path: FILE_PATH; file_lines: ITERABLE [STRING_GENERAL]; counter: EL_NATURAL_32_COUNTER
	)
		local
			description, part, code: STRING; s: EL_STRING_8_ROUTINES
		do
			if attached open (output_path, Write) as output then
				output.set_latin_encoding (1)
				across file_lines as line loop
					across s.delimited_list (line.item.to_string_8, C_comment_mark) as list loop
						part := list.item
						if part.count > 0 then
							part.adjust
							if list.cursor_index = 1 then
								code := super_8 (part).substring_to_reversed ('%T')
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
						output.put_string_8 (description)
					end
					counter.bump
				end
				output.close
			end
		end

feature {NONE} -- Constants

	C_comment_mark: ZSTRING
		once
			Result := "/*"
		end

end