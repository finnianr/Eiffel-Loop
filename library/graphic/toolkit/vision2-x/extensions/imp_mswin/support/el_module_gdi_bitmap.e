note
	description: "Shared instance of [$source EL_GDI_BITMAP_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-29 8:57:53 GMT (Wednesday 29th July 2020)"
	revision: "1"

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
