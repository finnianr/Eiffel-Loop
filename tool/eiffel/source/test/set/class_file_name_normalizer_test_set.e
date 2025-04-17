note
	description: "Test class ${CLASS_FILE_NAME_NORMALIZER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 8:48:09 GMT (Wednesday 16th April 2025)"
	revision: "9"

class
	CLASS_FILE_NAME_NORMALIZER_TEST_SET

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
				["renaming", agent test_renaming]
			>>)
		end

feature -- Tests

	test_renaming
		local
			command: CLASS_FILE_NAME_NORMALIZER; name: ZSTRING
		do
			create command.make (Manifest_path)
			command.execute
			assert ("renamed 6", command.renamed_table.count = 6)
			if attached OS.file_list (Work_area_dir, "*.e") as list then
				across command.renamed_table as table loop
					name := table.item
					list.find_first_base (name)
					assert ("renamed exists", list.found)
				end
				across command.renamed_table as table loop
					list.find_first_base (table.key)
					assert ("old name no longer exists", list.after)
				end
			end
		end

feature {NONE} -- Implementation

	sources_list: ARRAY [DIR_PATH]
		do
			Result := << Source.latin_1_dir #+ "os-command" >>
		end
end