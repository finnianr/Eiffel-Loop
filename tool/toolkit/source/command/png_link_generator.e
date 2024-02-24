note
	description: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-24 16:32:04 GMT (Saturday 24th February 2024)"
	revision: "1"

class
	PNG_LINK_GENERATOR

inherit
	EL_APPLICATION_COMMAND

	EL_FILE_TREE_COMMAND
		rename
			make as make_command,
			tree_dir as png_tree_dir
		redefine
			execute, file_extensions
		end

	EL_MODULE_COMMAND; EL_MODULE_FILE; EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_jpeg_tree_dir, a_output_dir: DIR_PATH)
		do
			make_command (a_jpeg_tree_dir)
			output_dir := a_output_dir
			output_dir.expand
			create size_table.make_size (1000)
		end

feature -- Basic operations

	execute
		local
			link_path: FILE_PATH
		do
			Precursor
			File_system.make_directory (output_dir)
			across size_table as list loop
				link_path := output_dir + list.key
				lio.put_index_labeled_string (list, Void, list.key.to_string)
				lio.put_labeled_substitution (" size", "%Sx%S", [list.item.width, list.item.height])
				lio.put_new_line
				File_system.make_directory (link_path.parent)
				if not link_path.exists
					and then attached Command.new_link_file (list.item.file_path, link_path) as cmd
				then
					cmd.execute
				end
			end
		end

feature {NONE} -- Implementation

	do_with_file (file_path: FILE_PATH)
		local
			data: ZSTRING; png_info: like new_png_info
		do
			if not File.is_symlink (file_path) and then attached Png_info_command as cmd then
				cmd.put_path (Var_path, file_path)
				cmd.execute
				if cmd.lines.count > 0 and then cmd.lines.first.count > file_path.count then
					data := cmd.lines.first.substring_end (file_path.count + 6)
					png_info := new_png_info (file_path, data)
				-- Square icons > 128 in width
					if png_info.width >= 128 and then png_info.width = png_info.height then
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
			end
		end

feature {NONE} -- Implementation

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
			if steps.count >= 5 then
				steps.remove_head (3)
				from until steps.count <= 3 loop
					steps.remove (3)
				end
			end
			Result := steps
		end

feature {NONE} -- Internal attributes

	output_dir: DIR_PATH

	size_table: EL_HASH_TABLE [like new_png_info, FILE_PATH]

feature {NONE} -- Constants

	Description: STRING = "[
		Generates links to PNG files >= 128x128 ins
	]"

	File_extensions: STRING = "png"

	Png_info_command: EL_CAPTURED_OS_COMMAND
		once
			create Result.make ("identify $PATH")
		end

	Size_list: EL_SPLIT_STRING_8_LIST
		once
			create Result.make_empty
		end

	Var_path: STRING = "PATH"

end