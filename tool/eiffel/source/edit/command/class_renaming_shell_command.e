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
	date: "2023-12-22 15:43:41 GMT (Friday 22nd December 2023)"
	revision: "8"

class
	CLASS_RENAMING_SHELL_COMMAND

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell,
			user_exit as user_exit_shell
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

	remove_prefix
		do
			prefix_letters := User_input.line ("Enter prefix to remove")
			prefix_letters.to_upper
			lio.put_new_line
			loop_until_quit
		end

	rename_classes
		do
			prefix_letters.wipe_out
			loop_until_quit
		end

	rename_text_process_library
		local
			command: CLASS_RENAMING_COMMAND; l_prefix: STRING
			suffix_table: EL_HASH_TABLE [STRING, STRING]
		do
			create suffix_table.make (<<
				["_TEXT_PATTERN", "_PATTERN"],
				["_TEXT_PATTERN_FACTORY", "_FACTORY"],
				["_PATTERN_FACTORY", "_FACTORY"],
				["_CHARACTER", "_CHAR"]
			>>)
			across manifest.source_tree_list as tree loop
				across tree.item.path_list as list loop
					if list.item.parent.has_step ("pattern") then
						old_name.wipe_out
						list.item.base_name.append_to_string_8 (old_name)
						old_name.to_upper
						new_name := old_name.twin

						l_prefix := "EL_MATCH_"
						if new_name.starts_with (l_prefix) then
							new_name.replace_substring ("TP_", 1, l_prefix.count)
						else
							new_name.replace_substring ("TP", 1, 2)
						end
						if new_name.ends_with ("_TP") then
							new_name.remove_tail (3)
						end
						new_name.replace_substring_all ("_STRING_8_", "_RSTRING_")
						across suffix_table as table loop
							if new_name.ends_with (table.key) then
								new_name.remove_tail (table.key.count)
								new_name.append (table.item)
							end
						end
						lio.put_line (new_name)
						create command.make (manifest, old_name, new_name)
						command.execute
					end
				end
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		do
		end

	loop_until_quit
		local
			command: CLASS_RENAMING_COMMAND; eiffel: EL_EIFFEL_SOURCE_ROUTINES
		do
			new_name.wipe_out
			-- run in a loop
			from user_quit := False until user_quit loop
				if eiffel.is_class_name (new_name) then
					create command.make (manifest, old_name, new_name)
					command.execute
				else
					lio.put_labeled_string ("Invalid class name", new_name)
					lio.put_new_line
				end
				set_class_names
			end
		end

	set_class_names
		local
			input: EL_USER_INPUT_VALUE [FILE_PATH]; class_path: FILE_PATH
			base_name: STRING
		do
			lio.put_new_line
			lio.put_line (User_input.Esc_to_quit)
			create input.make ("Drag and drop class file")
			class_path := input.value
			if input.escape_pressed then
				user_quit := True
			else
				base_name := class_path.base
				base_name.adjust
				old_name := class_path.base_name.as_upper
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
					if User_input.escape_pressed then
						user_quit := True
					else
						new_name.adjust
					end
				end
				lio.put_new_line
			end
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Rename classes",		agent rename_classes],
				["Remove prefix",			agent remove_prefix],
				["Rename text-process",	agent rename_text_process_library]
			>>)
		end

feature {NONE} -- Internal attributes

	new_name: STRING

	old_name: STRING

	prefix_letters: STRING

	user_quit: BOOLEAN

end