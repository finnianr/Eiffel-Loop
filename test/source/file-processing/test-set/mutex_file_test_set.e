note
	description: "Test [$source EL_LOCKABLE_TEXT_FILE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:33:28 GMT (Sunday 5th November 2023)"
	revision: "4"

class
	MUTEX_FILE_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["mutex_file",	agent test_mutex_file]
			>>)
		end

feature -- Tests

	test_mutex_file
		-- MUTEX_FILE_TEST_SET.test_mutex_file
		note
			testing: "[
				covers/{EL_LOCKABLE_TEXT_FILE}.try_lock,
				covers/{EL_LOCKABLE_TEXT_FILE}.unlock,
				covers/{EL_LOCKABLE_TEXT_FILE}.open_write,
				covers/{EL_LOCKABLE_TEXT_FILE}.close
			]"
		local
			l_file: EL_LOCKABLE_TEXT_FILE; file_path: FILE_PATH
			expected_list: EL_STRING_8_LIST
		do
			expected_list := "greetings, hello, one 1, two 2"

			across 1 |..| 2 as n loop
				across file_list as path loop
					file_path := path.item
					assert ("same lines", expected_list ~ new_lines (file_path))
					create l_file.make_open_write (file_path)
					l_file.try_lock
					assert ("locked", l_file.is_locked)
					inspect n.item
						when 1 then
						-- Check if content remains unchanged by just locking and unlocking
							do_nothing

						when 2 then
						-- Write content in reverse
							expected_list.sort (False) -- reverse content
							expected_list.remove_last
							l_file.wipe_out
							l_file.put_string (expected_list.joined_lines)

					end
					l_file.unlock
					assert ("unlocked", not l_file.is_locked)
					l_file.close
					assert ("same lines", expected_list ~ new_lines (file_path))
				end
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "file.txt" >>)
		end

	new_lines (file_path: FILE_PATH): EL_STRING_8_LIST
		do
			create Result.make_with_lines (File.plain_text (file_path))
			Result.prune_all_empty
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "data/txt"
		end
end