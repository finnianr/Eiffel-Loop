note
	description: "EiffelVision pixmap. Implementation interface."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-29 16:54:04 GMT (Monday 29th June 2020)"
	revision: "2"

deferred class
	EL_PIXMAP_I

inherit
	EV_PIXMAP_I

feature -- Conversion

	to_jpeg (quality: INTEGER): EL_JPEG_PIXMAP_I
		deferred
		end

end
