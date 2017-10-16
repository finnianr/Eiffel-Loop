note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_NAVIGATION_ICONS

inherit
	EL_MODULE_ICON

feature -- Constants

	Item_START_pixmap: EV_PIXMAP
			--
		do
			Result := navigation_pixmap ("START")
		end

	Item_PREVIOUS_pixmap: EV_PIXMAP
			--
		do
			Result := navigation_pixmap ("PREVIOUS")
		end

	Item_NEXT_pixmap: EV_PIXMAP
			--
		do
			Result := navigation_pixmap ("NEXT")
		end

	Item_END_pixmap: EV_PIXMAP
			--
		do
			Result := navigation_pixmap ("END")
		end

	Item_REFRESH_pixmap: EV_PIXMAP
			--
		do
			Result := navigation_pixmap ("REFRESH")
		end

	Default_location: STRING = "navigation"
			--

feature {NONE} -- Implementation

	navigation_pixmap (name: STRING): EV_PIXMAP
			--
		do
			Result := Icon.pixmap (<< Default_location, name + ".png" >>)
		end

end