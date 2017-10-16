note
	description: "Summary description for {EL_SHARED_PANGO_CAIRO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_SHARED_PANGO_CAIRO_API

feature {NONE} -- Implementation

	Pango_cairo: EL_PANGO_CAIRO_I
		once
			create {EL_PANGO_CAIRO_API} Result.make
		end

end