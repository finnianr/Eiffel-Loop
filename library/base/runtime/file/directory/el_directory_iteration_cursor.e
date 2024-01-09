note
	description: "Cursor to iterate over contents of a directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:25:53 GMT (Sunday 7th January 2024)"
	revision: "6"

class
	EL_DIRECTORY_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [STRING_32] undefine copy, is_equal end

	FILE_INFO
		rename
			make as make_default,
			item as file_info_item
		export
			{NONE} all
			{ANY} exists, is_directory, is_symlink, is_writable, is_plain, is_executable
		end

	EL_EIFFEL_C_API undefine copy, is_equal end

	NATIVE_STRING_HANDLER undefine copy, is_equal end

	MEMORY
		export
			{NONE} all
		undefine
			copy, is_equal
		redefine
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make (a_directory: EL_DIRECTORY)
		require
			closed: a_directory.is_closed
		do
			make_default
			set_is_following_symlinks (a_directory.is_following_symlinks)
			create item.make_empty
			path_name := a_directory.internal_path.twin
			dir_name_pointer := file_name_to_pointer (path_name, dir_name_pointer)
			directory_pointer := eif_dir_open (dir_name_pointer.item)

			if not path_name.is_empty then
				path_name.append_character (Operating_environment.Directory_separator)
			end
			parent_count := path_name.count
			directory_pointer := eif_dir_rewind (directory_pointer, dir_name_pointer.item)
			read_next
		end

feature -- Access

	item: STRING_32

	item_dir_path: DIR_PATH
		do
			Result := item_path (False)
		end

	item_file_path: FILE_PATH
		do
			Result := item_path (False)
		end

	item_path (keep_ref: BOOLEAN): STRING_32
		do
			Result := path_name
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Basic operations

	forth
		do
			read_next
		end

feature -- Status query

	after: BOOLEAN
		do
			Result := last_entry_pointer = default_pointer
		end

	is_current_or_parent: BOOLEAN
		-- 'True' if `item' matches "." or ".."
		local
			count: INTEGER
		do
			count := item.count
			inspect count
				when 1, 2 then
					Result := item.occurrences ('.') = count
			else
			end
		end

feature {NONE} -- Implementation

	close
		do
			eif_dir_close (directory_pointer)
			directory_pointer := default_pointer
		end

	dispose
		do
			if not is_closed then
				close
			end
		end

	is_closed: BOOLEAN
		do
			Result := directory_pointer = default_pointer
		end

	read_next
		require
			not_closed: not is_closed
		do
			last_entry_pointer := eif_dir_next (directory_pointer)
			if last_entry_pointer = default_pointer then
				close
			else
				item := pointer_to_file_name_32 (last_entry_pointer)
				path_name.keep_head (parent_count)
				path_name.append (item)
				update (path_name)
			end
		end

feature {NONE} -- Internal attributes

	dir_name_pointer: MANAGED_POINTER

	directory_pointer: POINTER
		-- Directory pointer as required in C

	last_entry_pointer: POINTER

	parent_count: INTEGER

	path_name: STRING_32
		-- directory path name

end