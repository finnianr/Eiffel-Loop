note
	description: "Shared pango cairo api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:40:33 GMT (Thursday 30th July 2020)"
	revision: "7"

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
