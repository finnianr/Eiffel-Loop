note
	description: "Summary description for {EL_STORABLE_IN_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:00 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EL_FILE_PERSISTENT

inherit
	EL_MODULE_FILE_SYSTEM

	EL_SHARED_THREAD_MANAGER

	EL_SINGLE_THREAD_ACCESS
		rename
			make_thread_access as make
		end

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path)
			--
		do
			make
			set_file_path (a_file_path)
		ensure
			mutex_created: attached {MUTEX} mutex
		end

feature -- Access

	file_path: EL_FILE_PATH
		deferred
		end

feature -- Element change

	rename_file (a_name: EL_ASTRING)
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (file_path.unicode)
			set_file_path (file_path.parent.joined_file_path (a_name))
			if l_file.exists then
				l_file.rename_file (file_path.unicode)
			end
		end

	rename_file_extension (a_extension: EL_ASTRING)
		do
			rename_file (file_path.with_new_extension (a_extension))
		end

	set_file_path (a_file_path: EL_FILE_PATH)
			--
		deferred
		end

	set_name_extension (a_extension: EL_ASTRING)
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
			restrict_access
--			synchronized
				store_as (file_path)
--			end
			end_restriction
		end

	safe_store
			-- store to temporary file checking if storage operation completed
			-- If storage was successful set last_store_ok to true
			-- and replace saved file with temporary file
		local
			new_file_path: EL_FILE_PATH
			new_file: like new_open_read_file
		do
			restrict_access
--			synchronized
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
					new_file.rename_file (file_path.unicode)
				end
--			end
			end_restriction
		end

	separate_safe_store
		local
			l_thread: EL_WORKER_THREAD
		do
			create l_thread.make (agent safe_store)
			l_thread.launch
			Thread_manager.extend (l_thread)
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
