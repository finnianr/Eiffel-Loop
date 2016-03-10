note
	description: "Summary description for {EL_DIRECTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-26 12:47:12 GMT (Friday 26th June 2015)"
	revision: "3"

class
	EL_DIRECTORY

inherit
	DIRECTORY
		rename
			make as make_from_string,
			set_name as set_path,
			entries as path_entries
		redefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

	EL_STRING_CONSTANTS
		undefine
			default_create
		end

create
	default_create, make

feature -- Initialization

	default_create
		do
			create {STRING} internal_name.make_empty
			create internal_detachable_name_pointer.make (0)
		end

	make (dir_path: EL_DIR_PATH)
			-- Create directory object for directory
			-- of name `dn'.
		do
			make_with_name (dir_path)
		end

feature -- Access

	directories: EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			l_entries: like entries_of_type
		do
			l_entries := entries_of_type (Type_directory, Empty_string_8)
			create Result.make (l_entries.count)
			across l_entries as entry loop
				if attached {EL_DIR_PATH} entry.item as dir_path then
					Result.extend (dir_path)
				end
			end
		end

	entries: EL_ARRAYED_LIST [EL_PATH]
		local
			l_entries: like entries_of_type
		do
			l_entries := entries_of_type (Type_any, Empty_string_8)
			create Result.make (l_entries.count)
			Result.append (l_entries)
		end

	files: EL_ARRAYED_LIST [EL_FILE_PATH]
		local
			l_entries: like entries_of_type
		do
			l_entries := entries_of_type (Type_file, Empty_string_8)
			create Result.make (l_entries.count)
			across l_entries as entry loop
				if attached {EL_FILE_PATH} entry.item as file_path then
					Result.extend (file_path)
				end
			end
		end

	files_with_extension (extension: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [EL_FILE_PATH]
		local
			l_entries: like entries_of_type
		do
			l_entries := entries_of_type (Type_file, extension)
			create Result.make (l_entries.count)
			across l_entries as entry loop
				if attached {EL_FILE_PATH} entry.item as file_path then
					Result.extend (file_path)
				end
			end
		end

	recursive_files: EL_ARRAYED_LIST [EL_FILE_PATH]
		local
			list: LINKED_LIST [EL_FILE_PATH]
		do
			create list.make
			append_recursive_files (list, Empty_string_8)
			create Result.make (list.count)
			Result.append (list)
		end

feature -- Basic operations

	delete_files (extension: STRING)
		do
			files_with_extension (extension).do_all (agent File_system.remove_file)
		end

feature {EL_DIRECTORY} -- Implementation

	append_recursive_files (list: LINKED_LIST [EL_FILE_PATH]; extension: READABLE_STRING_GENERAL)
		local
			directory: EL_DIRECTORY
		do
			across entries_of_type (Type_any, extension) as entry loop
				if attached {EL_DIR_PATH} entry.item as dir_path then
					create directory.make (dir_path)
					directory.append_recursive_files (list, extension)

				elseif attached {EL_FILE_PATH} entry.item as file_path then
					list.extend (file_path)
				end
			end
		end

	entries_of_type (type: INTEGER; extension: READABLE_STRING_GENERAL): LINKED_LIST [EL_PATH]
		require
			is_open: true
		local
			l_dir_path: EL_DIR_PATH; file_path: EL_FILE_PATH
			file: RAW_FILE; l_path: PATH
			l_path_entries: like path_entries; i: INTEGER
		do
			create file.make_with_name ("none")
			create l_dir_path.make_from_path (path)
			create Result.make
			l_path_entries := path_entries
			from i := 1  until i > l_path_entries.count loop
				l_path := l_path_entries [i]
				if not (l_path.is_current_symbol or else l_path.is_parent_symbol) then
					file_path := l_dir_path.joined_file_path (l_path)
					file.make_with_name (file_path)
					if file.is_directory then
						if type = Type_any or type = Type_directory then
							if extension /= Empty_string_8 implies l_path.has_extension (extension) then
								Result.extend (l_dir_path.joined_dir_path (l_path))
							end
						end

					elseif type = Type_any or type = Type_file then
						if extension /= Empty_string_8 implies l_path.has_extension (extension) then
							Result.extend (file_path)
						end
					end
				end
				i := i + 1
			end
		end

	file_count (list: EL_ARRAYED_LIST [EL_PATH]): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > list.count loop
				if attached {EL_FILE_PATH} list [i] then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Type_any: INTEGER = 3

	Type_directory: INTEGER = 2

	Type_file: INTEGER = 1

end
