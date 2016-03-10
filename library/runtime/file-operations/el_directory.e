note
	description: "Summary description for {EL_DIRECTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:12:42 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_DIRECTORY

inherit
	DIRECTORY
		rename
			make as make_from_string,
			set_name as set_path,
			make_open_read as make_open_directory_read
		export
			{ANY} set_path
		redefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

create
	default_create, make, make_open_read

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
			make_with_name (dir_path.unicode)
		end

	make_open_read (dir_path: EL_DIR_PATH)
			-- Create directory object for directory
			-- of name `dn' and open it for reading.
		do
			make_open_directory_read (dir_path.unicode)
		end

feature -- Conversion

	file_list (extension: STRING): ARRAYED_LIST [EL_FILE_PATH]
		local
			l_entries: like entries
			dot_extension: STRING
			l_dir_path: EL_DIR_PATH
		do
			dot_extension := "." + extension
			create l_dir_path.make_from_path (path)
			l_entries := entries
			l_entries.compare_objects
			across << ".", ".." >> as dot_directories loop
				l_entries.start; l_entries.prune (create {PATH}.make_from_string (dot_directories.item))
			end

			create Result.make (l_entries.count)
			across l_entries as entry loop
				if entry.item.has_extension (extension) then
					Result.extend (l_dir_path.joined_file_path (entry.item))
				end
			end
		end

feature -- Basic operations

	delete_files (extension: STRING)
		do
			file_list (extension).do_all (agent File_system.remove_file)
		end
end
