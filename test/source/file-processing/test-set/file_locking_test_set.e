note
	description: "Test file locking mutex classes"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-15 17:49:24 GMT (Thursday 15th August 2024)"
	revision: "6"

class
	FILE_LOCKING_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["lockable_text_file", agent test_lockable_text_file],
				["named_file_lock",	  agent test_named_file_lock]
			>>)
		end

feature -- Tests

	test_lockable_text_file
		-- MUTEX_FILE_TEST_SET.test_lockable_text_file
		note
			testing: "[
				covers/{EL_LOCKABLE_TEXT_FILE}.make,
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

	test_named_file_lock
		-- MUTEX_FILE_TEST_SET.test_named_file_lock
		note
			testing: "[
				covers/{EL_NAMED_FILE_LOCK}.try_lock,
				covers/{EL_NAMED_FILE_LOCK}.unlock,
				covers/{EL_NAMED_FILE_LOCK}.make
			]"
		local
			file_1, file_2: EL_NAMED_FILE_LOCK
		do
			create file_1.make (Work_area_dir + lock_name)
			file_1.try_lock
			assert ("file_1 is locked", file_1.is_locked)

			create file_2.make (Work_area_dir + lock_name)
			file_2.try_lock
			assert ("file_2 is not locked", not file_2.is_locked)

			file_1.unlock
			file_2.try_lock
			assert ("file_2 is locked", file_2.is_locked)
			file_2.unlock
		end

feature {NONE} -- Implementation

	new_lines (file_path: FILE_PATH): EL_STRING_8_LIST
		do
			create Result.make_with_lines (File.plain_text (file_path))
			Result.prune_all_empty
		end

	lock_name: STRING
		do
			Result := generator.as_lower + ".lock"
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "file.txt" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "data/txt"
		end
end