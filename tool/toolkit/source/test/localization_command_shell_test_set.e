note
	description: "Localization command shell test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-15 10:32:27 GMT (Friday 15th November 2024)"
	revision: "16"

class
	LOCALIZATION_COMMAND_SHELL_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["add_unchecked", agent test_add_unchecked]
			>>)
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
			Result := Dev_environ.EL_test_data_dir #+ "pyxis/localization"
		end

	Unchecked_de_list: EL_ZSTRING_LIST
		once
			Result := {STRING_32} "{credits}, {€}, {taoistiching}, Enter a passphrase"
		end

end