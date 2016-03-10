note
	description: "Summary description for {EL_STORABLE_IN_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:07:28 GMT (Wednesday 16th December 2015)"
	revision: "7"

deferred class
	EL_FILE_PERSISTENT

inherit
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path)
			--
		do
			set_file_path (a_file_path)
		end

feature -- Access

	file_path: EL_FILE_PATH
		deferred
		end

feature -- Element change

	rename_file (new_name: ZSTRING)
			-- rename basename of file preserving the extension
		local
			old_path: like file_path
		do
			old_path := file_path.twin
			file_path.rename_base (new_name, True)
			File_system.rename_file (old_path, file_path)
		end

	rename_file_extension (a_extension: ZSTRING)
		do
			rename_file (file_path.with_new_extension (a_extension).base)
		end

	set_file_path (a_file_path: EL_FILE_PATH)
			--
		deferred
		end

	set_name_extension (a_extension: ZSTRING)
			-- Set name extension
		do
			set_file_path (file_path.with_new_extension (a_extension))
		end

feature -- Status query

	last_store_ok: BOOLEAN
		-- True if last store succeeded

feature -- Basic operations

	store
		do
			store_as (file_path)
		end

	safe_store
			-- store to temporary file checking if storage operation completed
			-- If storage was successful set last_store_ok to true
			-- and replace saved file with temporary file
		local
			new_file_path: EL_FILE_PATH
			new_file: like new_open_read_file
		do
			last_store_ok := False
			new_file_path := file_path.twin
			new_file_path.add_extension ("new")
			store_as (new_file_path)

			new_file := new_open_read_file (new_file_path)
			last_store_ok := stored_successfully (new_file)
			new_file.close

			if last_store_ok then
				File_system.remove_file (file_path)
				-- Change name
				new_file.rename_file (file_path)
			end
		end

feature {NONE} -- Implementation

	store_as (a_file_path: like file_path)
			--
		deferred
		end

	stored_successfully (a_file: like new_open_read_file): BOOLEAN
		require
			file_open_read: a_file.is_open_read
		deferred
		end

	new_open_read_file (a_file_path: like file_path): FILE
		deferred
		end
end
