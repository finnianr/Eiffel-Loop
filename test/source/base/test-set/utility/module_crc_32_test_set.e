note
	description: "Module crc 32 test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-06 8:10:15 GMT (Wednesday 6th May 2020)"
	revision: "14"

class
	MODULE_CRC_32_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		end

	EL_MODULE_CHECKSUM

	EL_FILE_OPEN_ROUTINES

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("file_crc", agent test_file_crc)
		end

feature -- Tests

	test_file_crc
		note
			testing: "covers/{EL_CRC_32_CHECKSUM_ROUTINES}.utf_8_file_content",
						"covers/{EL_CRC_32_CHECKSUM_ROUTINES}.string_list"
		local
			file_path: EL_FILE_PATH
		do
			file_path := Work_area_dir + "data.txt"
			if attached open (file_path, Write) as file_out then
				file_out.put_lines (Strings); close_open
			end
			assert ("same crc", Checksum.utf_8_file_content (file_path) = Checksum.string_list (Strings))
		ensure then
			files_closed: all_closed
		end

feature {NONE} -- Constants

	Strings: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< "Data privacy", "Data imports", "Data backups" >>)
		end
end
