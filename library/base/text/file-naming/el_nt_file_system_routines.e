note
	description: "File naming routines for Windows NT file system (NTFS)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-18 13:49:38 GMT (Thursday 18th March 2021)"
	revision: "1"

expanded class
	EL_NT_FILE_SYSTEM_ROUTINES

feature -- Conversion

	translated (path: EL_FILE_PATH; uc: CHARACTER_32): EL_FILE_PATH
		-- path with invalid characters in each step translated to `uc' character
		local
			new_path, substitutes: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			if is_valid (path) then
				Result := path
			elseif attached path_steps (path) as steps then
				substitutes := s.n_character_string (uc, Invalid_NTFS_characters.count)
				create new_path.make (path.count)
				from steps.start until steps.after loop
					if steps.index > 1 then
						new_path.append_character (Separator)
					end
					if is_valid_step (steps.item (False), steps.index) then
						new_path.append (steps.item (False))
					else
						new_path.append (steps.item (False).translated (Invalid_NTFS_characters, substitutes))
					end
					steps.forth
				end
				Result := new_path
			end
		end

feature -- Status query

	is_valid (path: EL_FILE_PATH): BOOLEAN
		-- True if path is valid on Windows NT file system
		do
			if attached path_steps (path) as steps then
				Result := True
				from steps.start until not Result or else steps.after loop
					Result := is_valid_step (steps.item (False), steps.index)
					steps.forth
				end
			end
		end

	is_valid_step (step: ZSTRING; index: INTEGER): BOOLEAN
		do
			if index = 1 and then step.count = 2 and then step [2] = ':' and then step.is_alpha_item (1) then
				-- C: for example
				Result := True
			else
				Result := not across Invalid_NTFS_characters as c some step.has_z_code (c.z_code) end
			end
		end

feature {NONE} -- Implementation

	path_steps (path: EL_FILE_PATH): EL_SPLIT_ZSTRING_LIST
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := Once_path_steps
			Result.set_string (path, s.character_string (Separator))
		end

feature {NONE} -- Constants

	Invalid_NTFS_characters: ZSTRING
		-- path characters that are invalid for a Windows NT file system
		once
			create Result.make_from_general ("/?<>\:*|%"")
		end

	Separator: CHARACTER
		once
			Result := Operating_environment.Directory_separator
		end

	Once_path_steps: EL_SPLIT_ZSTRING_LIST
		once
			create Result.make_empty
		end

end