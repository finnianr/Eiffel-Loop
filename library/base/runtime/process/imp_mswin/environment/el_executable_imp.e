note
	description: "Windows implementation of [$source EL_EXECUTABLE_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "4"

class
	EL_EXECUTABLE_IMP

inherit
	EL_EXECUTABLE_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

	EL_MS_WINDOWS_DIRECTORIES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Implementation

	search_path_has (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if executable `name' is in the environment search path `PATH'
		local
			name_path: FILE_PATH
		do
			create name_path.make (a_name)
			if name_path.has_dot_extension and then File_extensions.has (name_path.extension) then
				across search_path_list as l_path until Result loop
					name_path.set_parent (l_path.item)
					Result := name_path.exists
				end
			else
				name_path.add_extension (File_extensions.first)
				across search_path_list as l_path until Result loop
					name_path.set_parent (l_path.item)
					-- Test existence for all extensions
					across File_extensions as extension until Result loop
						name_path.replace_extension (extension.item)
						Result := name_path.exists
					end
				end
			end
		end

feature {NONE} -- Constants

	File_extensions: EL_ZSTRING_LIST
		local
			csv_values: ZSTRING
		once
			-- C:\Users\finnian>echo %PATHEXT%
			-- .COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
			csv_values := Executable_extensions_spec
			csv_values.remove_head (1)
			csv_values.to_lower
			csv_values.replace_substring_general_all (";.", ",")
			Result := csv_values
		end

	Search_path_separator: CHARACTER_32 = ';'

end