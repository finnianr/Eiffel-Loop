note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

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
