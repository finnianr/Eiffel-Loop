note
	description: "Wcom persist file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "7"

class
	EL_WCOM_PERSIST_FILE

inherit
	EL_WCOM_OBJECT
		rename
			make as make_default
		end

	EL_SHELL_LINK_API

create
	make, default_create

feature {NONE}  -- Initialization

	make (shell_link: EL_SHELL_LINK)
			-- Creation
		local
			this: POINTER
		do
			make_default
			if is_attached (shell_link.self_ptr)
				and then call_succeeded (cpp_create_IPersistFile (shell_link.self_ptr, $this))
			then
				make_from_pointer (this)
			end
		end

feature -- Basic operations

	save (file_path: FILE_PATH)
			--
		do
			last_call_result := cpp_save (self_ptr, wide_string (file_path).base_address, True)
		end

	load (file_path: FILE_PATH)
			--
		do
			last_call_result := cpp_load (self_ptr, wide_string (file_path).base_address, 1)
		end

end
