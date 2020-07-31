note
	description: "Shared access to instance of class conforming to [$source CAIRO_PANGO_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 13:11:40 GMT (Thursday 30th July 2020)"
	revision: "8"

deferred class
	CAIRO_SHARED_PANGO_CAIRO_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Pango_cairo: CAIRO_PANGO_LAYOUT_I
		once
			create {CAIRO_PANGO_LAYOUT_API} Result.make
		end

end
