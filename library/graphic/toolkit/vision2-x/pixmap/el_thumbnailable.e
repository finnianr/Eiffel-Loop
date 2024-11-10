note
	description: "Object that has a representative thumbnail graphic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 14:28:26 GMT (Sunday 10th November 2024)"
	revision: "1"

deferred class
	EL_THUMBNAILABLE

inherit
	EL_MODULE_WIDGET

feature -- Basic operations

	replace_thumbnail
		do
			if attached new_thumbnail_pixmap as new then
				Widget.replace (thumbnail, new)
				thumbnail := new
			end
		end

feature {NONE} -- Implementation

	create_thumbnail_object
		do
			thumbnail := new_thumbnail_pixmap
		end

	new_thumbnail_pixmap: EV_PIXMAP
		deferred
		end

feature {NONE} -- Internal attributes

	thumbnail: EV_PIXMAP

end