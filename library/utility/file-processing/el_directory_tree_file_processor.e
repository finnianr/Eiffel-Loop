note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_DIRECTORY_TREE_FILE_PROCESSOR

inherit
	EL_COMMAND
		rename
			execute as do_all
		end

	EL_MODULE_LOG

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
			find_command: EL_FIND_FILES_COMMAND
		do
			log.enter ("do_all")
			counter := 0
			io.put_new_line

			create find_command.make (source_directory_path, file_pattern)
			find_command.set_follow_symbolic_links (True)
			find_command.execute
			find_command.path_list.do_all (agent do_with_file_and_increment_counter)
			log_or_io.put_string ("Found ")
			log_or_io.put_integer (counter)
			log_or_io.put_string(" files.%NDone!%N")
			log.exit
		end

	do_with_file (file_path: EL_FILE_PATH)
			--
		do
			log.enter_with_args ("do_with_file",<< file_path >>)
			file_processor.set_file_path (file_path)
			file_processor.execute
			log.exit
		end

	do_with_file_and_increment_counter (file_path: EL_FILE_PATH)
			--
		do
			counter := counter + 1
			log_or_io.put_integer (counter)
			log_or_io.put_string (". ")
			log_or_io.put_string (file_path.relative_path (source_directory_path).to_string)
			log_or_io.put_new_line
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

