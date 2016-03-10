note
	description: "Summary description for {EL_XDG_DESKTOP_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-06 14:15:08 GMT (Friday 6th December 2013)"
	revision: "3"

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

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make (menu_path: ARRAY [EL_DESKTOP_MENU_ITEM])
			--
		require
			menu_path_has_at_least_one_element: menu_path.count >= 1
		local
			last_entry: EL_DESKTOP_MENU_ITEM
		do
			make_empty
			last_entry := menu_path [menu_path.upper]
			make_entry (last_entry.name, last_entry.comment, last_entry.icon_path)
			is_standard := last_entry.is_standard
			set_file_name_from_path (menu_path)
		end

feature -- Access

	file_name: ASTRING

feature -- Element change

	set_file_name_from_path (menu_path: ARRAY [EL_DESKTOP_MENU_ITEM])
			--
		local
			l_menu_path: EL_ARRAYED_LIST [EL_DESKTOP_MENU_ITEM]
			name_list: EL_STRING_LIST [ASTRING]
		do
			create l_menu_path.make_from_array (menu_path)
			if is_standard then
				file_name := name.twin
			else
				create name_list.make_from_array (l_menu_path.string_array (agent {EL_DESKTOP_MENU_ITEM}.name))
				file_name := name_list.joined_with ('-', False)
			end
			file_name.append_character ('.')
			file_name.append_string (file_name_extension)
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
				["comment", agent: ASTRING do Result := comment end],
				["name", agent: ASTRING do Result := name end]
			>>)
		end

end
