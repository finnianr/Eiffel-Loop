note
	description: "Directory tree file processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 18:36:32 GMT (Sunday 4th December 2022)"
	revision: "14"

class
	EL_DIRECTORY_TREE_FILE_PROCESSOR [IMP -> EL_FILE_LISTING create default_create end]

inherit
	EL_COMMAND
		rename
			execute as do_all
		end

	EL_MODULE_LIO

create
	make, default_create

feature -- Initialization

	make (a_source_dir: DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL; a_file_processor: EL_FILE_PROCESSING_COMMAND)
			--
		do
			source_dir := a_source_dir; file_pattern := a_file_pattern; file_processor := a_file_processor
		end

feature -- Access

	file_pattern: READABLE_STRING_GENERAL

	source_dir: DIR_PATH

feature -- Basic operations

	do_all
			--
		do
			counter := 0
			new_file_path_list.do_all (agent do_with_file_and_increment_counter)
			if is_lio_enabled then
				lio.put_string ("Found ")
				lio.put_integer (counter)
				lio.put_string(" files.%NDone!%N")
			end
		end

	do_with_file (file_path: FILE_PATH)
			--
		do
			file_processor.set_file_path (file_path)
			file_processor.execute
		end

	do_with_file_and_increment_counter (file_path: FILE_PATH)
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

feature {NONE} -- Implementation

	implementation: IMP
		do
			create Result
		end

	new_file_path_list: EL_FILE_PATH_LIST
		do
			Result := implementation.new_file_list (source_dir, file_pattern)
		end

feature {NONE} -- Internal attributes

	counter: INTEGER

	file_processor: EL_FILE_PROCESSING_COMMAND

end