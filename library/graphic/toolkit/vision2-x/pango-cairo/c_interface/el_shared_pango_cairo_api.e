note
	description: "Shared pango cairo api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:00 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_SHARED_PANGO_CAIRO_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Pango_cairo: EL_PANGO_CAIRO_I
		once
			create {EL_PANGO_CAIRO_API} Result.make
		end

end
