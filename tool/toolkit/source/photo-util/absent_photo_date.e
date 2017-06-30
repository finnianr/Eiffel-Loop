note
	description: "Summary description for {ABSENT_PHOTO_DATE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 8:21:49 GMT (Thursday 29th June 2017)"
	revision: "2"

class
	ABSENT_PHOTO_DATE

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_OS

create
	make, default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_jpeg_tree_dir: like jpeg_tree_dir; output_file_path: EL_FILE_PATH)
		do
			jpeg_tree_dir := a_jpeg_tree_dir
			create output.make_with_path (output_file_path)
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			across OS.file_list (jpeg_tree_dir, "*.jpg") as path loop
				lio.put_path_field ("", path.item); lio.put_new_line
			end
			log.exit
		end

feature {NONE} -- Internal attributes

	jpeg_tree_dir: EL_DIR_PATH

	output: EL_PLAIN_TEXT_FILE
end
