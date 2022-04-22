note
	description: "Navigation icons"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-22 9:07:42 GMT (Friday 22nd April 2022)"
	revision: "9"

deferred class
	EL_NAVIGATION_ICONS

inherit
	EL_MODULE_ICON

	EL_MODULE_TUPLE

feature -- Navigation

	Item_pixmap: TUPLE [last, next, previous, refresh, start: EL_PIXMAP]
		once
			create Result
			Tuple.fill_with_new (Result, "last, next, previous, refresh, start", agent new_navigation_pixmap, 1)
		end

	item_pixmap_list: EL_ARRAYED_LIST [EL_PIXMAP]
		do
			create Result.make_from_tuple (Item_pixmap)
		end

	Default_location: STRING
		once
			Result := "navigation"
		end

feature {NONE} -- Implementation

	new_navigation_pixmap (name: STRING): EL_PIXMAP
			--
		local
			dir_path: EL_DIR_PATH
		do
			dir_path := Default_location
			Result := Icon.pixmap (dir_path + (name + ".png"))
		end

end