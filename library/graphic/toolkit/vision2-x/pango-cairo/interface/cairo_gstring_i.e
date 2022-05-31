note
	description: "Cairo gstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 10:04:36 GMT (Tuesday 31st May 2022)"
	revision: "1"

deferred class
	CAIRO_GSTRING_I

feature {NONE} -- Initialization

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