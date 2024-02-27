note
	description: "[
		Generates links in an output folder to all PNG files >= 128x128 in size.

		If the PNG path has the structure
		
			/usr/share/a/b/c/file.png
			
		then the output path relative to `/usr/share' is abbreviated to
		
			a/b/file.png

		If there are icons with duplicate relative paths, then only the icon with the
		largest size has a link created.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-27 11:36:08 GMT (Tuesday 27th February 2024)"
	revision: "5"

class
	PNG_LINK_GENERATOR

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_COMMAND; EL_MODULE_FILE; EL_MODULE_LIO

	EL_MODULE_OS; EL_MODULE_TRACK

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_dir, a_output_dir: DIR_PATH; step_list: STRING)
		do
			source_dir := a_source_dir; output_dir := a_output_dir; exclude_list := step_list
			output_dir.expand
			remove_step_count := source_dir.step_count.min (3)
			create size_table.make_size (1000)
		end

feature -- Basic operations

	execute
		local
			link_path: FILE_PATH; counter_table: EL_COUNTER_TABLE [DIR_PATH]
		do
			fill_size_table

			OS.File_system.make_directory (output_dir)
			create counter_table.make (size_table.count // 10)
			across size_table as list loop
				counter_table.put (list.key.parent)
			end
			lio.put_integer_field ("Creating links", size_table.count)
			lio.put_new_line
			across size_table as list loop
				if counter_table.has_key (list.key.parent) and then counter_table.found_count.item <= 2 then
					link_path := (output_dir #+ "other") + list.key.base
				else
					link_path := output_dir + list.key
				end
				lio.put_index_labeled_string (list, Void, list.key.to_string)
				lio.put_labeled_substitution (" size", "%Sx%S", [list.item.width, list.item.height])
				lio.put_new_line
				OS.File_system.make_directory (link_path.parent)
				if not link_path.exists
					and then attached Command.new_link_file (list.item.file_path, link_path) as cmd
				then
					cmd.execute
				end
			end
		end

feature {NONE} -- Implementation

	extend_size_table (file_path: FILE_PATH; size: ZSTRING)
		do
		-- Square icons > 128 in width
			if attached new_png_info (file_path, size) as png_info
				and then png_info.width >= 128 and then png_info.width = png_info.height
			then
				if attached new_short_path (file_path) as path then
					if size_table.has_key (path) then
						if size_table.found_item.width > png_info.width then
							size_table [path] := png_info
						end
					else
						size_table.extend (png_info, path)
					end
				end
			end
		end

	fill_size_table
		local
			has_small_step: EL_PREDICATE_FIND_CONDITION
			png_info_list: EL_ZSTRING_LIST
		do
			has_small_step := agent path_has_small_size_step
			if attached OS.find_directories_command (source_dir) as cmd then
				cmd.set_filter (not has_small_step)
				cmd.set_follow_symbolic_links (False)
				cmd.execute
				Track.progress (Console_display, cmd.path_list.count, agent iterate_directories (cmd.path_list))
			end
		end

	iterate_directories (path_list: EL_ARRAYED_LIST [DIR_PATH])
		local
			index: INTEGER; png_path: FILE_PATH; str: ZSTRING
		do
			across path_list as list loop
				if attached Png_info_command as info_cmd then
					info_cmd.put_path (Var_path, list.item + "*.png")
					info_cmd.execute
					across info_cmd.lines as line loop
						str := line.item
						index := 1
						index := str.substring_index (Dot_png, index)
						if index > 0 then
							index := index + Dot_png.count - 1
							png_path := str.substring (1, index)
							if png_path.exists and then not File.is_symlink (png_path)
								and then across exclude_list as step all not png_path.has_step (step.item) end
								and then attached str.substring_to_from ('G', $index)
							then
								index := index + 1
								extend_size_table (png_path, str.substring_to_from (' ', $index))
							end
						end
					end
				end
				Track.progress_listener.notify_tick
			end
		end

	new_png_info (file_path: FILE_PATH; data: ZSTRING): TUPLE [file_path: FILE_PATH; width, height: INTEGER]
		do
			create Result
			Result.file_path := file_path
			size_list.fill (data.substring_to (' '), 'x', 0)
			if attached Size_list as list and then list.count = 2 then
				from list.start until list.after loop
					inspect list.index
						when 1 then
							Result.width := list.integer_32_item
					else
						Result.height := list.integer_32_item
					end
					list.forth
				end
			end
		end

	new_short_path (file_path: FILE_PATH): FILE_PATH
		local
			steps: EL_PATH_STEPS
		do
			steps := file_path
			if steps.count >= remove_step_count + 2 then
				steps.remove_head (remove_step_count)
				from until steps.count <= 3 loop
					steps.remove (steps.count - 1)
				end
			end
			Result := steps
		end

	path_has_small_size_step (path: ZSTRING): BOOLEAN
		local
			index: INTEGER
		do
			Result := False
			across Small_size_list as list until Result loop
				index := path.substring_index (list.item, 1)
				if index > 0 then
					index := index + list.item.count
					if index - 1 = path.count then
						Result := True
					else
						inspect path [index]
							when '/', 'x' then
								Result := True
						else
						end
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	exclude_list: EL_ZSTRING_LIST

	output_dir: DIR_PATH

	remove_step_count: INTEGER

	size_table: EL_HASH_TABLE [like new_png_info, FILE_PATH]

	source_dir: DIR_PATH

feature {NONE} -- Constants

	Description: STRING = "[
		Generates links in an output folder to PNG files >= 128x128 in size
	]"

	Dot_png: ZSTRING
		once
			Result := ".png"
		end

	Png_info_command: EL_CAPTURED_OS_COMMAND
		once
			create Result.make ("identify $PATH")
		end

	Size_list: EL_SPLIT_STRING_8_LIST
		once
			create Result.make_empty
		end

	Small_size_list: EL_ZSTRING_LIST
		once
			create Result.make (5)
			across << 8, 16, 22, 24, 32, 48, 64 >> as size loop
				Result.extend ("/" + size.item.out)
			end
		end

	Var_path: STRING = "PATH"

end