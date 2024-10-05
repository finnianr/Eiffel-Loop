note
	description: "Test class ${UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 10:57:20 GMT (Saturday 5th October 2024)"
	revision: "10"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		rename
			selected_files as no_selected_files
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["syntax_change",	agent test_syntax_change]
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
					assert_same_digest (Plain_text, path.item, "tD/I28G5sVUFFyGKMJ6Lew==")
				end
			end
		end

feature {NONE} -- Implementation

	sources_list: ARRAY [DIR_PATH]
		do
			Result := << Source.latin_1_dir #+ "kernel" >>
		end

end