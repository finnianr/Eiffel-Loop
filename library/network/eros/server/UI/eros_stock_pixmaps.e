note
	description: "Application pixmaps"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EROS_STOCK_PIXMAPS

inherit
	EL_STOCK_PIXMAPS
		redefine
			Default_window_icon
		end

	EL_MODULE_ICON
	
create
	make

feature -- Access

	Default_window_icon: EV_PIXMAP
			--
		once
			Result := Icon.pixmap ("server/window.png")
		end

	Green_light: EV_PIXMAP
			--
		once
			Result := Icon.pixmap ("server/green-light.png")
		end

	Red_light: EV_PIXMAP
			--
		once
			Result := Icon.pixmap ("server/red-light.png")
		end

	Unlit_light: EV_PIXMAP
			--
		once
			Result := Icon.pixmap ("server/unlit-light.png")
		end

end