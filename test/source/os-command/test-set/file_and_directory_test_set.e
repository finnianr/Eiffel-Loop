note
	description: "Test set for classes that manage and read file system content"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-26 17:20:46 GMT (Friday 26th April 2024)"
	revision: "43"

class
	FILE_AND_DIRECTORY_TEST_SET

inherit
	HELP_PAGES_TEST_SET

	EL_MODULE_COMMAND; EL_MODULE_EXECUTABLE; EL_MODULE_OS

	EL_GVFS_ROUTINES

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["delete_content_with_action",  agent test_delete_content_with_action],
				["delete_paths",					  agent test_delete_paths],
				["delete_with_action",			  agent test_delete_with_action],
				["dir_tree_delete",				  agent test_dir_tree_delete],
				["directory_content_processor", agent test_directory_content_processor],
				["directory_info",				  agent test_directory_info],
				["file_move_and_copy",			  agent test_file_move_and_copy],
				["file_move_and_copy_absolute", agent test_file_move_and_copy_absolute],
				["find_directories",				  agent test_find_directories],
				["find_directories_absolute",	  agent test_find_directories_absolute],
				["find_files",						  agent test_find_files],
				["find_files_absolute",			  agent test_find_files_absolute],
				["gio_virtual_file_system",	  agent test_gio_virtual_file_system],
				["read_directories",				  agent test_read_directories],
				["read_directory_files",		  agent test_read_directory_files],
				["search_path_list",				  agent test_search_path_list]
			>>)
		end

