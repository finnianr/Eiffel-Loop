note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_WCOM_PERSIST_FILE

inherit
	EL_WCOM_OBJECT

	EL_SHELL_LINK_API
		undefine
			dispose
		end

create
	make_from_pointer, default_create

feature -- Basic operations

	save (file_path: EL_FILE_PATH)
			--
		do
			last_call_result := cpp_save (self_ptr, wide_string (file_path.unicode).base_address, True)
		end

	load (file_path: EL_FILE_PATH)
			--
		do
			last_call_result := cpp_load (self_ptr, wide_string (file_path.unicode).base_address, 1)
		end

end
