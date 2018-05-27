﻿note
	description: "Module crc 32 test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MODULE_CRC_32_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		end

	EL_MODULE_CRC_32
		undefine
			default_create
		end

feature -- Access

	test_file_crc
		local
			file_out: EL_PLAIN_TEXT_FILE; file_path: EL_FILE_PATH
		do
			file_path := Work_area_dir + "data.txt"
			create file_out.make_open_write (file_path)
			file_out.put_lines (Strings)
			file_out.close

			assert ("same crc", Crc_32.utf_8_file_lines (file_path) = Crc_32.lines (Strings))
		end

feature {NONE} -- Constants

	Strings: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< "Data privacy", "Data imports", "Data backups" >>)
		end
end
