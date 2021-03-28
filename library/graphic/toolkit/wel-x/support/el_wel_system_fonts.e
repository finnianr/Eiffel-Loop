note
	description: "[
		Object for installing a new system true type font
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-28 9:36:34 GMT (Sunday 28th March 2021)"
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

	EL_MODULE_REG_KEY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_WINDOWS_VERSION

create
	default_create

feature -- Element change

	install (source_dir: EL_DIR_PATH; font_type: STRING)
			-- install true type fonts
		require
			valid_font_type: Valid_font_types.has (font_type)
		local
			font_path: NATIVE_STRING
			font_name: ZSTRING; package_file: RAW_FILE
		do
			across File_system.files_with_extension (source_dir, font_type, True) as package_path loop
				font_name := package_path.item.base_sans_extension
				if not has_true_type_font (font_name) then
					create package_file.make_with_name (package_path.item)
					File_system.copy_file_contents_to_dir (package_file, System_fonts_dir)
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
				Result [string.item.name.split (',').first.to_string_32] := string.item.value.split (',').first
			end
		end

feature {NONE} -- Constants

	System_fonts_dir: EL_DIR_PATH
		once
			Result := Execution.variable_dir_path ("SystemRoot").joined_dir_path ("Fonts")
		end

	HKLM_fonts: EL_DIR_PATH
		once
			Result := Reg_key.Windows_nt.current_version ("Fonts")
		end

	HKLM_font_substitutes: EL_DIR_PATH
		once
			Result := Reg_key.Windows_nt.current_version ("FontSubstitutes")
		end

	True_type_suffix: STRING = " (TrueType)"

end