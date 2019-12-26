note
	description: "Cursor to iterate over contents of a directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-26 17:09:05 GMT (Thursday 26th December 2019)"
	revision: "1"

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
			create directory.make_open_read (a_directory.internal_path)
			set_is_following_symlinks (a_directory.is_following_symlinks)
			create item.make_empty
			internal_path := directory.internal_path
			if not internal_path.is_empty then
				internal_path.append_character (Operating_environment.Directory_separator)
			end
			parent_count := internal_path.count
			directory.start; read_next
		end

feature -- Access

	item: STRING_32

	item_path (keep_ref: BOOLEAN): STRING_32
		do
			Result := internal_path
			if keep_ref then
				Result := Result.twin
			end
		end

	item_dir_path: EL_DIR_PATH
		do
			Result := item_path (False)
		end

	item_file_path: EL_FILE_PATH
		do
			Result := item_path (False)
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

	dispose
		do
			if not directory.is_closed then
				directory.close
			end
		end

	read_next
		do
			last_entry_pointer := directory.next_entry_pointer
			if last_entry_pointer = default_pointer then
				directory.close
			else
				item := pointer_to_file_name_32 (last_entry_pointer)
				internal_path.keep_head (parent_count)
				internal_path.append (item)
				update (internal_path)
			end
		end

feature {NONE} -- Internal attributes

	internal_path: STRING_32

	directory: EL_DIRECTORY

	parent_count: INTEGER

	last_entry_pointer: POINTER
end
