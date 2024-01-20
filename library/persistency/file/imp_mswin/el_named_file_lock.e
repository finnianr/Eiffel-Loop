note
	description: "A special 1 byte created file that can be used as a file mutex"
	notes: "[
		STATUS 22 Nov 2023
		
		This is a Linux port but not yet implemented for Windows as a special 1 byte file.
		The descendant class ${EL_LOCKABLE_TEXT_FILE} however is fully tested.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_NAMED_FILE_LOCK

inherit
	EL_FILE_LOCK
		rename
			make as make_lock
		redefine
			dispose
		end

	FILE_HANDLE
		rename
			close as close_file,
			put_string as put_file_string
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	WEL_FILE_CONSTANTS
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
		local
			NULL: POINTER
		do
			path := a_path
			make_write (
				cwin_create_file (
					a_path.to_path.native_string.item, Generic_write, File_share_write,
					NULL, Open_existing, File_attribute_normal, NULL
				)
			)
		ensure
			is_lockable: is_lockable
		end

feature -- Access

	path: EL_FILE_PATH

feature -- Status change

	close
		do
			if is_attached (file_handle) and then close_file (file_handle) then
				file_handle := default_pointer
			end
		ensure
			not_lockable: not is_lockable
		end

feature {NONE} -- Implementation

	is_fixed_size: BOOLEAN
		do
			Result := True
		end

	dispose
		do
			if is_attached (file_handle) and then close_file (file_handle) then
				do_nothing
			end
			Precursor
		end

end