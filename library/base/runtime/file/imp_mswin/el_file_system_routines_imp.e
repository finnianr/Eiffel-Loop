note
	description: "Windows implementation of class ${EL_FILE_SYSTEM_ROUTINES_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 12:11:25 GMT (Thursday 8th May 2025)"
	revision: "20"

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
			tweaked_path: FILE_PATH; first: CHARACTER_32; tweaked: BOOLEAN
		do
			if super_z (a_file_path.base).same_caseless (new_file_path.base) then
				tweaked_path := new_file_path.twin
			-- tweak path so that first letter is different and path does not exist
				if attached tweaked_path.base as base and then base.count > 0 then
					from first := base [1] until tweaked loop
						first := first + 1
						base [1] := first
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