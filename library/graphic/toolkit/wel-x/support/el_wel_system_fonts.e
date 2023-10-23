note
	description: "[
		Object for installing a new system true type font
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-23 8:29:30 GMT (Saturday 23rd September 2023)"
	revision: "15"

class
	EL_WEL_SYSTEM_FONTS

inherit
	EL_FONT_REGISTRY_ROUTINES

	WEL_HWND_CONSTANTS
		export
	 		{NONE} all
	 	end

	WEL_WINDOW_CONSTANTS
		export
	 		{NONE} all
	 	end

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_MODULE_WINDOWS_VERSION

create
	default_create

feature -- Element change

	install (source_dir: DIR_PATH; font_type: STRING)
			-- install true type fonts
		require
			valid_font_type: Valid_font_types.has (font_type)
		local
			font_path: NATIVE_STRING
			font_name: ZSTRING; package_file: RAW_FILE
		do
			across File_system.files_with_extension (source_dir, font_type, True) as package_path loop
				font_name := package_path.item.base_name
				if not has_true_type_font (font_name) then
					create package_file.make_with_name (package_path.item)
					File.copy_contents_to_dir (package_file, System_fonts_dir)
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

feature {NONE} -- Constants

	System_fonts_dir: DIR_PATH
		once
			Result := Execution.variable_dir_path ("SystemRoot") #+ "Fonts"
		end

end