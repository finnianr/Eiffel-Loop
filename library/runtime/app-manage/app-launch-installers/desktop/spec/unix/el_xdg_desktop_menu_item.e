note
	description: "Summary description for {EL_XDG_DESKTOP_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 14:31:55 GMT (Saturday 26th December 2015)"
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
			set_file_name_from_path (menu_path)
		end

feature -- Access

	file_name: ZSTRING

feature -- Element change

	set_file_name_from_path (menu_path: ARRAY [EL_DESKTOP_MENU_ITEM])
			--
		local
			l_menu_path: EL_ARRAYED_LIST [EL_DESKTOP_MENU_ITEM]; name_list: EL_ZSTRING_LIST
		do
			create l_menu_path.make_from_array (menu_path)
			if is_standard then
				file_name := name.twin
			else
				name_list := l_menu_path.string_list (agent {EL_DESKTOP_MENU_ITEM}.name)
				file_name := name_list.joined_with ('-', False)
			end
			file_name.append_character ('.')
			file_name.append_string_general (file_name_extension)
			file_name.replace_character (' ', '-')
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
