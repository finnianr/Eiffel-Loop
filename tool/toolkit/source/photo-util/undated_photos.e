note
	description: "[
		Lists JPEG photos that lack the EXIF field Exif.Photo.DateTimeOriginal
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-25 12:36:47 GMT (Tuesday 25th July 2017)"
	revision: "4"

class
	UNDATED_PHOTOS

inherit
	EL_FILE_TREE_COMMAND
		rename
			make as make_command,
			tree_dir as jpeg_tree_dir
		undefine
			new_lio
		redefine
			execute, extension_list
		end

	EL_MODULE_LOG

create
	make, default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_jpeg_tree_dir: like jpeg_tree_dir; output_file_path: EL_FILE_PATH)
		do
			make_command (a_jpeg_tree_dir)
			create output.make_with_path (output_file_path)
			create {EL_JPEG_FILE_INFO_COMMAND_IMP} jpeg_info.make_default
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			output.open_write
			Precursor
			output.close
			log.exit
		end

feature {NONE} -- Implementation

	extension_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			Result := Precursor
			Result.extend ("jpg")
		end

	do_with_file (file_path: EL_FILE_PATH)
		do
			jpeg_info.set_file_path (file_path)
			if not jpeg_info.has_date_time then
				output.put_string_32 (file_path)
				output.put_new_line
			end
		end

feature {NONE} -- Internal attributes

	jpeg_info: EL_JPEG_FILE_INFO_COMMAND_I

	output: EL_PLAIN_TEXT_FILE

feature {NONE} -- Constants

	Default_extension: STRING = "jpeg"

end
