note
	description: "File naming routines for Windows NT file system (NTFS)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-12 20:14:54 GMT (Friday 12th January 2024)"
	revision: "7"

expanded class
	EL_NT_FILE_SYSTEM_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	STRING_HANDLER

	EL_PATH_CONSTANTS
		export
			{NONE} all
		end

	EL_CHARACTER_32_CONSTANTS; EL_ZSTRING_CONSTANTS

feature -- Conversion

	translated (path: FILE_PATH; uc: CHARACTER_32): FILE_PATH
		-- path with invalid characters in each step translated to `uc' character
		local
			status: NATURAL_8
		do
			status := parent_base_status (path)
			if status = Both_valid then
				Result := path
			else
				Result := path.twin
				translate (Result, uc, status)
			end
		end

	translated_dir_path (path: DIR_PATH; uc: CHARACTER_32): DIR_PATH
		-- path with invalid characters in each step translated to `uc' character
		local
			status: NATURAL_8
		do
			status := parent_base_status (path)
			if status = Both_valid then
				Result := path
			else
				Result := path.twin
				translate (Result, uc, status)
			end
		end

feature -- Status query

	is_valid (path: ZSTRING; is_directory: BOOLEAN): BOOLEAN
		-- True if path is valid on Windows NT file system
		do
			Result := True
			if attached shared_step_intervals (path) as list then
				from list.start until list.after or not Result loop
					Result := is_valid_path_interval (path, is_directory, list.index, list.item_lower, list.item_upper)
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	is_ntfs_character (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '/', '?', '<', '>', '\', ':', '*', '|', '"' then
					Result := True
			else
			end
		end

	is_valid_interval (path: ZSTRING; start_index, end_index: INTEGER): BOOLEAN
		local
			i, i_upper: INTEGER
		do
			if attached path.area as area then
				i_upper := end_index - 1; Result := True
				from i := start_index - 1 until i > i_upper or not Result loop
					Result := not is_ntfs_character (area [i])
					i := i + 1
				end
			end
		end

	is_valid_path_interval (path: ZSTRING; is_directory: BOOLEAN; index, start_index, end_index: INTEGER): BOOLEAN
		-- True if path is valid on Windows NT file system
		do
			if (is_directory and index = 1) then
				if is_volume (path, start_index, end_index) then
					Result := True
				else
					Result := is_valid_interval (path, start_index, end_index)
				end
			else
				Result := is_valid_interval (path, start_index, end_index)
			end
		end

	is_valid_step (step: ZSTRING): BOOLEAN
		local
			i, i_upper: INTEGER
		do
			if attached step.area as area then
				i_upper := step.count - 1
				from i := 0 until i > i_upper loop
					i := i + 1
				end
			end
		end

	is_volume (step: ZSTRING; start_index, end_index: INTEGER): BOOLEAN
		-- C: for example
		do
			if start_index = 1 and end_index = 2 then
				Result := step.is_alpha_item (1) and then step [2] = ':'
			end
		end

	parent_base_status (path: EL_PATH): NATURAL_8
		do
			if is_valid (path.base, False) then
				Result := Base_valid
			end
			if is_valid (path.parent_string (False) , True) then
				Result := Result | Parent_valid
			end
		end

	shared_step_intervals (path: ZSTRING): EL_ZSTRING_SPLIT_INTERVALS
		do
			Result := Once_step_intervals
			Result.fill (path, Separator, 0)
		end

	translate (path: EL_PATH; uc: CHARACTER_32; status: NATURAL_8)
		local
			parent, substitutes: ZSTRING; valid_step: BOOLEAN
			start_index, end_index: INTEGER
		do
			substitutes := char (uc) * Invalid_NTFS_characters.count
			if (status & Parent_valid) = 0 then
				create parent.make (path.parent_count)
				if attached path.parent_string (False) as parent_string
					and then attached shared_step_intervals (parent_string) as list
				then
					from list.start until list.after loop
						start_index := list.item_lower; end_index := list.item_upper
						if list.index > 1 then
							parent.append_character (Separator)
						end
						if is_valid_path_interval (path, True, list.index, start_index, end_index) then
							parent.append_substring (parent_string, start_index, end_index)

						elseif attached parent_string.substring (start_index, end_index) as substring then
							parent.append (substring.translated (Invalid_NTFS_characters, substitutes))
						end
						list.forth
					end
					path.set_parent_path (parent)
				end
			end
			if (status & Base_valid) = 0 then
				path.set_base (path.base.translated (Invalid_NTFS_characters, substitutes))
			end
		end

feature {NONE} -- Status constants

	Base_valid: NATURAL_8 = 1

	Both_valid: NATURAL_8 = 3

	Parent_valid: NATURAL_8 = 2

feature {NONE} -- Constants

	Once_step_intervals: EL_ZSTRING_SPLIT_INTERVALS
		once
			create Result.make (Empty_string, Separator)
		end
end