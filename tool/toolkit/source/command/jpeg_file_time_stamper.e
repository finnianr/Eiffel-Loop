note
	description: "[
		Ensure JPEG file modified time corresponds to `Exif.Image.DateTime' if present.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-11 13:26:50 GMT (Thursday 11th May 2023)"
	revision: "14"

class
	JPEG_FILE_TIME_STAMPER

inherit
	EL_APPLICATION_COMMAND

	EL_FILE_TREE_COMMAND
		rename
			make as make_command,
			tree_dir as jpeg_tree_dir
		redefine
			execute, file_extensions
		end

	EL_MODULE_FILE; EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_jpeg_tree_dir: DIR_PATH)
		do
			make_command (a_jpeg_tree_dir)
			create {EL_JPEG_FILE_INFO_COMMAND_IMP} jpeg_info.make_default
		end

feature -- Basic operations

	execute
		do
			updated_count := 0
			Precursor
			if updated_count.to_boolean then
				lio.put_labeled_substitution ("Updated", "%S files", [updated_count])
				lio.put_new_line
			else
				lio.put_line ("All modification times correct")
			end
		end

feature {NONE} -- Implementation

	do_with_file (file_path: FILE_PATH)
		do
			jpeg_info.set_file_path (file_path)

			if jpeg_info.has_date_time and then File.modification_time (file_path) /= jpeg_info.date_time then
				File.set_modification_time (file_path, jpeg_info.date_time)
				updated_count := updated_count + 1
			end
		end

feature {NONE} -- Internal attributes

	jpeg_info: EL_JPEG_FILE_INFO_COMMAND_I

	updated_count: INTEGER

feature {NONE} -- Constants

	File_extensions: STRING = "jpeg, jpg"

	Description: STRING = "[
		Ensures JPEG file modified time corresponds to EXIF meta-data
	]"

end