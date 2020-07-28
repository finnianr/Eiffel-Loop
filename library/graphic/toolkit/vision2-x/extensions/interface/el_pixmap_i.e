note
	description: "EiffelVision pixmap. Implementation interface."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-28 14:58:23 GMT (Tuesday 28th July 2020)"
	revision: "5"

deferred class
	EL_PIXMAP_I

inherit
	EV_PIXMAP_I

feature {EL_PIXMAP} -- Initialization

	make_scaled_to_size (dimension: NATURAL_8; other: EV_PIXMAP; size: INTEGER)
		deferred
		end

end
