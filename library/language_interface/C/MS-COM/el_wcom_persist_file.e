note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 16:31:25 GMT (Monday 3rd October 2016)"
	revision: "2"

class
	EL_WCOM_PERSIST_FILE

inherit
	EL_WCOM_OBJECT

	EL_SHELL_LINK_API

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
