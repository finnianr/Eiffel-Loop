note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:01 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_XDG_DESKTOP_MENU

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializeable
		redefine
			getter_function_table, Template, Encoding_name
		end

	EL_MODULE_LOG

create
	make, make_root

feature {NONE} -- Initialization

	make_root (a_name: STRING)
			--
		do
			make (a_name, "", True)
			is_root := True
		end

	make (a_name, a_file_name: STRING; standard: BOOLEAN)
			--
		do
			make_serializeable
			create menus.make (5)
			create desktop_entries.make
			name := a_name
			is_standard := standard
			file_name := a_file_name
		end

feature -- Access

	menus: EL_ARRAYED_LIST [EL_XDG_DESKTOP_MENU]

	desktop_entries: LINKED_LIST [STRING]

	name: STRING

	file_name: STRING

feature -- Status query

	is_standard: BOOLEAN

	is_root: BOOLEAN

feature -- Element change

	extend (entry_path: ARRAY [EL_XDG_DESKTOP_MENU_ITEM])
			--
		local
			first_entry: EL_XDG_DESKTOP_MENU_ITEM
		do
			if entry_path.count > 1 then
				first_entry := entry_path.item (entry_path.lower)
				menus.find_first (first_entry.name, agent {EL_XDG_DESKTOP_MENU}.name)
				if menus.exhausted then
					menus.extend (create {EL_XDG_DESKTOP_MENU}.make (
						first_entry.name, first_entry.file_name, first_entry.is_standard)
					)
					menus.finish
				end
				menus.item.extend (entry_path.subarray (entry_path.lower + 1, entry_path.upper))
			else
				desktop_entries.extend (entry_path.item (entry_path.lower).file_name)
			end
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["is_standard", 		agent: BOOLEAN_REF do Result := is_standard.to_reference end],
				["is_root", 			agent: BOOLEAN_REF do Result := is_root.to_reference end],
				["menus", 				agent: ITERABLE [EL_XDG_DESKTOP_MENU] do Result := menus end],
				["desktop_entries",	agent: ITERABLE [STRING] do Result := desktop_entries end],
				["name", 				agent: STRING do Result := name end],
				["file_name",			agent: STRING do Result := file_name end]
			>>)
		end

feature {NONE} -- Implementation

	Template: STRING_32 = "[
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
			#evaluate ({EL_XDG_DESKTOP_MENU}.template, $menu)
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

	Encoding_name: EL_ASTRING
		once
			Result := "UTF-8"
		end

end