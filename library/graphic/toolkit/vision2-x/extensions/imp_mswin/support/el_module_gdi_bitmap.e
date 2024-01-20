note
	description: "Shared instance of ${EL_GDI_BITMAP_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_MODULE_GDI_BITMAP

inherit
	EL_MODULE

feature {NONE} -- Constants

	Gdi_bitmap:	EL_GDI_BITMAP_ROUTINES
		once
			create Result
		end

end