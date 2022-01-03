note
	description: "Module crc 32 test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "18"

class
	MODULE_CRC_32_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_MODULE_CHECKSUM

	EL_FILE_OPEN_ROUTINES

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("file_crc", agent test_file_crc)
			evaluator.call ("non_existing", agent test_non_existing)
		end

feature -- Tests

	test_file_crc
		note
			testing: "covers/{EL_CRC_32_CHECKSUM_ROUTINES}.utf_8_file_content",
						"covers/{EL_CRC_32_CHECKSUM_ROUTINES}.string_list"
		local
			file_path: FILE_PATH
		do
			file_path := Work_area_dir + "data.txt"
			if attached open (file_path, Write) as file_out then
				file_out.put_lines (Strings)
				file_out.close
			end
			assert ("same crc", Checksum.utf_8_file_content (file_path) = Checksum.string_list (Strings))
		end

	test_non_existing
		note
			testing: "covers/{EL_PLAIN_TEXT_LINE_SOURCE}.start" -- when file is closed
		do
			assert ("zero", Checksum.utf_8_file_content ("no such file.txt") = 0)
		end

feature {NONE} -- Constants

	Strings: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< "Data privacy", "Data imports", "Data backups" >>)
		end
end