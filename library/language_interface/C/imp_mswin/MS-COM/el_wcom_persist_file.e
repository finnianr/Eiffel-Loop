note
	description: "Wcom persist file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-22 14:51:10 GMT (Tuesday 22nd March 2022)"
	revision: "8"

class
	EL_WCOM_PERSIST_FILE

inherit
	EL_WCOM_OBJECT
		rename
			make as make_default
		end

	EL_COM_OBJECT_BASE_API

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