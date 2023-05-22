note
	description: "OS command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-21 15:46:07 GMT (Sunday 21st May 2023)"
	revision: "25"

class
	OS_COMMAND_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
			>>)
		end

feature -- Tests

	test_cpu_info
		do
			assert ("two fields", count = 2)
		end

	test_create_tar_command
		do
			assert ("created", tar_path.exists)
		end

	test_file_md5_sum
		do
			assert_same_string (Void, Digest.md5_plain_text (help_path).to_hex_string, str)
		end

	test_user_list
		do
			assert ("path exists", list.item.exists)
		end

end
