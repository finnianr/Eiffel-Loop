note
	description: "[
		Abstract interface to data object that can be stored to file `file_path' with or without integrity
		checks on restoration. See `store' versus `safe_store'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-20 13:10:28 GMT (Wednesday 20th February 2019)"
	revision: "8"

deferred class
	EL_FILE_PERSISTENT_I

inherit
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		deferred
		end

feature -- Access

	file_path: EL_FILE_PATH
		deferred
		end

feature -- Element change

	set_file_path (a_file_path: EL_FILE_PATH)
			--
		deferred
		end

feature -- Status query

	last_store_ok: BOOLEAN
		-- True if last store succeeded

feature -- Basic operations

	safe_store
			-- store to temporary file checking if storage operation completed
			-- If storage was successful set last_store_ok to true
			-- and replace saved file with temporary file
		local
			new_file_path: EL_FILE_PATH
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