feature -- Tests

	test_delete_content_with_action
		local
			l_dir: EL_DIRECTORY; deleted_count: INTEGER_REF
			path_count: INTEGER
		do
			create deleted_count
			create l_dir.make (Workarea_help_pages_dir)
			path_count := l_dir.file_count (True) + l_dir.directory_count (True)
			l_dir.delete_content_with_action (agent on_files_deleted (?, deleted_count), Void, 5)
			assert ("all files deleted", path_count = deleted_count.item)
			assert ("tree exists", Workarea_help_pages_dir.exists)
			assert ("is_empty", l_dir.is_empty)
		end

	test_delete_paths
		note
			testing: "covers/{EL_HASH_SET}.subset_exclude"
		local
			a_file_set: like file_set
		do
			a_file_set := file_set.subset_exclude (agent path_contains (?, Help_pages_bcd_dir))
			a_file_set := a_file_set.subset_exclude (agent path_contains (?, Help_pages_wireless_notes_path))
			Command.new_delete_file (Work_area_dir + Help_pages_wireless_notes_path).execute
			Command.new_delete_tree (work_area_path (Help_pages_bcd_dir)).execute

			execute_and_assert (all_files_cmd (Work_area_dir), a_file_set)
		end

	test_delete_with_action
		local
			l_dir: EL_DIRECTORY; deleted_count: INTEGER_REF; path_count: INTEGER
		do
			create deleted_count
			create l_dir.make (Workarea_help_pages_dir)
			path_count := l_dir.file_count (True) + l_dir.directory_count (True) + 1
			l_dir.delete_with_action (agent on_files_deleted (?, deleted_count), Void, 5)
			assert ("all files deleted", path_count = deleted_count.item)
			assert ("not tree exists", not Workarea_help_pages_dir.exists)
		end

	test_dir_tree_delete
		local
			help_dir: DIR_PATH
		do
			help_dir := work_area_path (help_pages_dir)
			OS.delete_tree (help_dir)
			assert ("no longer exists", not help_dir.exists)
		end

	test_directory_content_processor
		-- FILE_AND_DIRECTORY_TEST_SET.test_directory_content_processor
		note
			testing: "[
				covers/{EL_FILE_OPERATION}.new_file_list,
				covers/{EL_DIRECTORY_CONTENT_PROCESSOR}.do_with
			]"
		local
			os_processor: EL_NATIVE_DIRECTORY_CONTENT_PROCESSOR
			processor: EL_DIRECTORY_CONTENT_PROCESSOR; text_set: EL_HASH_SET [FILE_PATH]
			output_dir: DIR_PATH; relative_set: like new_file_set
		do
			output_dir := Workarea_help_pages_dir #+ "output"
			relative_set := new_file_set (False)
			create processor.make (Workarea_help_pages_dir, output_dir)
			create os_processor.make (Workarea_help_pages_dir, output_dir)

			across << "*.txt", "bcd*", "*setup*", "*error.txt" >> as wildcard loop
				across << processor, os_processor >> as list loop
					create text_set.make (20)
					list.item.do_all (agent add_to_set (? ,?, text_set), wildcard.item)
					inspect wildcard.cursor_index
						when 1 then
							assert ("same sets", text_set ~ relative_set)
						when 2 then
							assert ("same sets", text_set ~ relative_set.subset_include (agent base_starts_with (?, "bcd")))
						when 3 then
							assert ("same sets", text_set ~ relative_set.subset_include (agent base_contains (?, "setup")))
						when 4 then
							assert ("same sets", text_set ~ relative_set.subset_include (agent base_ends_with (?, "error.txt")))
					end
				end
			end
		end

	test_directory_info
		local
			directory_info_cmd: like Command.new_directory_info
		do
			directory_info_cmd := Command.new_directory_info (Work_area_dir)
			assert ("same file count", directory_info_cmd.file_count = file_set.count)
			assert ("same total bytes", directory_info_cmd.size = total_file_size)
		end

	test_file_move_and_copy
		do
			file_move_and_copy (new_file_set (False), Work_area_dir)
		end

	test_file_move_and_copy_absolute
		-- FILE_AND_DIRECTORY_TEST_SET.test_file_move_and_copy_absolute
		do
			file_move_and_copy (new_file_set (True), Work_area_absolute_dir)
		end

	test_find_directories
		do
			find_directories (new_dir_set (False), Work_area_dir)
		end

	test_find_directories_absolute
		do
			find_directories (new_dir_set (True), Work_area_absolute_dir)
		end

	test_find_files
		do
			find_files (new_file_set (False), Work_area_dir)
		end

	test_find_files_absolute
		do
			find_files (new_file_set (True), Work_area_absolute_dir)
		end

	test_gio_virtual_file_system
		-- FILE_AND_DIRECTORY_TEST_SET.test_gio_virtual_file_system
		do
			if {PLATFORM}.is_unix then
				test_unix_gio_virtual_file_system
			end
		end

	test_read_directories
		local
			l_dir: EL_DIRECTORY;  dir_path: DIR_PATH
		do
			dir_path := work_area_path (Help_pages_windows_dir)
			create l_dir.make (dir_path)
			if attached OS.find_directories_command (dir_path) as cmd then
				cmd.set_depth (1, 1)
				cmd.execute
				cmd.set_default_depths
				assert_same_entries (l_dir.directories, cmd.path_list)
			end

			-- Recursively
			dir_path := Work_area_dir
			l_dir.make (dir_path)
			if attached OS.find_directories_command (dir_path) as cmd then
				cmd.set_min_depth (1)
				cmd.execute
				cmd.set_default_depths
				assert_same_entries (l_dir.recursive_directories, cmd.path_list)
			end
		end

	test_read_directory_files
		local
			l_dir: EL_DIRECTORY; dir_path: DIR_PATH
		do
			dir_path := work_area_path (Help_pages_windows_dir)

			create l_dir.make (dir_path)
			if attached OS.find_files_command (dir_path, "*") as cmd then
				cmd.set_depth (1, 1)
				cmd.execute
				cmd.set_default_depths
				assert_same_entries (l_dir.files, cmd.path_list)
			end

			dir_path := Work_area_dir
			l_dir.make (dir_path)
			if attached OS.find_files_command (dir_path, "*") as cmd then
				cmd.execute
				assert_same_entries (l_dir.recursive_files, cmd.path_list)
			end

			if attached OS.find_files_command (dir_path, "*.text") as cmd then
				cmd.execute
				assert_same_entries (l_dir.recursive_files_with_extension ("text"), cmd.path_list)
			end
		end

	test_search_path_list
		do
			assert ("has estudio", Executable.search_path_has ("estudio"))
		end

feature {NONE} -- Events

	on_files_deleted (list: LIST [EL_PATH]; deleted_count: INTEGER_REF)
		do
			deleted_count.set_item (list.count + deleted_count)
		end

