note
	description: "Summary description for {EL_XDG_DESKTOP_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-25 13:19:37 GMT (Monday 25th April 2016)"
	revision: "5"

deferred class
	EL_XDG_DESKTOP_MENU_ITEM

inherit
	EL_DESKTOP_MENU_ITEM
		rename
			make as make_entry
		end

	EVOLICITY_SERIALIZEABLE
		redefine
			getter_function_table
		end

feature {NONE} -- Initialization

	make (menu_path: ARRAY [EL_DESKTOP_MENU_ITEM])
			--
		require
			menu_path_has_at_least_one_element: menu_path.count >= 1
		local
			last_entry: EL_DESKTOP_MENU_ITEM
		do
			make_default
			last_entry := menu_path [menu_path.upper]
			make_entry (last_entry.name, last_entry.comment, last_entry.icon_path)
			is_standard := last_entry.is_standard
		end

feature -- Access

	file_name: ZSTRING
		do
			Result := name.translated_general (" ", "-") + "." + file_name_extension
		end

feature {NONE} -- Implementation

	file_name_extension: STRING
			--
		deferred
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["icon_path", agent: EL_PATH do Result := icon_path end],
				["comment", agent: ZSTRING do Result := comment end],
				["name", agent: ZSTRING do Result := name end]
			>>)
		end

end
