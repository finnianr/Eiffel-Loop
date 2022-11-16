note
	description: "Cairo gstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

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