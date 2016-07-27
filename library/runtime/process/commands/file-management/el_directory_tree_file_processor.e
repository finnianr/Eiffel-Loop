note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 18:25:04 GMT (Friday 8th July 2016)"
	revision: "4"

class
	EL_DIRECTORY_TREE_FILE_PROCESSOR

inherit
	EL_COMMAND
		rename
			execute as do_all
		end

	EL_MODULE_LIO

	EL_MODULE_COMMAND

create
	make, default_create

feature -- Initialization

	make (a_path: like source_directory_path; a_file_processor: EL_FILE_PROCESSOR)
			--
		do
			source_directory_path := a_path
			file_processor := a_file_processor
			file_pattern := "*"
		end

feature -- Basic operations

	do_all
			--
		local
			find_cmd: like Command.new_find_files
		do
			counter := 0
			io.put_new_line
			find_cmd := Command.new_find_files (source_directory_path, file_pattern)
			find_cmd.set_follow_symbolic_links (True)
			find_cmd.execute
			find_cmd.path_list.do_all (agent do_with_file_and_increment_counter)
			lio.put_string ("Found ")
			lio.put_integer (counter)
			lio.put_string(" files.%NDone!%N")
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
			lio.put_integer (counter)
			lio.put_string (". ")
			lio.put_string (file_path.relative_path (source_directory_path).to_string)
			lio.put_new_line
			do_with_file (file_path)
		end

feature {NONE} -- Implementation

	counter: INTEGER

	source_directory_path: EL_DIR_PATH

	file_pattern: STRING

	file_processor: EL_FILE_PROCESSOR

feature -- Element change

	set_source_directory_path (a_path: like source_directory_path)
			--
		do
			source_directory_path := a_path
		end

	set_file_processor (a_file_processor: EL_FILE_PROCESSOR)
			--
		do
			file_processor := a_file_processor
		end

	set_file_pattern (a_file_pattern: STRING)
			--
		do
			file_pattern := a_file_pattern
		end

end -- class EL_DIRECTORY_TREE_FILE_PROCESSOR
