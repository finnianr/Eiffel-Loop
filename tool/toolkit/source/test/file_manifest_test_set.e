note
	description: "Test [$source EL_FILE_MANIFEST_GENERATOR] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:43:45 GMT (Sunday 7th January 2024)"
	revision: "9"

class
	FILE_MANIFEST_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["file_manifest", agent test_file_manifest]
			>>)
		end

feature -- Tests

	test_file_manifest
		do
			test_with_template (work_area_data_dir, Empty_string)
			test_with_template (work_area_data_dir, "manifest-template.evol")
		end

feature {NONE} -- Implementation

	test_with_template (dir_path: DIR_PATH; template_name: ZSTRING)
		local
			template_path, output_path: FILE_PATH; manifest: EL_FILE_MANIFEST_LIST
			command: EL_FILE_MANIFEST_GENERATOR
		do
			if template_name.is_empty then
				create template_path
			else
				template_path := dir_path + template_name
			end
			output_path := dir_path + "manifest.xml"
			across 1 |..| 2 as n loop
				create command.make (template_path, output_path, dir_path, "bkup")
				inspect n.item
					when 1 then
						if template_name.is_empty then
							assert ("manifest.is_modified", command.manifest.is_modified)
						end
					when 2 then
						assert ("not manifest.is_modified", not command.manifest.is_modified)
				end
				command.execute
			end
			create manifest.make_from_file (output_path)
			if template_name.is_empty then
				assert ("same content", manifest ~ command.manifest)
			else
				assert_same_digest (Plain_text, output_path, "h+JTfAZXVugLmMokPnE4Hg==")
			end
		end

	source_dir: DIR_PATH
		do
			Result := "test-data/bkup"
		end
end