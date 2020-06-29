note
	description: "Unix implemenation of interface [$source EL_PIXMAP_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-29 13:06:12 GMT (Monday 29th June 2020)"
	revision: "1"

class
	EL_PIXMAP_IMP

inherit
	EV_PIXMAP_IMP
		redefine
			interface
		end

	EL_PIXMAP_I
		undefine
			flush, save_to_named_path
		redefine
			interface
		end

create
	make

feature -- Conversion

	to_jpeg (quality: INTEGER): EL_JPEG_PIXMAP_IMP
		do
			create Result.make (pixbuf_from_drawable, quality, True)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_PIXMAP note option: stable attribute end;

end
