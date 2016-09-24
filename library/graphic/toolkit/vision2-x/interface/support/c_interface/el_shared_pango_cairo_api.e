note
	description: "Summary description for {EL_SHARED_PANGO_CAIRO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "1"

class
	EL_SHARED_PANGO_CAIRO_API

feature {NONE} -- Implementation

	Pango_cairo: EL_PANGO_CAIRO_I
		once
			create {EL_PANGO_CAIRO_API} Result.make
		end

end