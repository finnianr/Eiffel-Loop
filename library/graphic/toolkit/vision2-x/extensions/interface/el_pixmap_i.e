note
	description: "EiffelVision pixmap. Implementation interface."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_PIXMAP_I

inherit
	EV_PIXMAP_I

feature {EL_PIXMAP} -- Initialization

	make_scaled_to_size (dimension: NATURAL_8; other: EV_PIXMAP; size: INTEGER)
		deferred
		end

	init_from_buffer (buffer: CAIRO_DRAWING_AREA)
			-- Initialize from `buffer'
		deferred
		ensure
			same_size: width = buffer.width and height = buffer.height
		end

end