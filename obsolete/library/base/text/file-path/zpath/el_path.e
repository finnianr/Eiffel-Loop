note
	description: "[
		Compressed filesystem path implemented as an [$source ARRAYED_LIST] of shared path-step tokens
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-16 17:32:08 GMT (Wednesday 16th February 2022)"
	revision: "6"

deferred class
	EL_PATH

inherit
	EL_PATH_STEPS
		export
			{STRING_HANDLER} internal_base
		end

	HASHABLE
		undefine
			copy, default_create, is_equal
		end

	EL_PATH_BASE_NAME

	DEBUG_OUTPUT
		rename
			debug_output as debug_output_32
		undefine
			copy, default_create, is_equal
		end

convert
 	to_string: {ZSTRING}, to_path: {PATH}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}
	
feature -- Access

	expanded_path: like Current
		do
			Result := twin
			Result.expand
		end

	first_step: ZSTRING
		do
			if is_absolute then
				if step_count > 1 then
					Result := Step_table.to_step (i_th (2)).twin
				else
					create Result.make_empty
				end

			elseif step_count > 0 then
				Result := Step_table.to_step (i_th (1)).twin

			else
				create Result.make_empty
			end
		end

	next_version_path: like Current
			-- Next non existing path with version number before extension
		require
			has_version_number: has_version_number
		do
			Result := twin
			from until not Result.exists loop
				Result.set_version_number (Result.version_number + 1)
			end
		end

	parent: like Type_parent
		do
			if has_parent then
				create Result.make_parent (Current)
			else
				create Result
			end
		end

	parent_string: ZSTRING
		-- path of parent + Separator
		do
			if step_count > 1 then
				Result := to_string
				Result.remove_tail (internal_base.count)
			else
				create Result.make_empty
			end
		end

	relative_path (a_parent: DIR_PATH): EL_PATH
		require
			parent_is_parent: a_parent.is_parent_of (Current)
		deferred
		end

	universal_relative_path (dir_path: DIR_PATH): like Current
		-- path steps of `Current' relative to directory `dir_path' using parent notation `..'
		-- if `dir_path' is not a parent of `Current'
		local
			back_step_count, i: INTEGER
		do
			if dir_path.is_empty then
				Result := Current
			else
				if attached Temporary_dir as common_path then
					common_path.set_from_other (dir_path)
					from until common_path.is_empty or else common_path.is_parent_of (Current) loop
						common_path.remove_tail (1)
						back_step_count := back_step_count + 1
					end
					Result := relative_path (common_path)
				end
				if back_step_count > 0 then
					from i := 1 until i > back_step_count loop
						Result.put_front (Step_table.token_back_dir)
						i := i + 1
					end
				end
			end
		end

	with_new_extension (a_new_ext: READABLE_STRING_GENERAL): like Current
		do
			Result := twin
			if has_dot_extension then
				Result.replace_extension (a_new_ext)
			else
				Result.add_extension (a_new_ext)
			end
		end

	without_extension: like Current
		do
			Result := twin
			Result.remove_extension
		end

feature -- Measurement

	hash_code: INTEGER
		-- Hash code value
		local
			i: INTEGER
		do
			Result := internal_hash_code
			if Result = 0 then
				from i := 1 until i > step_count loop
					Result := ((Result \\ 8388593) |<< 8) + i_th (i)
					i := i + 1
				end
				Result := Result.abs
				internal_hash_code := Result
			end
		end

feature -- Status query

	exists: BOOLEAN
		do
			Result := not is_empty and then File_system.path_exists (Current)
		end

	has_parent: BOOLEAN
		do
			Result := step_count > 1
		end

	is_directory: BOOLEAN
		deferred
		end

	is_file: BOOLEAN
		do
			Result := not is_directory
		end

	is_valid_ntfs: BOOLEAN
		local
			nt: EL_NT_FILE_SYSTEM_ROUTINES
		do
			Result := across filled_list as list all nt.is_valid_step_at (list.item, list.cursor_index) end
		end

