note
	description: "[
		Abstract interface to data object that can be stored to file `file_path' with or without integrity
		checks on restoration. See `store' versus `safe_store'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 11:23:09 GMT (Monday 5th December 2022)"
	revision: "14"

deferred class
	EL_FILE_PERSISTENT_I

inherit
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make_from_file (a_file_path: FILE_PATH)
		deferred
		end

feature -- Access

	file_path: FILE_PATH
		deferred
		end

feature -- Status query

	is_closed: BOOLEAN
		do
			Result := True
		end

	last_store_ok: BOOLEAN
		-- True if last store succeeded

feature -- Element change

	rename_base (new_name: READABLE_STRING_GENERAL; preserve_extension: BOOLEAN)
		-- rename basename of file preserving the extension if `preserve_extension' is true
		local
			old_path: like file_path
		do
			old_path := file_path.twin
			file_path.rename_base (new_name, preserve_extension)
			File_system.rename_file (old_path, file_path)
		end

	rename_file_extension (a_extension: READABLE_STRING_GENERAL)
		require
			closed: is_closed
		do
			rename_base (file_path.with_new_extension (a_extension).base, False)
		end

	set_file_path (a_file_path: FILE_PATH)
			--
		deferred
		end

	set_name_extension (a_extension: READABLE_STRING_GENERAL)
			-- Set name extension
		do
			file_path.replace_extension (a_extension)
		end

feature -- Basic operations

	delete_file
		require
			file_closed: is_closed
		do
			File_system.remove_file (file_path)
		ensure
			does_not_exist: not file_path.exists
		end

	safe_store
			-- store to temporary file checking if storage operation completed
			-- If storage was successful set last_store_ok to true
			-- and replace saved file with temporary file
		require
			file_path_set: not file_path.is_empty
			directory_exists_and_is_writeable: file_path.parent.exists_and_is_writeable
		local
			new_file_path: FILE_PATH
			l_file: like new_file
		do
			last_store_ok := False
			new_file_path := file_path.twin
			new_file_path.add_extension ("new")
			store_as (new_file_path)

			l_file := new_file (new_file_path)
			l_file.open_read
			last_store_ok := stored_successfully (l_file)
			l_file.close

			if last_store_ok then
				File_system.remove_file (file_path)
				-- Change name
				l_file.rename_file (file_path)
			end
		end

	store
		require
			file_path_set: not file_path.is_empty
			directory_exists_and_is_writeable: file_path.parent.exists_and_is_writeable
		do
			store_as (file_path)
		end

feature {NONE} -- Implementation

	new_file (a_file_path: like file_path): FILE
		deferred
		end

	store_as (a_file_path: like file_path)
			--
		deferred
		end

	stored_successfully (a_file: like new_file): BOOLEAN
		require
			file_open_read: a_file.is_open_read
		deferred
		end

end