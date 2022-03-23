note
	description: "[
		Wraps
		[https://docs.microsoft.com/en-us/windows/win32/api/objidl/nn-objidl-ipersistfile IPersistFile]
		COM interface
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-23 10:47:43 GMT (Wednesday 23rd March 2022)"
	revision: "10"

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
			set_string (agent cpp_save (?, ?, True), file_path)
		end

	load (file_path: FILE_PATH)
			--
		do
			set_string (agent cpp_load (?, ?, 1), file_path)
		end

end