note
	description: "Directory content processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 18:37:00 GMT (Sunday 4th December 2022)"
	revision: "16"

class
	EL_DIRECTORY_CONTENT_PROCESSOR [IMP -> EL_FILE_LISTING create default_create end]

inherit
	ANY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

create
	make, make_default

feature {NONE} -- Initialization

	make (a_input_dir, a_output_dir: DIR_PATH)
			--
		do
			input_dir := a_input_dir; output_dir := a_output_dir
			create implementation
		end

	make_default
		do
			create implementation
			make (create {DIR_PATH}, create {DIR_PATH})
		end

feature -- Access

	input_dir: DIR_PATH

	output_dir: DIR_PATH

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


	do_all (do_with_file: PROCEDURE [FILE_PATH, FILE_PATH]; wild_card: READABLE_STRING_GENERAL)
		do
			do_with (do_with_file, new_path_list (wild_card))
		end

	do_with (do_with_file: PROCEDURE [FILE_PATH, FILE_PATH]; path_list: like new_path_list)
			-- call `do_with_file' with every file matching `wild_card' from input dir
		local
			output_file_path: FILE_PATH
		do
			count := path_list.count; remaining_count := count

			across path_list as list loop
				output_file_path := output_dir + list.item
				File_system.make_directory (output_file_path.parent)

				do_with_file (input_dir + list.item, output_file_path)
				remaining_count := remaining_count - 1
			end
		end

feature {NONE} -- Implementation

	new_path_list (wild_card: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
			--
		do
			if attached implementation.new_file_list (input_dir, wild_card) as path_list then
				create Result.make_with_count (path_list.count)
				across path_list as list loop
					Result.extend (list.item.relative_path (input_dir))
				end
			end
		end

feature {NONE} -- Internal attributes

	implementation: IMP
end