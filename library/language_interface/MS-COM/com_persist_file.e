note
	description: "[
		Wraps
		[https://docs.microsoft.com/en-us/windows/win32/api/objidl/nn-objidl-ipersistfile IPersistFile]
		COM interface
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 16:46:05 GMT (Monday 1st January 2024)"
	revision: "12"

class
	COM_PERSIST_FILE

inherit
	COM_OBJECT
		rename
			make as make_default
		end

	COM_OBJECT_BASE_API

create
	make, make_default

feature {NONE}  -- Initialization

	make (a_self_ptr: POINTER)
			-- Creation
		do
			make_default
			make_from_pointer (a_self_ptr)
		end

feature -- Basic operations

	save (file_path: FILE_PATH)
			--
		do
			Native_string.set_string (file_path)
			last_status := cpp_save (self_ptr, Native_string.item, True)
		end

	load (file_path: FILE_PATH)
			--
		do
			Native_string.set_string (file_path)
			last_status := cpp_load (self_ptr, Native_string.item, 1)
		end

end