feature -- Conversion

	escaped: ZSTRING
		-- escaped for use as command line argument
		-- On Unix characters like colon, space etc are prefixed with a backslash
		-- On Windows this results in a quoted string
		do
			Result := File_system.escaped_path (temporary_path)
		end

	to_path: PATH
		local
			str: STRING_32; buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			str := buffer.empty
			append_to_32 (str)
			create Result.make_from_string (str)
		end

	to_string: ZSTRING
		do
			Result := filled_list.joined (Separator)
		end

	to_string_32, as_string_32: STRING_32
		do
			if attached filled_list as filled then
				create Result.make (step_count - 1 + filled.character_count)
				across filled as list loop
					if not list.is_first then
						Result.append_character (Separator)
					end
					list.item.append_to_string_32 (Result)
				end
			end
		end

	to_unix, as_unix: ZSTRING
		do
			Result := filled_list.joined (Unix_separator)
		end

	to_uri: EL_URI
		local
			uri: like empty_uri_path
		do
			uri := empty_uri_path
			append_to_uri (uri)
			create Result.make (uri)
		end

	to_utf_8: STRING
		do
			across Reuseable.string_8 as reuse loop
				across filled_list as step loop
					if step.cursor_index > 1 then
						reuse.item.append_character (Separator.to_character_8)
					end
					step.item.append_to_utf_8 (reuse.item)
				end
				Result := reuse.item.twin
			end
		end

	to_windows, as_windows: ZSTRING
		do
			Result := filled_list.joined (Windows_separator)
		end

	to_ntfs_compatible (c: CHARACTER): like Current
		-- NT file system compatible path string using `c' to substitue invalid characters
		local
			nt: EL_NT_FILE_SYSTEM_ROUTINES; s: EL_ZSTRING_ROUTINES; substitutes: ZSTRING
			token: INTEGER
		do
			substitutes := s.n_character_string (c, Invalid_NTFS_characters.count)
			Result := twin
			if attached filled_list as filled then
				across filled as list loop
					if not nt.is_valid_step_at (list.item, list.cursor_index) then
						token := Step_table.to_token (list.item.translated (Invalid_NTFS_characters, substitutes))
						Result.put_i_th (token, list.cursor_index)
					end
				end
			end
		end

	sub_path (index_from, index_to: INTEGER): like Current
		require
			valid_indices: (1 <= index_from) and (index_from <= index_to) and (index_to <= step_count)
		local
			l_count: INTEGER
		do
			l_count := index_to - index_from + 1
			if l_count > 0 then
				Result := new_path (l_count)
				Result.area.copy_data (area, index_from - 1, 0, l_count)
			else
				Result := new_path (0)
			end
		end

feature -- Path joining

	joined_dir_steps (a_steps: ITERABLE [READABLE_STRING_GENERAL]): like Current
		local
			l_count: INTEGER
		do
			l_count := Iterable.count (a_steps)
			Result := new_path (step_count + l_count)
			Result.append (Current)
			Step_table.put_tokens (a_steps, Result.area)
		end

feature -- Element change

	append_file_path (a_file_path: EL_FILE_PATH)
		require
			current_not_a_file: not is_file
		do
			append_path (a_file_path)
		end

	set_from_other (other: like Current)
		do
			wipe_out; append (other)
			internal_hash_code := other.internal_hash_code
		end

	share (other: like Current)
		do
			area_v2 := other.area
			internal_hash_code := other.internal_hash_code
		end

	set_parent (dir_path: DIR_PATH)
		local
			step: INTEGER
		do
			step := base_token
			wipe_out
			grow (dir_path.step_count + 1)
			append (dir_path)
			if step > 0 then
				extend (step)
			end
			internal_hash_code := 0
		end

	set_parent_path (a_path: READABLE_STRING_GENERAL)
		local
			step: INTEGER
		do
			step := base_token
			wipe_out
			grow (a_path.occurrences (Separator) + 2)
			Step_table.put_tokens (temporary_copy (a_path).split (Separator), area)
			if step > 0 then
				extend (step)
			end
			internal_hash_code := 0
		end

feature {EL_PATH} -- Implementation

	base_token: INTEGER
		do
			if step_count > 0 then
				Result := last
			end
		end

	debug_output_32: STRING_32
		do
			Result := debug_output
		end

	debug_output: ZSTRING
		local
			l_parent: ZSTRING; cwd: DIR_PATH
		do
			cwd := Directory.current_working.to_string
			if cwd.is_parent_of (Current) then
				l_parent := Variable_cwd; l_parent.append_character (Separator)
				relative_path (cwd).append_to (l_parent)
			else
				l_parent := parent_string
			end
			Result := Debug_template #$ [internal_base, l_parent]
		end

	reset_hash
		do
			internal_hash_code := 0
		end

feature {NONE} -- Type definitions

	Type_parent: DIR_PATH
		require
			never_called: False
		once
			create Result
		end
end