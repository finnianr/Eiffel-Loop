note
	description: "File command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	FILE_COMMAND_TEST_SET

inherit
	HELP_PAGES_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_COMMAND
		undefine
			default_create
		end

feature -- Tests

	test_gnome_virtual_file_system
		local
			mount_list_cmd: EL_GVFS_MOUNT_LIST_COMMAND; volume: EL_GVFS_VOLUME
			found_volume: BOOLEAN; l_file_set: like file_set_absolute; file_path_string, volume_name: ZSTRING
			volume_root_path, volume_workarea_dir, volume_workarea_copy_dir, volume_destination_dir: EL_DIR_PATH
			relative_file_path: EL_FILE_PATH
		do
			lio.enter ("test_gnome_virtual_file_system")
			l_file_set := file_set_absolute; l_file_set.start
			create mount_list_cmd.make
			mount_list_cmd.execute
			across mount_list_cmd.uri_root_table as root until found_volume loop
				lio.put_path_field (root.key, root.item)
				lio.put_new_line
				if root.item.protocol ~ File_protocol then
					file_path_string := root.item.to_string
					file_path_string.remove_head (File_protocol.count + 3)
					if l_file_set.item_for_iteration.to_string.starts_with (file_path_string) then
						volume_name := root.key
						volume_root_path := file_path_string
						volume_workarea_dir := Current_work_area_dir.relative_path (volume_root_path)
						found_volume := True
					end
				end
			end
			lio.put_labeled_string ("volume_name", volume_name)
			lio.put_new_line
			create volume.make_with_volume (volume_name, False)
			volume_workarea_copy_dir := volume_workarea_dir.joined_dir_path ("copy")
			volume.make_directory (volume_workarea_copy_dir)
			across file_set as path loop
				relative_file_path := path.item.relative_path (Work_area_dir)
				volume_destination_dir := volume_workarea_copy_dir.joined_dir_path (relative_file_path.parent)
				volume.make_directory (volume_destination_dir)
				volume.copy_file_from (
					volume_workarea_dir + relative_file_path, volume_root_path.joined_dir_path (volume_destination_dir)
				)
				l_file_set.put (volume_root_path + (volume_destination_dir + relative_file_path.base))
			end
			execute_and_assert (Command.new_find_files (Current_work_area_dir, "*"), l_file_set)
			lio.exit
		end

	test_relative_file_move_and_copy
		do
			lio.enter ("test_relative_file_move_and_copy")
			file_move_and_copy (True)
			lio.exit
		end

	test_absolute_file_move_and_copy
		do
			lio.enter ("test_absolute_file_move_and_copy")
			file_move_and_copy (False)
			lio.exit
		end

	test_delete_paths
		local
			l_file_set: like file_set
		do
			lio.enter ("delete_paths")
			l_file_set := file_set.subset_exclude (agent path_contains (?, Help_pages_bcd_dir))
			l_file_set := l_file_set.subset_exclude (agent path_contains (?, Wireless_notes_path))
			Command.new_delete_file (Work_area_dir + Wireless_notes_path).execute
			Command.new_delete_tree (Work_area_dir.joined_dir_path (Help_pages_bcd_dir)).execute

			execute_and_assert (all_files_cmd (Work_area_dir), l_file_set)

			lio.exit
		end

	test_directory_info
		local
			directory_info_cmd: like Command.new_directory_info
		do
			lio.enter ("test_directory_info")
			directory_info_cmd := Command.new_directory_info (Work_area_dir)
			assert ("same file count", directory_info_cmd.file_count = file_set.count)
			assert ("same total bytes", directory_info_cmd.size = total_file_size)
			lio.exit
		end

	test_find_directories
		do
			lio.enter ("test_find_directories")
			find_directories (True); find_directories (False)
			lio.exit
		end

	test_find_files
		do
			lio.enter ("test_find_files")
			find_files (True); find_files (False)
			lio.exit
		end

	test_search_path_list
		do
			lio.enter ("test_search_path_list")
			assert ("has estudio", Execution_environment.executable_search_list.has_executable ("estudio"))
			lio.exit
		end

	test_read_directories
		local
			l_dir: EL_DIRECTORY; find_directories_cmd: like Command.new_find_directories
			dir_path: EL_DIR_PATH
		do
			lio.enter ("test_read_directories")
			dir_path := Work_area_dir.joined_dir_path (Windows_dir)
			create l_dir.make (dir_path)
			find_directories_cmd := Command.new_find_directories (dir_path)
			find_directories_cmd.set_depth (1 |..| 1)
			find_directories_cmd.execute
			assert_same_entries (l_dir.directories, find_directories_cmd.path_list)

			-- Recursively
			dir_path := Work_area_dir
			l_dir.make (dir_path)
			find_directories_cmd := Command.new_find_directories (dir_path)
			find_directories_cmd.set_min_depth (1)
			find_directories_cmd.execute
			assert_same_entries (l_dir.recursive_directories, find_directories_cmd.path_list)

			lio.exit
		end

	test_read_directory_files
		local
			l_dir: EL_DIRECTORY; find_files_cmd: like Command.new_find_files
			dir_path: EL_DIR_PATH
		do
			lio.enter ("test_read_directory_files")
			dir_path := Work_area_dir.joined_dir_path (Windows_dir)

			create l_dir.make (dir_path)
			find_files_cmd := Command.new_find_files (dir_path, "*")
			find_files_cmd.set_depth (1 |..| 1)
			find_files_cmd.execute
			assert_same_entries (l_dir.files, find_files_cmd.path_list)

			dir_path := Work_area_dir
			l_dir.make (dir_path)
			find_files_cmd := Command.new_find_files (dir_path, "*")
			find_files_cmd.execute
			assert_same_entries (l_dir.recursive_files, find_files_cmd.path_list)

			find_files_cmd := Command.new_find_files (dir_path, "*.text")
			find_files_cmd.execute
			assert_same_entries (l_dir.recursive_files_with_extension ("text"), find_files_cmd.path_list)

			lio.exit
		end

