note
	description: "Windows implementation of [$source EL_CAIRO_PIXMAP_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 10:08:22 GMT (Monday 13th July 2020)"
	revision: "2"

class
	EL_CAIRO_PIXMAP_SURFACE_IMP

inherit
	EL_CAIRO_PIXMAP_SURFACE_I

	EL_CAIRO_SURFACE_IMP

	EV_ANY_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_pixmap: EV_PIXMAP)
		do
			if attached {EV_PIXMAP_IMP_STATE} a_pixmap.implementation as l_pixmap then
				create mem_dc.make
				bitmap := l_pixmap.get_bitmap
				mem_dc.select_bitmap (bitmap)
				self_ptr := Cairo.new_win32_surface_create (mem_dc.item)
			end
		end

feature {NONE} -- Internal attributes

	bitmap: WEL_BITMAP

	mem_dc: WEL_MEMORY_DC

end
