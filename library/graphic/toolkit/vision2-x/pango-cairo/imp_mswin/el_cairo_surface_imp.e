note
	description: "Windows implementation of [$source EL_CAIRO_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-12 17:56:05 GMT (Sunday 12th July 2020)"
	revision: "1"

class
	EL_CAIRO_SURFACE_IMP

inherit
	EL_CAIRO_SURFACE_I

	EV_ANY_HANDLER

create
	make_with_pixmap

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			if attached {EV_PIXMAP_IMP_STATE} a_pixmap.implementation as l_pixmap then
				create mem_dc.make
				bitmap := l_pixmap.get_bitmap
				mem_dc.select_bitmap (bitmap)
				item := Cairo.new_win32_surface_create (mem_dc.item)
			end
		end

feature {NONE} -- Internal attributes

	bitmap: WEL_BITMAP

	mem_dc: WEL_MEMORY_DC

end
