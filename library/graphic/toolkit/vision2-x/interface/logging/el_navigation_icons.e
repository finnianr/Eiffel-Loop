note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-06 15:54:51 GMT (Thursday 6th June 2013)"
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
