note
	description: "Module crc 32 test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 10:18:16 GMT (Friday 14th February 2020)"
	revision: "10"

class
	MODULE_CRC_32_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		end

	EL_MODULE_CHECKSUM

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
		end

feature -- Tests

	test_file_crc
		local
			file_out: EL_PLAIN_TEXT_FILE; file_path: EL_FILE_PATH
		do
			file_path := Work_area_dir + "data.txt"
			create file_out.make_open_write (file_path)
			file_out.put_lines (Strings)
			file_out.close

			assert ("same crc", Checksum.utf_8_file_content (file_path) = Checksum.string_list (Strings))
		end

feature {NONE} -- Constants

	Strings: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< "Data privacy", "Data imports", "Data backups" >>)
		end
end
