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
	date: "2025-04-15 9:30:41 GMT (Tuesday 15th April 2025)"
	revision: "14"

class
	CLASS_RENAMING_COMMAND_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell,
			user_exit as user_exit_shell
		undefine
			error_check, make_default
		end

	SOURCE_MANIFEST_COMMAND
		undefine
			execute
		redefine
			make_from_manifest, make_default
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make_from_manifest (a_manifest: SOURCE_MANIFEST)
		do
			make_shell ("RENAME MENU", 10)
			manifest := a_manifest
		end

	make_default
		do
			Precursor {SOURCE_MANIFEST_COMMAND}
			create new_name.make_empty
			create prefix_letters.make_empty
			create old_name.make_empty
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

	rename_suffix_prefix
		local
			command: CLASS_RENAMING_COMMAND; old_pattern, new_pattern: ZSTRING
			suffix_count, prefix_count: INTEGER; break: BOOLEAN
		do
			old_pattern := User_input.line ("Enter class suffix/prefix pattern (Eg. *_IMPLEMENTATION)")
			old_pattern.to_lower
			if not User_input.escape_pressed then
				new_pattern := User_input.line ("Enter replacement pattern (Eg. *_BASE)")
				new_pattern.to_lower
			end
			if User_input.escape_pressed then
				do_nothing

			elseif not (old_pattern.occurrences ('*') = 1 and new_pattern.occurrences ('*') = 1) then
				lio.put_labeled_string (Invalid_pattern, "Each must start or end with a '*' wildcard")
				lio.put_new_line

			elseif old_pattern.starts_with_character ('*') then
				if new_pattern.starts_with_character ('*') then
					suffix_count := old_pattern.count - 1
				else
					lio.put_labeled_string (Invalid_pattern, "Suffix replacement must start with '*' wildcard")
					lio.put_new_line
				end

			elseif old_pattern.ends_with_character ('*')  then
				if new_pattern.ends_with_character ('*') then
					prefix_count := old_pattern.count - 1
				else
					lio.put_labeled_string (Invalid_pattern, "Prefix replacement must end with '*' wildcard")
					lio.put_new_line
				end
			end
			if suffix_count > 0 or prefix_count > 0 then
				read_manifest_files
				across manifest.source_tree_list as tree until break loop
					across tree.item.path_list as list until break loop
						if attached list.item.base_name as base_name and then base_name.matches_wildcard (old_pattern) then
							old_name.wipe_out
							base_name.append_to_string_8 (old_name)
							old_name.to_upper
							new_name := old_name.twin

							if suffix_count > 0 then
								new_name.remove_tail (suffix_count)
								if new_pattern.count >= 2 then
									new_name.append_substring (new_pattern.to_latin_1, 2, new_pattern.count)
								end

							elseif prefix_count > 0 then
								new_name.remove_head (prefix_count)
								if new_pattern.count - 1 >= 1 then
									new_name.prepend_substring (new_pattern.to_latin_1, 1, new_pattern.count - 1)
								end
							end
							new_name.to_upper
							if User_input.approved_action_y_n (Rename_prompt #$ [old_name, new_name]) then
								if User_input.escape_pressed then
									break := True
								else
									create command.make (manifest, old_name, new_name)
									command.execute
								end
							end
						end
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
						lio.put_labeled_string ("Invalid_pattern", "Class name does not start with " + prefix_letters)
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
			create Result.make_assignments (<<
				["Rename classes",		 agent rename_classes],
				["Remove prefix",			 agent remove_prefix],
				["Rename suffix/prefix", agent rename_suffix_prefix]
			>>)
		end

feature {NONE} -- Internal attributes

	new_name: STRING

	old_name: STRING

	prefix_letters: STRING

	user_quit: BOOLEAN

feature {NONE} -- Constants

	Invalid_pattern: STRING = "Invalid pattern"

	Rename_prompt: ZSTRING
		once
			Result := "Rename %S as %S"
		end
end