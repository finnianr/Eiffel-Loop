note
	description: "[
		Abstract interface to data object that can be stored to file `file_path' with or without integrity
		checks on restoration. See `store' versus `safe_store'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-16 11:37:28 GMT (Friday 16th October 2020)"
	revision: "7"

deferred class
	EL_FILE_PERSISTENT

inherit
	EL_FILE_PERSISTENT_I

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path)
			--
		do
			file_path := a_file_path
		end

feature -- Access

	file_path: EL_FILE_PATH

feature -- Status query

	is_closed: BOOLEAN
		do
			Result := True
		end

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

	set_file_path (a_file_path: EL_FILE_PATH)
			--
		do
			file_path := a_file_path
		end

	set_name_extension (a_extension: READABLE_STRING_GENERAL)
			-- Set name extension
		do
			file_path := file_path.with_new_extension (a_extension)
		end

feature -- Removal

	delete_file
		require
			file_closed: is_closed
		do
			File_system.remove_file (file_path)
		ensure
			does_not_exist: not file_path.exists
		end
end