note
	description: "Windows implementation of class [$source EL_FILE_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "15"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I
		redefine
			rename_file
		end

	EL_OS_IMPLEMENTATION
		rename
			copy as copy_object
		end

feature {NONE} -- Implementation

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		local
			l_path: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			l_path := s.as_zstring (path)
			if l_path.has (' ') then
				Result := l_path.quoted (2)
			else
				Result := l_path
			end
		end

	rename_file (a_file_path, new_file_path: FILE_PATH)
		local
			modified_path: FILE_PATH
		do
			if same_caseless (a_file_path.base, new_file_path.base) and then attached new_file_path.base as new_base then
--				Workaround for fact Windows does not rename files with case-insensitive base match
				new_base.append_character ('_')
				Precursor (a_file_path, new_file_path)
				
				modified_path := new_file_path.twin
				new_base.remove_tail (1)
				Precursor (modified_path, new_file_path)
			else
				Precursor (a_file_path, new_file_path)
			end
		end

	same_caseless (base, new_base: ZSTRING): BOOLEAN
		do
			if base.count = new_base.count then
				Result := base.same_caseless_characters_general (new_base, 1, new_base.count, 1)
			end
		end

end