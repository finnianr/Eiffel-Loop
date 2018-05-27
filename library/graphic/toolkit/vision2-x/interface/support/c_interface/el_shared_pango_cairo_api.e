note
	description: "Shared pango cairo api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_SHARED_PANGO_CAIRO_API

feature {NONE} -- Implementation

	Pango_cairo: EL_PANGO_CAIRO_I
		once
			create {EL_PANGO_CAIRO_API} Result.make
		end

end