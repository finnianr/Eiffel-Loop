note
	description: "Unix implemenation of interface [$source EL_PIXMAP_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-14 14:56:41 GMT (Tuesday 14th July 2020)"
	revision: "3"

class
	EL_PIXMAP_IMP

inherit
	EV_PIXMAP_IMP
		export
			{EV_ANY_HANDLER} pixbuf_from_drawable
		end

create
	make

end
