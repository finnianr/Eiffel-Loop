note
	description: "[
		Lists JPEG photos that lack the EXIF field Exif.Photo.DateTimeOriginal
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 15:26:56 GMT (Saturday 1st July 2017)"
	revision: "3"

class
	UNDATED_PHOTOS

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_OS

	EL_ITERATION_OUTPUT
		undefine
			new_lio
		end

create
	make, default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_jpeg_tree_dir: like jpeg_tree_dir; output_file_path: EL_FILE_PATH)
		do
			jpeg_tree_dir := a_jpeg_tree_dir
			create output.make_with_path (output_file_path)
			create {EL_JPEG_FILE_INFO_COMMAND_IMP} jpeg_info.make_default
		end

feature -- Basic operations

	execute
		local
			i: NATURAL
		do
			log.enter ("execute")
			output.open_write
			across << "*.jpeg", "*.jpg" >> as wildcard loop
				across OS.file_list (jpeg_tree_dir, wildcard.item) as path loop
					jpeg_info.set_file_path (path.item)
					if not jpeg_info.has_date_time then
						output.put_string_32 (path.item)
						output.put_new_line
					end
					print_progress (i)
					i := i + 1
				end
			end
			output.close
			log.exit
		end

feature {NONE} -- Internal attributes

	jpeg_info: EL_JPEG_FILE_INFO_COMMAND_I

	jpeg_tree_dir: EL_DIR_PATH

	output: EL_PLAIN_TEXT_FILE

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 60
		end

end
