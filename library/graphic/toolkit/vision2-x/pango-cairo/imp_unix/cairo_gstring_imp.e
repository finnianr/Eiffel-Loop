note
	description: "Cairo gstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 10:00:13 GMT (Tuesday 31st May 2022)"
	revision: "1"

class
	CAIRO_GSTRING_IMP

inherit
	CAIRO_GSTRING_I

	EV_GTK_C_STRING
		export
			{NONE} all
		end

create
	make_from_path, share_from_pointer

end