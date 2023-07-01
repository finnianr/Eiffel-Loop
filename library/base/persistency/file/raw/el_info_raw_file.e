note
	description: "Informational file for reading/writing file attributes or renaming or deleting"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-01 16:11:15 GMT (Saturday 1st July 2023)"
	revision: "6"

class
	EL_INFO_RAW_FILE

inherit
	RAW_FILE
		rename
			make as make_latin_1,
			set_path as set_ise_path,
			set_name as set_path_name,
			internal_name as internal_path,
			internal_detachable_name_pointer as file_info_pointer
		export
			{NONE} all
			{ANY} access_date, count, delete, date, exists, rename_file, set_date, stamp,
			is_symlink, is_access_executable, is_access_owner,
			is_access_readable, is_access_writable, is_writable,
			is_block, is_creatable, is_fifo, is_socket, is_sticky, is_device, is_directory, is_setuid,
			is_setgid, is_owner
			{EL_FILE_ROUTINES_I} buffered_file_info
		redefine
			internal_path, set_path_name
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			mode := Closed_file
			create internal_path.make_empty
			create file_info_pointer.make (0)
			create last_string.make_empty
		end

feature -- Element change

	set_path (a_path: EL_PATH)
		do
			internal_path.wipe_out; a_path.append_to_32 (internal_path)
			set_path_name (internal_path)
		ensure
			name_set: internal_path ~ a_path.as_string_32
		end

	set_path_name (a_name: STRING_32)
			-- Set `name' with `a_name'.
		do
			internal_path := a_name
			file_info_pointer := Buffered_file_info.file_name_to_pointer (a_name, file_info_pointer)
		end

feature -- Basic operations

	fill_native_path (native_path: MANAGED_POINTER; a_path: EL_PATH)
		do
			internal_path.wipe_out; a_path.append_to_32 (internal_path)
			if attached Buffered_file_info.file_name_to_pointer (internal_path, native_path) as pointer then
				check
					same_pointer: pointer = native_path
				end
			end
		end

feature {NONE} -- Internal attributes

	internal_path: STRING_32

invariant
	closed: is_closed
end