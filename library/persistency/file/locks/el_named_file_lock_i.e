note
	description: "Special file mutex of fixed length"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-19 7:55:12 GMT (Monday 19th August 2024)"
	revision: "2"

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

	last_error: NATURAL

feature -- Status change

	close
		deferred
		end

feature {NONE} -- Implementation

	is_fixed_size: BOOLEAN
		do
			Result := True
		end

	dispose
		do
			close; Precursor
		end

	native_path: MANAGED_POINTER
		do
			Result := Native_string.new_data (path)
		end
end