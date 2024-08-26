note
	description: "Special file mutex of fixed length"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 18:02:43 GMT (Monday 26th August 2024)"
	revision: "4"

deferred class
	EL_NAMED_FILE_LOCK_I

inherit
	EL_FILE_LOCK
		rename
			make as make_lock
		redefine
			dispose
		end

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
		deferred
		end

feature -- Access

	path: EL_FILE_PATH

feature -- Status change

	close
		deferred
		end

feature {NONE} -- Implementation

	is_fixed_size: BOOLEAN
		do
			Result := True
		end

	is_writeable: BOOLEAN
		do
		end

	dispose
		do
			close; Precursor
		end

	native_path: MANAGED_POINTER
		do
			Result := Native_string.new_data (path)
		end

	remove_file
		do
			File_system.remove_file (path)
		end

end