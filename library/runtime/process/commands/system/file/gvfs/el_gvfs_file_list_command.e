note
	description: "GVFS command to obtain list of files in directory"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-09 16:11:26 GMT (Tuesday 9th May 2023)"
	revision: "8"

class
	EL_GVFS_FILE_LIST_COMMAND

inherit
	EL_GVFS_URI_COMMAND
		rename
			find_line as try_append
		redefine
			make_default, try_append, reset
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create file_list.make_with_count (10)
			create dir_path
			extension := Empty_string_8
		end

feature -- Access

	dir_path: DIR_PATH

	extension: STRING

	file_list: EL_FILE_PATH_LIST

feature -- Element change

	reset
		do
			file_list.wipe_out
		end

	set_directory (uri_root: EL_URI; a_dir_path: DIR_PATH)
		do
			set_uri (uri_root.joined (a_dir_path))
			dir_path := a_dir_path
		end

	remove_extension
		do
			extension := Empty_string_8
		end

	set_extension (a_extension: STRING)
		do
			extension := a_extension
		end

feature {NONE} -- Line states

	try_append (base_name: ZSTRING)
		local
			file_path: FILE_PATH
		do
			file_path := dir_path + base_name
			if extension.count > 0 implies file_path.has_extension (extension) then
				file_list.extend (file_path)
			end
		end

feature {NONE} -- Constants

	Template: STRING = "gvfs-ls $uri"
end