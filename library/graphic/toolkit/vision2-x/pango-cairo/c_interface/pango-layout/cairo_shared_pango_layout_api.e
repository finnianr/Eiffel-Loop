note
	description: "Shared access to instance of class conforming to [$source CAIRO_PANGO_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 14:41:36 GMT (Monday 30th May 2022)"
	revision: "9"

deferred class
	CAIRO_SHARED_PANGO_LAYOUT_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Pango_layout: CAIRO_PANGO_LAYOUT_I
		once
			create {CAIRO_PANGO_LAYOUT_API} Result.make
		end

end