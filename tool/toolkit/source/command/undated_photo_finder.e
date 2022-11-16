note
	description: "[
		Lists JPEG photos that lack the EXIF field `Exif.Photo.DateTimeOriginal'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	UNDATED_PHOTO_FINDER

inherit
	EL_APPLICATION_COMMAND
	
	EL_FILE_TREE_COMMAND
		rename
			make as make_command,
			tree_dir as jpeg_tree_dir
		redefine
			execute, file_extensions
		end

	EL_MODULE_LIO

	EL_MODULE_COMMAND

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_jpeg_tree_dir: like jpeg_tree_dir; output_file_path: FILE_PATH)
		do
			make_command (a_jpeg_tree_dir)
			create output.make_with_path (output_file_path)
			jpeg_info := Command.new_jpeg_info ("")
		end

feature -- Basic operations

	execute
		do
			output.open_write
			Precursor
			output.close
		end

feature {NONE} -- Implementation

	do_with_file (file_path: FILE_PATH)
		do
			jpeg_info.set_file_path (file_path)
			if not jpeg_info.has_date_time then
				output.put_string (file_path)
				output.put_new_line
			end
		end

feature {NONE} -- Internal attributes

	jpeg_info: like command.new_jpeg_info

	output: EL_PLAIN_TEXT_FILE

feature {NONE} -- Constants

	File_extensions: STRING = "jpeg, jpg"

	Description: STRING = "[
		Make list of jpeg photos lacking a "Date time taken" EXIF info
	]"

end