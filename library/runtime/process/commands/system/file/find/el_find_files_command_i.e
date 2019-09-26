note
	description: "Cross platform interface to [$source EL_FIND_FILES_COMMAND_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-26 13:54:20 GMT (Thursday   26th   September   2019)"
	revision: "7"

deferred class
	EL_FIND_FILES_COMMAND_I

inherit
	EL_FIND_COMMAND_I
		rename
			make as make_path,
			copy_directory_items as copy_directory_files
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make (a_dir_path: like dir_path; a_name_pattern: like name_pattern)
			--
		do
			make_path (a_dir_path)
			name_pattern := a_name_pattern
		end

	make_default
			--
		do
			Precursor
			name_pattern := "*"
		end

feature -- Measurement

	sum_file_byte_count: NATURAL
		do
			execute
			across path_list as path loop
				Result := Result + File_system.file_byte_count (path.item).to_natural_32
			end
		end

feature -- Element change

	set_file_pattern (a_name_pattern: READABLE_STRING_GENERAL)
			--
		do
			create name_pattern.make_from_general (a_name_pattern)
		end

feature {NONE} -- Implementation

	copy_path_item (source_path: like new_path; destination_dir: EL_DIR_PATH)
		do
			OS.copy_file (source_path, destination_dir)
		end

	new_path (a_path: ZSTRING): EL_FILE_PATH
		do
			create Result.make (a_path)
		end

feature {NONE} -- Constants

	Type: STRING = "f"
		-- Unix find type

end
