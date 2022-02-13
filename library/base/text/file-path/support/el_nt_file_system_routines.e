note
	description: "File naming routines for Windows NT file system (NTFS)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 6:38:14 GMT (Sunday 13th February 2022)"
	revision: "5"

expanded class
	EL_NT_FILE_SYSTEM_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_ZSTRING_CONSTANTS

	EL_PATH_CONSTANTS
		export
			{NONE} all
		end

feature -- Conversion

	translated (path: FILE_PATH; uc: CHARACTER_32): FILE_PATH
		-- path with invalid characters in each step translated to `uc' character
		local
			new_path, substitutes: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			if is_valid (path) then
				Result := path
			else
				substitutes := s.n_character_string (uc, Invalid_NTFS_characters.count)
				create new_path.make (path.count)
				across path_steps (path) as step loop
					if step.cursor_index > 1 then
						new_path.append_character (Separator)
					end
					if is_valid_step_at (step.item, step.cursor_index) then
						new_path.append (step.item)
					else
						new_path.append (step.item.translated (Invalid_NTFS_characters, substitutes))
					end
				end
				Result := new_path
			end
		end

feature -- Status query

	is_valid (path: FILE_PATH): BOOLEAN
		-- True if path is valid on Windows NT file system
		do
			Result := True
			across path_steps (path) as step until not Result loop
				Result := is_valid_step_at (step.item, step.cursor_index)
			end
		end

	is_valid_step_at (step: ZSTRING; index: INTEGER): BOOLEAN
		do
			if index = 1 and then step.count = 2 and then step [2] = ':' and then step.is_alpha_item (1) then
				-- C: for example
				Result := True
			else
				Result := is_valid_step (step)
			end
		end

	is_valid_step (step: ZSTRING): BOOLEAN
		do
			Result := not across Invalid_NTFS_characters as c some step.has_z_code (c.z_code) end
		end

feature {NONE} -- Implementation

	path_steps (path: FILE_PATH): EL_SPLIT_ZSTRING_ON_CHARACTER
		do
			Result := Once_path_steps
			Result.set_target (path)
		end

feature {NONE} -- Constants

	Once_path_steps: EL_SPLIT_ZSTRING_ON_CHARACTER
		once
			create Result.make (Empty_string, Separator)
		end

end