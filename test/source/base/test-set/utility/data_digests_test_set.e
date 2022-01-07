﻿note
	description: "Test various ways of creating data digests include CRC-32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-05 12:35:52 GMT (Wednesday 5th January 2022)"
	revision: "19"

class
	DATA_DIGESTS_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_MODULE_CHECKSUM

	EL_MODULE_DIGEST

	EL_FILE_OPEN_ROUTINES

	EL_TEST_STRINGS

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("file_crc_32", agent test_file_crc_32)
			evaluator.call ("md5_128", agent test_md5_128)
		end

feature -- Tests

	test_file_crc_32
		note
			testing: "covers/{EL_CRC_32_CHECKSUM_ROUTINES}.utf_8_file_content",
						"covers/{EL_CRC_32_CHECKSUM_ROUTINES}.string_list",
						"covers/{EL_PLAIN_TEXT_LINE_SOURCE}.start" -- when file is closed
		local
			file_path: FILE_PATH
		do
			file_path := Work_area_dir + "data.txt"
			if attached open (file_path, Write) as file_out then
				file_out.put_lines (Data_lines)
				file_out.close
			end
			assert ("same crc", Checksum.utf_8_file_content (file_path) = Checksum.string_list (Data_lines))

			-- if file is closed
			assert ("zero", Checksum.utf_8_file_content ("no such file.txt") = 0)
		end

	test_md5_128
		note
			testing: "covers/{EL_DATA_SINKABLE}.sink_string_8",
						"covers/{EL_DATA_SINKABLE}.sink_string",
						"covers/{EL_DATA_SINKABLE}.sink_character_array"
		local
			str_8: STRING; zstr: ZSTRING; md5: EL_MD5_128
		do
			zstr := Text_russian_and_english
			create md5.make
			md5.sink_string (zstr)
			assert ("correct SHA-256", md5.digest_base_64 ~ "tGC3tVpZNZJKAxI/WFqDAg==")

			str_8 := text_lines [2]
			assert ("correct line", str_8.starts_with ("Wanting"))
			md5.reset
			md5.sink_string_8 (str_8)
			assert ("correct SHA-256", md5.digest_base_64 ~ "KgHgTIwmLrcVEKchvY+zRg==")
		end

feature {NONE} -- Constants

	Data_lines: EL_ZSTRING_LIST
		once
			Result := "Data privacy, Data imports, Data backups"
		end
end