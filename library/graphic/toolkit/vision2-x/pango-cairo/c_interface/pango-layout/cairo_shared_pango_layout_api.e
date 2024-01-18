note
	description: "Shared access to instance of class conforming to ${CAIRO_PANGO_LAYOUT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "10"

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