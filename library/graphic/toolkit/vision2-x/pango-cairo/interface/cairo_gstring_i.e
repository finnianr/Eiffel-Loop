note
	description: "Cairo gstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-01 17:27:53 GMT (Wednesday 1st June 2022)"
	revision: "2"

deferred class
	CAIRO_GSTRING_I

feature {NONE} -- Initialization

	make_from_file_path (file_path: FILE_PATH)
		deferred
		end

	make_from_path (a_path: PATH)
		deferred
		end

	share_from_pointer (a_utf8_ptr: POINTER)
		deferred
		end

feature -- Access

	item: POINTER
		deferred
		end

	string: STRING_32
		deferred
		end

end