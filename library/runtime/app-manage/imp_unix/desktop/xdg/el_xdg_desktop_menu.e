note
	description: "XDG desktop menu"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-13 10:54:54 GMT (Sunday 13th September 2020)"
	revision: "8"

class
	EL_XDG_DESKTOP_MENU

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			getter_function_table
		end

	EL_MODULE_BUILD_INFO

	EL_MODULE_EXECUTABLE

	EL_MODULE_OS

	EL_XDG_CONSTANTS

create
	make, make_root

feature {NONE} -- Initialization

	make (a_item: like item; output_dir: EL_DIR_PATH)
			--
		local
			l_name: ZSTRING; list: EL_ZSTRING_LIST
		do
			create list.make_from_general (<<
				Build_info.installation_sub_directory.to_string, Executable.name + ".menu"
			>>)
			l_name := list.joined ('-')
			l_name.replace_character ('/', '-')

			-- Workbench debug: /home/finnian/.config/menus/applications-merged
			make_from_file (output_dir + l_name)
			item := a_item
			create menus.make (5)
			create desktop_entries.make (3)
		end

	make_root (output_dir: EL_DIR_PATH)
			--
		do
			make (Root_item, output_dir)
		end

feature -- Access

	desktop_entries: EL_ZSTRING_LIST

	item: EL_XDG_DESKTOP_MENU_ITEM

	menus: EL_ARRAYED_LIST [EL_XDG_DESKTOP_MENU]

	name: ZSTRING
		do
			Result := item.name
		end

feature -- Status query

	is_root: BOOLEAN
		do
			Result := item = Root_item
		end

feature -- Element change

	extend (entry_path: EL_XDG_DESKTOP_ENTRY_STEPS)
			--
		do
			if entry_path.count > 1 then
				menus.find_first_equal (entry_path.first.name, agent {EL_XDG_DESKTOP_MENU}.name)
				if menus.exhausted then
					menus.extend (create {EL_XDG_DESKTOP_MENU}.make (entry_path.first, output_path.parent))
					menus.finish
				end
				menus.item.extend (entry_path.sub_list (2, entry_path.count))
			else
				desktop_entries.extend (entry_path.first.file_name)
			end
		end

feature -- Removal

	remove
		do
			if output_path.exists then
				OS.delete_file (output_path)
			end
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["is_standard", 		agent: BOOLEAN_REF do Result := item.is_standard.to_reference end],
				["is_root", 			agent: BOOLEAN_REF do Result := is_root.to_reference end],
				["menus", 				agent: like menus do Result := menus end],
				["desktop_entries",	agent: like desktop_entries do Result := desktop_entries end],
				["name", 				agent name],
				["file_name",			agent: ZSTRING do Result := item.file_name end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		#if $is_root then
		<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
		    "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
		<!-- Automatically generated. Do not edit -->
		#end
		<Menu>
			<Name>$name</Name>
		#if not $is_standard then
			<Directory>$file_name</Directory>
		#end
		#foreach $menu in $menus loop
			#evaluate ($menu.template_name, $menu)
			
		#end
		#if $desktop_entries.count > 0 then
			<Include>
			#foreach $entry in $desktop_entries loop
				<Filename>$entry</Filename>
			#end
			</Include>
		#end
		</Menu>
	]"

end
