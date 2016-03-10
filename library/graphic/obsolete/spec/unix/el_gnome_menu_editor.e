note
	description: "Summary description for {EL_GNOME_MENU_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_GNOME_MENU_EDITOR

inherit
	EL_PYTHON_SELF

	EL_MODULE_STRING

	EL_PLATFORM_IMPL

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			import_Alacarte_MenuEditor
			make_self (Python.module_class_instance (Alacarte_MenuEditor, "MenuEditor"))
		end

feature -- Access

	applications_tree_root: PYTHON_OBJECT
			--
		do
			Result := self.nested_object_attribute ("applications.tree.root")
		end

feature -- Basic operations

	create_menu (parent_menu: EL_GNOME_MENU_TREE_ITEM; menu: EL_DESKTOP_MENU_ITEM)
			-- Python: def createMenu(self, parent, icon, name, comment, before=None, after=None):
		do
			self.call ("createMenu", [parent_menu, menu.icon_path, normalize (menu.name), normalize (menu.comment)])
		end

	create_item	(parent_menu: EL_GNOME_MENU_TREE_ITEM; entry: EL_DESKTOP_LAUNCHER)
			-- Python: def createItem(self, parent, icon, name, comment, command, use_term, before=None, after=None):
		do
			self.call ("createItem",
				[	parent_menu, entry.icon_path,
					normalize (entry.name), normalize (entry.comment), normalize (entry.command), false
				]
			)
		end

	delete (item: EL_GNOME_MENU_TREE_ITEM)
			-- Python: def deleteItem(self, item):
		do
			if item.is_type_entry then
				self.call ("deleteItem", [item])
			else
				self.call ("deleteMenu", [item])
			end
		end

	save
			--
		do
			self.call ("save", [])
		end

feature {NONE} -- Implementation

	normalize (str: STRING): STRING
			--
		do
			create Result.make_from_string (str)
			String.subst_all_characters (Result, '%N', '%/32/')
		end

	import_Alacarte_MenuEditor
			--
		once
			Python.import_module ("sys")
			Python.call ("sys.path.append", ["/usr/share/pyshared"])
			Python.import_module (Alacarte_MenuEditor)
		end

feature -- Constants

	Alacarte_MenuEditor: STRING = "Alacarte.MenuEditor"

end

