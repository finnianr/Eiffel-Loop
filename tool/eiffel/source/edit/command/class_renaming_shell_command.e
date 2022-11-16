note
	description: "Command shell for renaming classes defined in a source tree manifest"
	notes: "[
		Shell Menu
		
		1. Rename classes
		2. Remove prefix
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	CLASS_RENAMING_SHELL_COMMAND

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		undefine
			error_check
		end

	SOURCE_MANIFEST_COMMAND
		undefine
			execute
		redefine
			make_default
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor
			create new_name.make_empty
			create prefix_letters.make_empty
			create old_name.make_empty
			make_shell ("RENAME MENU", 10)
		end

feature -- Constants

	Description: STRING = "Command shell for renaming classes defined in a source tree manifest"

feature {NONE} -- Commands

	rename_classes
		do
			prefix_letters.wipe_out
			loop_until_quit
		end

	remove_prefix
		do
			prefix_letters := User_input.line ("Enter prefix to remove")
			prefix_letters.to_upper
			lio.put_new_line
			loop_until_quit
		end

feature {NONE} -- Implementation

	loop_until_quit
		local
			command: CLASS_RENAMING_COMMAND
		do
			new_name.wipe_out
			-- run in a loop
			from user_quit := False until user_quit loop
				if new_name.count > 0 then
					create command.make (manifest, old_name, new_name)
					command.execute
				end
				set_class_names
			end
		end

	do_with_file (source_path: FILE_PATH)
		do
		end

	set_class_names
		local
			input: EL_USER_INPUT_VALUE [FILE_PATH]; class_path: FILE_PATH
		do
			lio.put_new_line
			lio.put_new_line
			create input.make ("Drag and drop class file")
			class_path := input.value
			if class_path.base.as_upper.is_equal ("QUIT") then
				user_quit := true
			else
				old_name := class_path.base_sans_extension.as_upper
				if prefix_letters.count > 0 then
					if old_name.starts_with (prefix_letters) then
						new_name := old_name.substring (prefix_letters.count + 1, old_name.count)
					else
						lio.put_labeled_string ("Error", "Class name does not start with " + prefix_letters)
						lio.put_new_line
						new_name.wipe_out
					end
				else
					new_name := User_input.line ("New class name")
					new_name.adjust
				end
				lio.put_new_line
			end
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Rename classes",	agent rename_classes],
				["Remove prefix", 	agent remove_prefix]
			>>)
		end

feature {NONE} -- Internal attributes

	user_quit: BOOLEAN

	new_name: STRING

	old_name: STRING

	prefix_letters: STRING

end