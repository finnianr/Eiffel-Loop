note
	description: "Summary description for {EL_WINDOWS_AERO_THEME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-24 11:13:26 GMT (Friday 24th January 2014)"
	revision: "2"

class
	EL_WINDOWS_AERO_THEME

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

	EL_MODULE_WIN_REGISTRY

create
	make

feature {NONE} -- Initialization

	make
		local
			line_source: EL_FILE_LINE_SOURCE
		do
			create id.make_empty
			create line_source.make (Win_registry.string (HKCU_current_themes, "CurrentTheme"))
			do_with_lines (agent find_theme_section, line_source)
		end

feature -- Access

	id: STRING

	is_classic: BOOLEAN
		do
			Result := id.ends_with ("_CLASSIC")
		end

	is_basic: BOOLEAN
		do
			Result := id.ends_with ("_BASIC")
		end

feature {NONE} -- State handlers

	find_theme_section (line: EL_ASTRING)
		do
			if line.starts_with ("[Theme]") then
				state := agent find_theme_name
			end
		end

	find_theme_name (line: EL_ASTRING)
		do
			id := line.substring (line.substring_index ("IDS_", 1), line.count).to_string_8
			state := agent final
		end

feature {NONE} -- Constants

	HKCU_current_themes: EL_DIR_PATH
		once
			Result := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes"
		end

end
