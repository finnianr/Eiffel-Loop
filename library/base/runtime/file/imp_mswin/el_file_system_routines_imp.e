note
	description: "Windows implementation of class ${EL_FILE_SYSTEM_ROUTINES_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-12 13:44:11 GMT (Tuesday 12th March 2024)"
	revision: "19"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I
		redefine
			rename_file
		end

	EL_WINDOWS_IMPLEMENTATION

feature {NONE} -- Implementation

	escaped_path (a_path: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached as_zstring (a_path) as path then
				if path.has (' ') then
					Result := path.quoted (2)
				else
					Result := path
				end
			end
		end

	rename_file (a_file_path, new_file_path: FILE_PATH)
		--	Workaround for the fact that Windows cannot rename files with case-insensitive base-name match
		local
			tweaked_path: FILE_PATH; c: CHARACTER_32; s: EL_ZSTRING_ROUTINES
			tweaked: BOOLEAN
		do
			if s.same_caseless (a_file_path.base, new_file_path.base) then
				tweaked_path := new_file_path.twin
			-- tweak path so that first letter is different and path does not exist
				if attached tweaked_path.base as name and then name.count > 0 then
					from c := name [1] until tweaked loop
						c := c + 1
						name [1] := c
						tweaked := not tweaked_path.exists
					end
				end
				Precursor (a_file_path, tweaked_path)
				Precursor (tweaked_path, new_file_path)
			else
				Precursor (a_file_path, new_file_path)
			end
		end

end