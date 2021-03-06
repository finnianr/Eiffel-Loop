note
	description: "Directory tree file processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-10 8:26:38 GMT (Saturday 10th July 2021)"
	revision: "7"

class
	EL_DIRECTORY_TREE_FILE_PROCESSOR

inherit
	EL_COMMAND
		rename
			execute as do_all
		end

	EL_MODULE_LIO

	EL_MODULE_OS

create
	make, default_create

feature -- Initialization

	make (a_source_dir: EL_DIR_PATH; file_pattern: READABLE_STRING_GENERAL; a_file_processor: EL_FILE_PROCESSING_COMMAND)
			--
		do
			source_dir := a_source_dir; file_processor := a_file_processor
			if attached OS.find_files_command (a_source_dir, file_pattern) as find_cmd then
				find_cmd.set_follow_symbolic_links (True)
				find_cmd.execute
				file_path_list := find_cmd.path_list.twin
			end
		end

feature -- Basic operations

	do_all
			--
		do
			counter := 0
			file_path_list.do_all (agent do_with_file_and_increment_counter)
			if is_lio_enabled then
				lio.put_string ("Found ")
				lio.put_integer (counter)
				lio.put_string(" files.%NDone!%N")
			end
		end

	do_with_file (file_path: EL_FILE_PATH)
			--
		do
			file_processor.set_file_path (file_path)
			file_processor.execute
		end

	do_with_file_and_increment_counter (file_path: EL_FILE_PATH)
			--
		do
			counter := counter + 1
			if is_lio_enabled then
				lio.put_new_line
				lio.put_integer (counter)
				lio.put_string (". ")
				lio.put_string (file_path.relative_path (source_dir).to_string)
			end
			do_with_file (file_path)
		end

feature -- Element change

	set_file_processor (a_file_processor: EL_FILE_PROCESSING_COMMAND)
			--
		do
			file_processor := a_file_processor
		end

feature {NONE} -- Internal attributes

	counter: INTEGER

	file_processor: EL_FILE_PROCESSING_COMMAND

	source_dir: EL_DIR_PATH

	file_path_list: EL_SORTABLE_ARRAYED_LIST [EL_FILE_PATH]
end