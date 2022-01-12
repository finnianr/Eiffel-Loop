note
	description: "Test command classes [$source VCF_CONTACT_SPLITTER] and [$source VCF_CONTACT_NAME_SWITCHER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-12 19:55:19 GMT (Wednesday 12th January 2022)"
	revision: "1"

class
	VCF_CONTACT_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_COMMAND

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("splitter", agent test_splitter)
			eval.call ("switcher", agent test_switcher)
		end

feature -- Tests

	test_splitter
		local
			splitter: VCF_CONTACT_SPLITTER; count, index: INTEGER
			id, source_text, split_text: STRING
		do
			if attached file_list.first_path as contacts_path then
				source_text := File_system.plain_text (contacts_path)
				create splitter.make (contacts_path)
				splitter.execute
				across OS.file_list (Work_area_dir #+ "contacts", "*.vcf") as path loop
					split_text := File_system.plain_text (path.item)
					id := path.item.base_sans_extension
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
			switcher: VCF_CONTACT_NAME_SWITCHER
		do
			if attached file_list.first_path as contacts_path then
--				source_text := File_system.plain_text (contacts_path)
				create switcher.make (contacts_path)
				switcher.execute
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