feature {NONE} -- Events

	on_prepare
		local
			dir_path: EL_DIR_PATH
		do
			Precursor
			create dir_set.make_equal (file_set.count // 5)
			dir_set.put (Work_area_dir)
			across file_set as path loop
				from dir_path := path.item.parent until dir_set.has (dir_path) loop
					dir_set.put (dir_path)
					dir_path := dir_path.parent
				end
			end
		end

feature {NONE} -- Filters

	file_within_depth (dir_path: EL_DIR_PATH; path: EL_FILE_PATH; interval: INTEGER_INTERVAL): BOOLEAN
		do
			Result := interval.has (path.relative_path (dir_path).steps.count)
		end

	directory_within_depth (dir_path, path: EL_DIR_PATH; interval: INTEGER_INTERVAL): BOOLEAN
		do
			if dir_path ~ path then
				Result := interval.has (0)
			else
				Result := interval.has (path.relative_path (dir_path).steps.count)
			end
		end

	directory_path_contains (path: EL_DIR_PATH; str: ZSTRING): BOOLEAN
		do
			Result := path.to_string.has_substring (str)
		end

	path_contains (path: EL_FILE_PATH; str: ZSTRING): BOOLEAN
		do
			Result := path.to_string.has_substring (str)
		end

	path_has_substring (path, substring: ZSTRING): BOOLEAN
		do
			Result := path.has_substring (substring)
		end

feature {NONE} -- Implementation

	assert_same_entries (entries_1, entries_2: LIST [EL_PATH])
		do
			entries_1.compare_objects; entries_2.compare_objects
			if False then
				across << entries_1, entries_2 >> as entries loop
					lio.put_integer_field ("entries", entries.cursor_index)
					lio.put_new_line
					across entries.item as entry loop
						lio.put_path_field ("entry " + entry.cursor_index.out, entry.item)
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
			l_path: EL_PATH
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
					lio.put_path_field ("a_path_set", a_path_set.key_for_iteration)
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
			assert ("same set count", find_cmd.path_list.count = a_path_set.count)
			assert ("same set members", across find_cmd.path_list as path all a_path_set.has (path.item) end)
		end

	find_directories (use_relative_path: BOOLEAN)
		local
			find_directories_cmd: like Command.new_find_directories
			dir_path: EL_DIR_PATH; l_dir_set: like dir_set; lower, upper: INTEGER
		do
			if use_relative_path then
				lio.put_line ("Using relative paths")
				dir_path := Work_area_dir; l_dir_set := dir_set
			else
				lio.put_line ("Using absolute paths")
				dir_path := Current_work_area_dir; l_dir_set := dir_set_absolute
			end
			find_directories_cmd := Command.new_find_directories (dir_path)
			execute_and_assert (find_directories_cmd, l_dir_set)

			find_directories_cmd.set_not_path_included_condition (agent path_has_substring (?, "bcd"))
			execute_and_assert (find_directories_cmd, l_dir_set.subset_exclude (agent directory_path_contains (?, "bcd")))
			find_directories_cmd.set_any_path_included

--			Test with restricted depth
			from upper := 1 until upper > 3 loop
				from lower := 0 until lower > upper loop
					find_directories_cmd.set_depth (lower |..| upper)
					execute_and_assert (
						find_directories_cmd, l_dir_set.subset_include (agent directory_within_depth (dir_path, ?, lower |..| upper))
					)
					lower := lower + 1
				end
				upper := upper + 1
			end
		end

	find_files (use_relative_path: BOOLEAN)
		local
			find_files_cmd: like Command.new_find_files
			dir_path: EL_DIR_PATH; l_file_set: like file_set; lower, upper: INTEGER
		do
			if use_relative_path then
				lio.put_line ("Using relative paths")
				dir_path := Work_area_dir; l_file_set := file_set
			else
				lio.put_line ("Using absolute paths")
				dir_path := Current_work_area_dir; l_file_set := file_set_absolute
			end
			find_files_cmd := Command.new_find_files (dir_path, "*")
			execute_and_assert (find_files_cmd, l_file_set)

			find_files_cmd.set_not_path_included_condition (agent path_has_substring (?, "bcd"))
			execute_and_assert (find_files_cmd, l_file_set.subset_exclude (agent path_contains (?, "bcd")))
			find_files_cmd.set_any_path_included

--				Test depth
			from upper := 3 until upper > 4 loop
				from lower := 1 until lower > upper loop
					find_files_cmd.set_depth (lower |..| upper)
					execute_and_assert (find_files_cmd, l_file_set.subset_include (agent file_within_depth (dir_path, ?, lower |..| upper)))
					lower := lower + 1
				end
				upper := upper + 1
			end
		end

	file_move_and_copy (use_relative_paths: BOOLEAN)
		local
			copy_file_cmd: like Command.new_copy_file
			l_file_set: like file_set; mint_copy_dir, dir_path: EL_DIR_PATH
		do
			if use_relative_paths then
				l_file_set := new_file_set; dir_path := Work_area_dir
			else
				l_file_set := file_set_absolute; dir_path := Current_work_area_dir
			end
			l_file_set.put (dir_path + Wireless_notes_path_copy)
			mint_copy_dir := Help_pages_mint_dir.joined_dir_path ("copy")
			l_file_set.put (dir_path + mint_copy_dir.joined_file_path (Wireless_notes_path.base))

			l_file_set.remove (dir_path + Wireless_notes_path)
			l_file_set.put (dir_path + (Help_pages_mint_docs_dir + Wireless_notes_path.base))

			across new_file_tree [Help_pages_mint_docs_dir] as path loop
				l_file_set.put (dir_path.joined_dir_path (mint_copy_dir).joined_file_steps (<<
					{STRING_32} "docs", path.item.to_string_32
				>>))
			end
			execute_all (<<
				Command.new_copy_file (dir_path + Wireless_notes_path, dir_path + Wireless_notes_path_copy),
				Command.new_make_directory (dir_path.joined_dir_path (mint_copy_dir)),
				Command.new_copy_file (dir_path + Wireless_notes_path, dir_path.joined_dir_path (mint_copy_dir)),
				Command.new_copy_tree (
					dir_path.joined_dir_path (Help_pages_mint_docs_dir), dir_path.joined_dir_path (mint_copy_dir)
				),
				Command.new_move_file (dir_path + Wireless_notes_path, dir_path.joined_dir_path (Help_pages_mint_docs_dir))
			>>)

			execute_and_assert (all_files_cmd (dir_path), l_file_set)
		end

	dir_set_absolute: like dir_set
		do
			create Result.make_equal (dir_set.count)
			across dir_set as path loop
				Result.put (Directory.current_working.joined_dir_path (path.item))
			end
		end

	all_files_cmd (dir_path: EL_DIR_PATH): like Command.new_find_files
		do
			Result := Command.new_find_files (dir_path, "*")
		end

feature {NONE} -- Internal attributes

	dir_set: EL_HASH_SET [EL_DIR_PATH]

feature {NONE} -- Constants

	File_protocol: ZSTRING
		once
			Result := "file"
		end

	Wireless_notes_path_copy: EL_FILE_PATH
		once
			Result := Wireless_notes_path.without_extension
			Result.base.append_string_general (" (copy)")
			Result.add_extension ("txt")
		end
end
