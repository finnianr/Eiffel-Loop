note
	description: "Unix implementation of `to_jpeg'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-03 13:06:04 GMT (Friday 3rd July 2020)"
	revision: "2"

deferred class
	EL_PIXMAP_TO_JPEG_IMP

feature -- Conversion

	to_jpeg (quality: INTEGER): EL_JPEG_PIXMAP_IMP
		do
			create Result.make (pixbuf_from_drawable, quality, True)
		end

feature {NONE} -- Implementation

	pixbuf_from_drawable: POINTER
			-- Return a GdkPixbuf object from the current Gdkpixbuf structure
		deferred
		end

end
