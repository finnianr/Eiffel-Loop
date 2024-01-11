note
	description: "Test command classes [$source VCF_CONTACT_SPLITTER] and [$source VCF_CONTACT_NAME_SWITCHER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 15:19:28 GMT (Thursday 11th January 2024)"
	revision: "8"

class
	VCF_CONTACT_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_COMMAND; EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["splitter", agent test_splitter],
				["switcher", agent test_switcher]
			>>)
		end

feature -- Tests

	test_splitter
		local
			splitter: VCF_CONTACT_SPLITTER; count, index: INTEGER
			id, source_text, split_text: STRING
		do
			if attached file_list.first_path as contacts_path then
				source_text := File.plain_text (contacts_path)
				create splitter.make (contacts_path)
				splitter.execute
				across OS.file_list (Work_area_dir #+ "contacts", "*.vcf") as path loop
					split_text := File.plain_text (path.item)
					id := path.item.base_name
					index := split_text.substring_index (id, 1)
					assert ("id", index > 0)
					index := split_text.substring_index ("N:", index)
					assert ("has N:", index > 0)
					split_text.keep_head (index - 1)
					assert ("from source text", source_text.has_substring (split_text))

					count := count + 1
				end
				assert ("5 items", count = 5)
			end
		end

	test_switcher
		local
			switcher: VCF_CONTACT_NAME_SWITCHER; contacts_2_path: FILE_PATH
			last_name: STRING; s: EL_STRING_8_ROUTINES; count: INTEGER
		do
			create last_name.make_empty
			if attached file_list.first_path as contacts_path then
				create switcher.make (contacts_path)
				switcher.execute
				contacts_2_path := contacts_path.with_new_extension ("2.vcf")
				assert ("output generated", contacts_2_path.exists)
				across File.plain_text_lines (contacts_2_path) as line loop
					if line.item.starts_with ("N:") then
						last_name := s.substring_to (line.item, ';')
						last_name.remove_head (2)
					elseif line.item.starts_with ("FN:") then
						assert ("names reversed", line.item.ends_with (" " + last_name))
						count := count + 1
					end
				end
				assert ("5 items", count = 5)
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "contacts.vcf" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data"
		end

end