﻿note
	description: "[
		Object for installing a new system true type font
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 10:03:36 GMT (Tuesday 17th May 2016)"
	revision: "8"

class
	EL_WEL_SYSTEM_FONTS

inherit
	WEL_HWND_CONSTANTS
		export
	 		{NONE} all
	 	end

	WEL_WINDOW_CONSTANTS
		export
	 		{NONE} all
	 	end

	EL_MODULE_WIN_REGISTRY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	default_create

feature -- Element change

	install (source_dir: EL_DIR_PATH; font_type: STRING)
			-- install true type fonts
		require
			valid_font_type: Valid_font_types.has (font_type)
		local
			font_path: NATIVE_STRING
			font_name: ZSTRING
		do
			across File_system.file_list (source_dir, "*." + font_type) as package_path loop
				font_name := package_path.item.without_extension.base
				if not has_true_type_font (font_name) then
					File_system.copy (package_path.item, System_fonts_dir)
					create font_path.make ((System_fonts_dir + package_path.item.base).to_string.to_unicode)
					if {EL_WEL_API}.add_font_resource (font_path.item) > 0 then
						{WEL_API}.send_message (Hwnd_broadcast, Wm_fontchange, Default_pointer, Default_pointer)
						Win_registry.set_string (HKLM_fonts, font_name + True_type_suffix, package_path.item.base)
					end
				end
			end
		end

feature {NONE} -- Implementation

	has_true_type_font (font_name: ZSTRING): BOOLEAN
		local
			font_registry_name: ZSTRING
		do
			font_registry_name := font_name + True_type_suffix
			Result := across Win_registry.value_names (HKLM_fonts) as value some
				value.name ~ font_registry_name
			end
		end

feature -- Constants

	Valid_font_types: ARRAY [STRING]
		once
			Result := << "fon", "fnt", "ttf", "ttc", "fot", "otf", "mmm", "pfb", "pfm" >>
			Result.compare_objects
		end

	Substitute_fonts: HASH_TABLE [ZSTRING, STRING_32]
		once
			create Result.make_equal (30)
			across Win_registry.string_list (HKLM_font_substitutes) as string loop
				Result [string.item.name.split (',').first.to_unicode] := string.item.value.split (',').first
			end
		end

feature {NONE} -- Constants

	System_fonts_dir: EL_DIR_PATH
		once
			Result := Execution.variable_dir_path ("SystemRoot").joined_dir_path ("Fonts")
		end

	HKLM_fonts: EL_DIR_PATH
		once
			Result := HKLM_windows_current_version.joined_dir_path ("Fonts")
		end

	HKLM_font_substitutes: EL_DIR_PATH
		once
			Result := HKLM_windows_current_version.joined_dir_path ("FontSubstitutes")
		end

	HKLM_windows_current_version: EL_DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
		end

	True_type_suffix: STRING = " (TrueType)"

end
