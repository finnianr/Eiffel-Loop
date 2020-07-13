note
	description: "Unix implementation of `to_jpeg'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 17:44:01 GMT (Monday 13th July 2020)"
	revision: "3"

deferred class
	EL_PIXMAP_TO_JPEG_IMP

feature -- Conversion

	to_jpeg (quality: NATURAL): EL_JPEG_PIXMAP_IMP
		do
			create Result.make (pixbuf_from_drawable, quality, True)
		end

feature {NONE} -- Implementation

	pixbuf_from_drawable: POINTER
			-- Return a GdkPixbuf object from the current Gdkpixbuf structure
		deferred
		end

end
