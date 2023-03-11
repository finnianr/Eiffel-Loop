note
	description: "Test class [$source UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 12:15:01 GMT (Friday 10th March 2023)"
	revision: "6"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["syntax_change", agent test_syntax_change]
			>>)
		end

feature -- Tests

	test_syntax_change
		local
			command: UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND
		do
			create command.make (Manifest_path)
			command.execute

			across file_list as path loop
				if path.item.base_matches ("el_application_mutex_impl", False) then
					assert_same_digest (path.item, "tD/I28G5sVUFFyGKMJ6Lew==")
				end
			end
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/latin-1/kernel"
		end

end