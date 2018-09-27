note
	description: "XDG desktop menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "7"

deferred class
	EL_XDG_DESKTOP_MENU_ITEM

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			getter_function_table
		end

	EL_INSTALLER_DEBUG

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (a_item: like item)
			--
		do
			item := a_item
			make_from_file (new_file_path)
		end

feature -- Access

	file_name: ZSTRING
		do
			Result := item.name.translated_general (" ", "-") + "." + file_name_extension
		end

	name: ZSTRING
		do
			Result := item.name
		end

feature -- Status query

	exists: BOOLEAN
		do
			Result := output_path.exists
		end

	is_standard: BOOLEAN
		do
			Result := item.is_standard
		end

feature -- Basic operations

	install
			--
		do
			if not output_path.exists then
				if is_lio_enabled then
					lio.put_path_field ("Creating entry", output_path)
					lio.put_new_line
				end
				serialize
			end
		end

	uninstall
			--
		do
			if output_path.exists then
				if is_lio_enabled then
					lio.put_path_field ("Deleting entry", output_path)
					lio.put_new_line
				end
				File_system.remove_file (output_path)
			end
		end

feature {NONE} -- Implementation

	file_name_extension: STRING
			--
		deferred
		end

	new_file_path: EL_FILE_PATH
		deferred
		end

feature {NONE} -- Internal attributes

	item: EL_DESKTOP_MENU_ITEM

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["icon_path", agent: EL_PATH do Result := item.icon_path end],
				["comment", agent: ZSTRING do Result := item.comment end],
				["name", agent name]
			>>)
		end

feature {NONE} -- Constants

	Applications_desktop_dir: EL_DIR_PATH
			--
		once
			Result := "/usr/share/applications"
			if_installer_debug_enabled (Result)
			-- Workbench debug: "$HOME/.local/share/applications"
		end

	Directories_desktop_dir: EL_DIR_PATH
			--
		once
			Result := "/usr/share/desktop-directories"
			if_installer_debug_enabled (Result)
			-- Workbench debug: $HOME/.local/share/desktop-directories
		end

end
