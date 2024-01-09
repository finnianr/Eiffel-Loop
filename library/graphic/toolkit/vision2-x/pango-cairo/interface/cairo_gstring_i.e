note
	description: "Cairo gstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:13:19 GMT (Tuesday 9th January 2024)"
	revision: "4"

deferred class
	CAIRO_GSTRING_I

feature {NONE} -- Initialization

	make_from_path (a_path: EL_PATH)
		deferred
		end

	make_from_ise_path (a_path: PATH)
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