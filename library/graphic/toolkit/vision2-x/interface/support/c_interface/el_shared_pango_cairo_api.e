note
	description: "Summary description for {EL_SHARED_PANGO_CAIRO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_SHARED_PANGO_CAIRO_API

feature {NONE} -- Implementation

	Pango_cairo: EL_PANGO_CAIRO_I
		once
			create {EL_PANGO_CAIRO_API} Result.make
		end

end
