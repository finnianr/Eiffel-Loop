note
	description: "Localization command shell test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 12:41:29 GMT (Monday 18th January 2021)"
	revision: "7"

class
	LOCALIZATION_COMMAND_SHELL_TEST_SET

inherit
	EL_TEST_DATA_TEST_SET

	EL_MODULE_LOG

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
			log.enter ("test_add_unchecked")
			create shell.make (work_dir)
			shell.add_check_attribute

			create list.make_empty
			shell.file_list.do_all (agent shell.add_unchecked ("de", ?))
			across shell.unchecked_translations as unchecked loop
				list.append (unchecked.item)
			end
			assert ("Same set", list.count = Unchecked_de_list.count and then list.for_all (agent Unchecked_de_list.has))
			log.exit
		end

feature {NONE} -- Constants

	Relative_dir: EL_DIR_PATH
		once
			Result := "pyxis/localization"
		end

	Unchecked_de_list: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<<
				"{credits}", {STRING_32} "{€}", "Enter a passphrase"
			>>)
		end

end