feature {NONE} -- Filters

	base_contains (path: FILE_PATH; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := path.base.has_substring (str)
		end

	base_ends_with (path: FILE_PATH; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := path.base.ends_with_general (str)
		end

	base_starts_with (path: FILE_PATH; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := path.base.starts_with_general (str)
		end

	directory_path_contains (path: DIR_PATH; str: ZSTRING): BOOLEAN
		do
			Result := path.to_string.has_substring (str)
		end

	directory_within_depth (dir_path, path: DIR_PATH; interval: INTEGER_INTERVAL): BOOLEAN
		do
			if dir_path ~ path then
				Result := interval.has (0)
			else
				Result := interval.has (path.relative_path (dir_path).step_count)
			end
		end

	file_within_depth (dir_path: DIR_PATH; path: FILE_PATH; interval: INTEGER_INTERVAL): BOOLEAN
		do
			Result := interval.has (path.relative_path (dir_path).step_count)
		end

	path_contains (path: FILE_PATH; str: ZSTRING): BOOLEAN
		do
			Result := path.to_string.has_substring (str)
		end

	path_has_substring (path, substring: ZSTRING): BOOLEAN
		do
			Result := path.has_substring (substring)
		end

feature {NONE} -- Implementation

	add_to_set (input_file_path, output_file_path: FILE_PATH; a_set: EL_HASH_SET [FILE_PATH])
		local
			relative_path: FILE_PATH
		do
			relative_path := output_file_path.relative_path (Workarea_help_pages_dir #+ "output")
			a_set.put (Workarea_help_pages_dir + relative_path)
		end

	all_files_cmd (dir_path: DIR_PATH): like OS.find_files_command
		do
			Result := OS.find_files_command (dir_path, "*")
		end

	assert_same_entries (entries_1, entries_2: LIST [EL_PATH])
		do
			entries_1.compare_objects; entries_2.compare_objects
			if False then
				across << entries_1, entries_2 >> as entries loop
					lio.put_integer_field ("entries", entries.cursor_index)
					lio.put_new_line
					across entries.item as entry loop
						lio.put_index_labeled_string (entry.cursor_index, "entry ", entry.item.to_string)
						lio.put_new_line
					end
				end
				lio.put_new_line
			end
			assert ("same count", entries_1.count = entries_2.count)
			assert ("all 1st in 2nd", across entries_1 as entry all entries_2.has (entry.item) end)
			assert ("all 2nd in 1st", across entries_2 as entry all entries_1.has (entry.item) end)
		end

	execute_all (commands: ARRAY [EL_COMMAND])
		do
			commands.do_all (agent {EL_COMMAND}.execute)
		end

	execute_and_assert (find_cmd: EL_FIND_COMMAND_I; a_path_set: EL_HASH_SET [EL_PATH])
		local
			l_path: EL_PATH; has_member: BOOLEAN
		do
			find_cmd.execute
			if False then
				if not find_cmd.limitless_max_depth then
					lio.put_integer_interval_field ("Depth", find_cmd.min_depth |..| find_cmd.max_depth)
					lio.put_new_line
				end
				lio.put_integer_field (a_path_set.generator, a_path_set.count)
				lio.put_new_line
				from a_path_set.start until a_path_set.after loop
					lio.put_path_field ("a_path_set", a_path_set.iteration_item)
					lio.put_new_line
					a_path_set.forth
				end
				lio.put_integer_field (find_cmd.generator, find_cmd.path_list.count)
				lio.put_new_line
				across find_cmd.path_list as path loop
					l_path := path.item
					lio.put_path_field ("path_list", l_path)
					lio.put_new_line
					assert ("set has member", a_path_set.has (l_path))
				end
				lio.put_new_line
			end
			across find_cmd.path_list as path loop
				has_member := a_path_set.has (path.item)
				if not has_member then
					lio.put_path_field ("missing", path.item)
					lio.put_new_line
				end
				assert ("same set members", has_member)
			end
			assert ("same set count", find_cmd.path_list.count = a_path_set.count)
		end

	file_move_and_copy (a_file_set: like new_file_set; dir_path: DIR_PATH)
		local
			copy_file_cmd: like Command.new_copy_file
			mint_copy_dir: DIR_PATH; steps: TUPLE
			mint_copy_path: FILE_PATH
		do
			a_file_set.put (dir_path + Wireless_notes_path_copy)
			mint_copy_dir := Help_pages_mint_dir #+ "copy"
			a_file_set.put (dir_path + mint_copy_dir.plus (Help_pages_wireless_notes_path.base))

			a_file_set.prune (dir_path + Help_pages_wireless_notes_path)
			a_file_set.put (dir_path + (Help_pages_mint_docs_dir + Help_pages_wireless_notes_path.base))

			across file_set as path loop
				if path.item.parent.base ~ Docs then
					steps := [Docs, path.item.base]
					mint_copy_path := (dir_path #+ mint_copy_dir).joined_file_tuple (steps)
					a_file_set.put (mint_copy_path)
				end
			end
			execute_all (<<
				Command.new_copy_file (dir_path + Help_pages_wireless_notes_path, dir_path + Wireless_notes_path_copy),
				Command.new_make_directory (dir_path #+ mint_copy_dir),
				Command.new_copy_file (dir_path + Help_pages_wireless_notes_path, dir_path #+ mint_copy_dir),
				Command.new_copy_tree (dir_path #+ Help_pages_mint_docs_dir, dir_path #+ mint_copy_dir),
				Command.new_move_file (dir_path + Help_pages_wireless_notes_path, dir_path #+ Help_pages_mint_docs_dir)
			>>)

			execute_and_assert (all_files_cmd (dir_path), a_file_set)
		end

	find_directories (a_dir_set: like dir_set; root_dir: DIR_PATH)
		note
			testing: "covers/{EL_HASH_SET}.subset_include"
		local
			lower, upper: INTEGER; has_substring: EL_PREDICATE_FIND_CONDITION
		do
			a_dir_set.put (root_dir)
			if attached OS.find_directories_command (root_dir) as cmd then

				execute_and_assert (cmd, a_dir_set)

				has_substring := agent path_has_substring (?, "bcd")
				cmd.set_filter (not has_substring)
				execute_and_assert (cmd, a_dir_set.subset_exclude (agent directory_path_contains (?, "bcd")))
				cmd.set_default_filter

	--			Test with restricted depth
				from upper := 1 until upper > 3 loop
					from lower := 0 until lower > upper loop
						cmd.set_depth (lower, upper)
						execute_and_assert (
							cmd, a_dir_set.subset_include (agent directory_within_depth (root_dir, ?, lower |..| upper))
						)
						cmd.set_default_depths
						lower := lower + 1
					end
					upper := upper + 1
				end
			end
		end

	find_files (a_file_set: like new_file_set; root_dir: DIR_PATH)
		note
			testing: "covers/{EL_HASH_SET}.subset_include"
		local
			lower, upper: INTEGER
		do
			if attached OS.find_files_command (root_dir, "*") as cmd then
				execute_and_assert (cmd, a_file_set)

				cmd.set_predicate_filter (agent path_has_substring (?, "bcd"))
				execute_and_assert (cmd, a_file_set.subset_include (agent path_contains (?, "bcd")))
				cmd.set_default_filter

	--			Test depth
				from upper := 3 until upper > 4 loop
					from lower := 1 until lower > upper loop
						cmd.set_depth (lower, upper)
						execute_and_assert (
							cmd, a_file_set.subset_include (agent file_within_depth (root_dir, ?, lower |..| upper))
						)
						cmd.set_default_depths
						lower := lower + 1
					end
					upper := upper + 1
				end
			end
		end

	test_unix_gio_virtual_file_system
		local
			mount_table: like new_uri_table; volume: EL_GVFS_VOLUME
			found_volume: BOOLEAN; a_file_set: like new_file_set; file_path_string, volume_name: ZSTRING
			volume_root_path, volume_workarea_dir, volume_workarea_copy_dir, volume_destination_dir: DIR_PATH
			relative_file_path: FILE_PATH
		do
			a_file_set := new_file_set (True); a_file_set.start
			across new_uri_table as root until found_volume loop
				lio.put_labeled_string (root.key, root.item)
				lio.put_new_line
				if root.item.scheme ~ File_protocol then
					create file_path_string.make_from_general (root.item)
					file_path_string.remove_head (File_protocol.count + 3)
					if a_file_set.iteration_item.to_string.starts_with (file_path_string) then
						volume_name := root.key
						volume_root_path := file_path_string
						volume_workarea_dir := Work_area_absolute_dir.relative_path (volume_root_path)
						found_volume := True
					end
				end
			end
			lio.put_labeled_string ("volume_name", volume_name)
			lio.put_new_line
			create volume.make (volume_name, False)
			volume_workarea_copy_dir := volume_workarea_dir #+ "copy"
			volume.make_directory (volume_workarea_copy_dir)
			across file_set as path loop
				relative_file_path := path.item.relative_path (Work_area_dir)
				volume_destination_dir := volume_workarea_copy_dir #+ relative_file_path.parent
				volume.make_directory (volume_destination_dir)
				volume.copy_file_from (
					volume_workarea_dir + relative_file_path, volume_root_path #+ volume_destination_dir
				)
				a_file_set.put (volume_root_path + (volume_destination_dir + relative_file_path.base))
			end
			execute_and_assert (OS.find_files_command (Work_area_absolute_dir, "*"), a_file_set)
		end

feature {NONE} -- Constants

	File_protocol: ZSTRING
		once
			Result := "file"
		end

	Wireless_notes_path_copy: FILE_PATH
		once
			Result := Help_pages_wireless_notes_path.without_extension
			Result.set_base (Result.base + " (copy).txt")
		end
end