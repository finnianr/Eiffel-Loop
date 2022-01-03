note
	description: "Localization command shell test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "10"

class
	LOCALIZATION_COMMAND_SHELL_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("add_unchecked", agent test_add_unchecked)
		end

feature -- Tests

	test_add_unchecked
		local
			shell: LOCALIZATION_COMMAND_SHELL; list: EL_ZSTRING_LIST
		do
			create shell.make (work_area_data_dir)
			shell.add_check_attribute

			create list.make_empty
			shell.file_list.do_all (agent shell.add_unchecked ("de", ?))
			across shell.unchecked_translations as unchecked loop
				list.append (unchecked.item)
			end
			assert ("Same set", list.count = Unchecked_de_list.count and then list.for_all (agent Unchecked_de_list.has))
		end

feature {NONE} -- Constants

	Source_dir: DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("pyxis/localization")
		end

	Unchecked_de_list: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<<
				"{credits}", {STRING_32} "{€}", "Enter a passphrase"
			>>)
		end

end