note
	description: "Test class [$source CLASS_FILE_NAME_NORMALIZER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 11:30:31 GMT (Saturday 5th February 2022)"
	revision: "1"

class
	CLASS_FILE_NAME_NORMALIZER_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("renaming", agent test_renaming)
		end

feature -- Tests

	test_renaming
		local
			command: CLASS_FILE_NAME_NORMALIZER
		do
			create command.make (Manifest_path)
			command.execute
			assert ("renamed 6", command.renamed_table.count = 6)
			if attached OS.file_list (Work_area_dir, "*.e") as list then
				across command.renamed_table as table loop
					list.find_first_base (table.item)
					assert ("renamed exists", list.found)
				end
				across command.renamed_table as table loop
					list.find_first_base (table.key)
					assert ("old name no longer exists", list.after)
				end
			end
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/latin-1/os-command"
		end
end