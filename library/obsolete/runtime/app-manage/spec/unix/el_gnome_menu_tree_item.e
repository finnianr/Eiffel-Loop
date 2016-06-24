note
	description: "Summary description for {EL_GNOME_MENU_TREE_ITEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_GNOME_MENU_TREE_ITEM

inherit
	EL_PYTHON_SELF
		redefine
			default_create
		end

	EL_SHARED_GNOME_MENU_EDITOR
		undefine
			default_create
		end

create
	make_self, default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			make_self  (create {PYTHON_NONE}.new_none)
		end

feature -- Access

	name: STRING
			--
		local
			pos_last_hyphen: INTEGER
		do
			Result := self.string_attribute ("name")

			-- Workaround
			-- Due to a bug/feature of Alacarte MenuEditor, if the menu is newly created
			-- the name has a numeric suffix and is the same as the menu id
			pos_last_hyphen := Result.last_index_of ('-', Result.count)
			if Result ~ menu_id and then Result.substring (pos_last_hyphen + 1, Result.count).is_integer then
				Result := Result.substring (1, pos_last_hyphen - 1)
			end
		end

	menu_id: STRING
			--
		do
			if type ~ Type_directory then
				Result := self.string_attribute ("menu_id")
			else
				Result := self.string_attribute ("desktop_file_id")
			end
		end

	type: INTEGER
			--
		do
			Result := self.integer_attribute ("type")
		end

	submenu (a_name: STRING): like Current
			--
		do
			Result := item_of_type (a_name, Type_directory)
		end

	menu_entry (a_name: STRING): like Current
			--
		do
			Result := item_of_type (a_name, Type_entry)
		end

	submenu_list: ARRAYED_LIST [EL_GNOME_MENU_TREE_ITEM]
			--
		do
			Result := contents_of_type (Type_directory)
		end

	menu_entry_list: ARRAYED_LIST [EL_GNOME_MENU_TREE_ITEM]
			--
		do
			Result := contents_of_type (Type_entry)
		end

	desktop_file_path: EL_FILE_PATH
			--
		do
			create Result.make_from_string (self.string_item ("get_desktop_file_path", []))
		end

feature -- Status query

	is_empty : BOOLEAN
			--
		do
			if type ~ Type_directory then
				Result := self.generator_sequence ("menu", "menu", "hasattr (menu, 'type')", "get_contents", []).is_empty
			else
				Result := true
			end
		end

	is_type_menu: BOOLEAN
			--
		do
			Result := type = Type_directory
		end

	is_type_entry: BOOLEAN
			--
		do
			Result := type = Type_entry
		end

	has_submenu (a_name: STRING): BOOLEAN
			--
		do
			search_name := a_name
			Result := submenu_list.there_exists (
				agent (item: EL_GNOME_MENU_TREE_ITEM): BOOLEAN
					do
						Result := item.name ~ search_name
					end
			)
		end

	has_menu_entry (a_name: STRING): BOOLEAN
			--
		do
			search_name := a_name
			Result := menu_entry_list.there_exists (
				agent (item: EL_GNOME_MENU_TREE_ITEM): BOOLEAN
					do
						Result := item.name ~ search_name
					end
			)
		end

feature {NONE} -- Implementation

	item_of_type (a_name: STRING; a_type: INTEGER): like Current
			--
		local
			found: BOOLEAN
			contents:  ARRAYED_LIST [EL_GNOME_MENU_TREE_ITEM]
		do
			contents := contents_of_type (a_type)
			from contents.start until found or contents.after loop
				if contents.item.name ~ a_name then
					found := true
					Result := contents.item
				end
				contents.forth
			end
			if not found then
				create Result
			end
		end

	contents_of_type (a_type: INTEGER): ARRAYED_LIST [EL_GNOME_MENU_TREE_ITEM]
			--
		require
			is_menu_list: is_type_menu
		local
			filter_expression: STRING
			list: LIST [PYTHON_OBJECT]
		do
			filter_expression := ("hasattr (menu, 'type') and menu.type == " + a_type.out)
			list := self.generator_sequence ("menu", "menu", filter_expression, "get_contents", [])
			create Result.make (list.count)
			from list.start until list.after loop
				Result.extend (create {EL_GNOME_MENU_TREE_ITEM}.make_self (list.item_for_iteration))
				list.forth
			end
		end

	search_name: STRING

feature -- Constants

	Type_directory: INTEGER
			--
		once
			Result := Python.module_integer_value ("gmenu", "TYPE_DIRECTORY")
		end

	Type_entry: INTEGER
			--
		once
			Result := Python.module_integer_value ("gmenu", "TYPE_ENTRY")
		end

end
