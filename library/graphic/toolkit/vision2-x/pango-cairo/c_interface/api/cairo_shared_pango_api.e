note
	description: "Shared pango api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:42:07 GMT (Thursday 30th July 2020)"
	revision: "7"

deferred class
	CAIRO_SHARED_PANGO_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Pango: CAIRO_PANGO_I
		once ("PROCESS")
			create {CAIRO_PANGO_API} Result.make
		end

end
