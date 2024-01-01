note
	description: "Microsoft COM object test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 17:59:55 GMT (Monday 1st January 2024)"
	revision: "1"

class
	COM_OBJECT_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_MODULE_EXECUTABLE

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["shell_link_persistence", agent test_shell_link_persistence]
			>>)
		end

feature -- Tests

	test_shell_link_persistence
		local
			link: COM_SHELL_LINK; link_path, icon_path: FILE_PATH; bin_dir: DIR_PATH
			description: ZSTRING; arguments: STRING
		do
			link_path := Work_area_absolute_dir + "el_test display version.lnk"
			bin_dir := Directory.current_working #+ "build/$ISE_PLATFORM/package/bin"
			bin_dir.expand
			description := "Euro currency symbol is: "
			description.append_character (Text.Euro_symbol)
			arguments := "-version -ask_user_to_quit"
			icon_path := Directory.current_working.parent + "doc/favicon.ico"

			create link.make
			link.set_target_path (bin_dir + Executable.name)
			link.set_arguments (arguments)
			link.set_icon ([icon_path, 1])
			link.set_description (description)
			link.save (link_path)

			if link_path.exists then
				create link.make_from_path (link_path)
				assert ("same target", link.target_path ~ bin_dir + Executable.name)
				assert ("same icon path", link.icon.file_path ~ icon_path)
				assert ("same icon number", link.icon.index = 1)

				assert_same_string ("same arguments", link.arguments, arguments)
				assert_same_string ("same description", link.description, description)

			else
				failed ("link created")
			end
		end

end