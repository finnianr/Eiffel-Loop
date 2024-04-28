note
	description: "Cursor to iterate over contents of a directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-27 7:21:21 GMT (Saturday 27th April 2024)"
	revision: "9"

class
	EL_DIRECTORY_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [STRING_32]
		rename
			item as item_base
		undefine
			copy, is_equal
		end

	FILE_INFO
		rename
			make as make_default,
			item as file_info_item
		export
			{NONE} all
			{ANY} exists, is_directory, is_symlink, is_writable, is_plain, is_executable
		end

	EL_EIFFEL_C_API undefine copy, is_equal end

	MEMORY
		export
			{NONE} all
		undefine
			copy, is_equal
		redefine
			dispose
		end

	NATIVE_STRING_HANDLER undefine copy, is_equal end

	EL_DIRECTORY_CONSTANTS undefine copy, is_equal end

create
	make

feature {NONE} -- Initialization

	make (a_directory: EL_DIRECTORY)
		require
			closed: a_directory.is_closed
		do
			make_default
			set_is_following_symlinks (a_directory.is_following_symlinks)
			create path_name.make (a_directory.internal_path.count + 50)
			path_name.append (a_directory.internal_path)

			dir_name_pointer := file_name_to_pointer (path_name, dir_name_pointer)
			directory_pointer := eif_dir_open (dir_name_pointer.item)
			if not path_name.is_empty then
				path_name.append_character (Operating_environment.Directory_separator)
			end
			parent_count := path_name.count
			directory_pointer := eif_dir_rewind (directory_pointer, dir_name_pointer.item)
			create path_name_pointer.share_from_pointer (default_pointer, 0)
			read_next
		end

feature -- Access

	item_base: STRING_32
		-- base name of item
		do
			Result := path_name.substring (parent_count + 1, path_name.count)
		end

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

	existing_item_matches_type_and_extension (a_type: INTEGER; extension: READABLE_STRING_GENERAL): BOOLEAN
		do
			if not is_current_or_parent and then exists
				and then item_has_extension (extension) and then item_matches_type (a_type)
			then
				Result := True
			end
		end

	existing_item_matches_name_and_type (a_name: READABLE_STRING_GENERAL; a_type: INTEGER): BOOLEAN
		do
			if item_same_as (a_name) and then exists then
				inspect a_type
					when Type_any then
						Result := True
					when Type_file then
						Result := is_plain
					when Type_executable_file then
						Result := is_plain and then is_executable
					else
				end
			end
		end

	is_current_or_parent: BOOLEAN
		-- 'True' if `item_base' matches "." or ".."
		local
			lower, upper: INTEGER
		do
			lower := parent_count + 1; upper := path_name.count
			inspect upper - lower + 1
				when 1, 2 then
					if path_name [lower] = '.' then
						Result := upper > lower implies path_name [upper] = '.'
					end
			else
			end
		end

	item_has_extension (extension: READABLE_STRING_GENERAL): BOOLEAN
		local
			base_count: INTEGER
		do
			base_count := path_name.count - parent_count
			if base_count > extension.count and then path_name.ends_with_general (extension) then
				Result := path_name [path_name.count - extension.count] = '.'
			end
		end

	item_matches_type (a_type: INTEGER): BOOLEAN
		do
			inspect a_type
				when Type_directory then
					Result := is_directory

				when Type_file then
					Result := not is_directory

				when Type_any then
					Result := True
			else
			end
		end

	item_same_as (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if path_name.count - parent_count = name.count then
				Result := name.same_characters (path_name, 1, name.count, parent_count + 1)
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
		local
			ptr: POINTER; conv: UTF_CONVERTER
		do
			last_entry_pointer := eif_dir_next (directory_pointer)
			if last_entry_pointer = default_pointer then
				close
			else
				ptr := last_entry_pointer
				path_name_pointer.set_from_pointer (ptr, pointer_length_in_bytes (ptr))
				path_name.keep_head (parent_count)
				if {PLATFORM}.is_windows then
					conv.utf_16_0_pointer_into_escaped_string_32 (path_name_pointer, path_name)
				else
					conv.utf_8_0_pointer_into_escaped_string_32 (path_name_pointer, path_name)
				end
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

	path_name_pointer: MANAGED_POINTER

end