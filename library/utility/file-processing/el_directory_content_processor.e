note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-25 8:44:56 GMT (Tuesday 25th June 2013)"
	revision: "2"

class
	EL_DIRECTORY_CONTENT_PROCESSOR

inherit
	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create input_file_relative_path_steps_list.make
		end

feature -- Access

	output_dir: EL_DIR_PATH

	input_dir: EL_DIR_PATH

feature -- Measurement

	count: INTEGER
			-- Total file to process

	remaining: INTEGER
			-- Files remaining to process
		do
			Result := input_file_relative_path_steps_list.count
		end

feature -- Element change

	set_output_dir (a_output_dir: like output_dir)
			-- Set `output_dir' to `an_output_dir'.
		do
			output_dir := a_output_dir
			output_dir_path_steps := a_output_dir
		ensure
			output_dir_assigned: output_dir = a_output_dir
		end

	set_input_dir (a_input_dir: like input_dir)
			-- Set `input_dir' to `an_input_dir'.
		do
			input_dir := a_input_dir
			input_dir_path_steps := a_input_dir
		ensure
			input_dir_assigned: input_dir ~ a_input_dir
		end

feature -- Basic operations

	do_all (
		file_processing_action: PROCEDURE [ANY, TUPLE [EL_FILE_PATH, EL_DIR_PATH, STRING, STRING]]
		wild_card: STRING
	)
			-- Apply file processing action to every file from input dir
		require
			input_dir_assigned: input_dir /= Void
			output_dir_assigned: output_dir /= Void
		local
			output_file_unqualified_name, output_file_extension: STRING
			destination_dir_path: EL_DIR_PATH
			input_file_path_steps, output_file_dir_path_steps: EL_PATH_STEPS
			input_file_path: EL_FILE_PATH
			dot_pos: INTEGER
		do
			create input_file_path_steps.make_with_count (20)
			create output_file_dir_path_steps.make_with_count (20)
			find_files (wild_card)
			from
				input_file_relative_path_steps_list.start
			until
				input_file_relative_path_steps_list.after
			loop
				input_file_path_steps.wipe_out
				output_file_dir_path_steps.wipe_out
				create input_file_path
				create destination_dir_path

				input_file_path_steps.fill (input_dir_path_steps)
				input_file_path_steps.fill (input_file_relative_path_steps_list.item)

				output_file_dir_path_steps.fill (output_dir_path_steps)
				output_file_dir_path_steps.fill (input_file_relative_path_steps_list.item)

				create output_file_unqualified_name.make_from_string (output_file_dir_path_steps.last)
				dot_pos := output_file_unqualified_name.last_index_of ('.', output_file_unqualified_name.count)
				if dot_pos > 0 then
					output_file_extension := output_file_unqualified_name.substring (
						dot_pos + 1, output_file_unqualified_name.count
					)
					output_file_unqualified_name.remove_tail (output_file_extension.count + 1)
				else
					output_file_extension := ""
				end
				output_file_dir_path_steps.finish
				output_file_dir_path_steps.remove

				input_file_path := input_file_path_steps.as_file_path
				File_system.make_directory_from_steps (output_file_dir_path_steps)
				destination_dir_path := output_file_dir_path_steps.as_directory_path

				file_processing_action.call (
					[input_file_path, destination_dir_path, output_file_unqualified_name, output_file_extension]
				)
				input_file_relative_path_steps_list.remove
			end
		end


feature {NONE} -- Implementation

	find_files (wild_card: STRING)
			--
		local
			file_path_list: EL_FILE_PATH_LIST
			file_path_steps: EL_PATH_STEPS
			i: INTEGER
		do
			create file_path_list.make (input_dir, wild_card)

			input_file_relative_path_steps_list.wipe_out
			across file_path_list as file_path loop
				file_path_steps := file_path.item.steps

				-- Make path relative to input dir
				from i := 1 until i > input_dir_path_steps.count loop
					file_path_steps.start
					file_path_steps.remove
					i := i + 1
				end
				input_file_relative_path_steps_list.extend (file_path_steps)
			end
			count := input_file_relative_path_steps_list.count
		end

	input_file_relative_path_steps_list: LINKED_LIST [EL_PATH_STEPS]
			-- List of path's relative to input dir split by dir separator

	output_dir_path_steps: EL_PATH_STEPS

	input_dir_path_steps: EL_PATH_STEPS

end
