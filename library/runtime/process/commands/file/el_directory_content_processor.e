note
	description: "Directory content processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "14"

class
	EL_DIRECTORY_CONTENT_PROCESSOR

inherit
	ANY

	EL_MODULE_OS

	EL_MODULE_LIO

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			make (create {DIR_PATH}, create {DIR_PATH})
		end

	make (a_input_dir, a_output_dir: DIR_PATH)
			--
		do
			input_dir := a_input_dir; output_dir := a_output_dir
		end

feature -- Access

	input_dir: EL_PATH_STEPS

	output_dir: EL_PATH_STEPS

feature -- Measurement

	count: INTEGER
			-- Total file to process

	remaining_count: INTEGER
			-- Files remaining_count to process

feature -- Element change

	set_input_dir (a_input_dir: like input_dir)
			-- Set `input_dir' to `an_input_dir'.
		do
			input_dir := a_input_dir
		end

	set_output_dir (a_output_dir: like output_dir)
			-- Set `output_dir' to `an_output_dir'.
		do
			output_dir := a_output_dir
		end

feature -- Basic operations

	do_all (do_with_file: PROCEDURE [FILE_PATH, DIR_PATH, ZSTRING, ZSTRING]; wild_card: STRING)
			-- call `do_with_file' with every file matching `wild_card' from input dir
		local
			output_file_unqualified_name, output_file_extension: ZSTRING
			destination_dir_path, output_dir_path, input_file_path: EL_PATH_STEPS
			path_list: like find_files; dot_pos: INTEGER
		do
			create input_file_path.make_steps (20)
			create output_dir_path.make_steps (20)

			path_list := find_files (wild_card)
			count := path_list.count; remaining_count := count

			across path_list as list loop
				input_file_path.wipe_out
				output_dir_path.wipe_out
				create destination_dir_path

				input_file_path.append_path (input_dir)
				input_file_path.append_path (list.item)

				output_dir_path.append_path (output_dir)
				output_dir_path.append_path (list.item)

				output_file_unqualified_name := output_dir_path.base
				dot_pos := output_file_unqualified_name.last_index_of ('.', output_file_unqualified_name.count)
				if dot_pos > 0 then
					output_file_extension := output_file_unqualified_name.substring_end (dot_pos + 1)
					output_file_unqualified_name.remove_tail (output_file_extension.count + 1)
				else
					output_file_extension := ""
				end
				output_dir_path.remove_tail (1)

				OS.File_system.make_directory (output_dir_path)
				destination_dir_path := output_dir_path

				do_with_file (
					input_file_path.to_file_path, destination_dir_path.to_dir_path,
					output_file_unqualified_name, output_file_extension
				)
				remaining_count := remaining_count - 1
			end
		end

feature {NONE} -- Implementation

	find_files (wild_card: STRING): EL_FILE_PATH_LIST
			--
		local
			file_path_list: EL_FILE_PATH_LIST; steps: EL_PATH_STEPS
			i: INTEGER
		do
			create file_path_list.make (OS.file_list (input_dir, wild_card))
			create Result.make_with_count (file_path_list.count)

			across file_path_list as list loop
				steps := list.item

				-- Make path relative to input dir
				from i := 1 until i > input_dir.character_count loop
					steps.remove_head (1)
					i := i + 1
				end
				Result.extend (steps)
			end
		end

end