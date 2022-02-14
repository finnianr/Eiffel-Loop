note
	description: "[
		Compressed filesystem path implemented as an [$source ARRAYED_LIST] of shared path-step tokens
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 18:51:48 GMT (Monday 14th February 2022)"
	revision: "3"

deferred class
	EL_ZPATH

inherit
	EL_ZPATH_STEPS

	HASHABLE
		undefine
			copy, default_create, is_equal
		end

	EL_ZPATH_BASE_NAME

	DEBUG_OUTPUT
		rename
			debug_output as debug_output_32
		undefine
			copy, default_create, is_equal
		end

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
		require
			has_parent: has_parent
		local
			l_token: INTEGER
		do
			if step_count > 1 then
				l_token := base_token
				remove_tail (1)
				Result := to_string
				extend (l_token)
			else
				create Result.make_empty
			end
		end

	relative_path (a_parent: EL_DIR_ZPATH): EL_ZPATH
		require
			parent_is_parent: a_parent.is_parent_of (Current)
		deferred
		end

	universal_relative_path (dir_path: EL_DIR_ZPATH): like Current
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
			Result := not is_empty and then File_system.path_exists (to_obsolete)
		end

	has_parent: BOOLEAN
		do
			Result := step_count > 1
		end

	has_step (a_step: READABLE_STRING_GENERAL): BOOLEAN
			-- true if path has directory step
		do
			Result := across filled_list as list some list.item.same_string (a_step) end
		end

	is_directory: BOOLEAN
		deferred
		end

	is_file: BOOLEAN
		do
			Result := not is_directory
		end

	is_uri: BOOLEAN
		do
		end

	is_valid_ntfs: BOOLEAN
		local
			nt: EL_NT_FILE_SYSTEM_ROUTINES
		do
			Result := across filled_list as list all nt.is_valid_step_at (list.item, list.cursor_index) end
		end

feature -- Conversion

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

	to_obsolete: EL_PATH
		-- obsolete form of path
		deferred
		end

feature -- Path joining

	joined_dir_steps (a_steps: ITERABLE [READABLE_STRING_GENERAL]): like Current
		local
			count: INTEGER
		do
			count := Iterable.count (a_steps)
			Result := new_path (step_count + count)
			Result.append (Current)
			Step_table.put_tokens (a_steps, Result.area)
		end

feature -- Element change

	append_dir_path (a_dir_path: EL_DIR_ZPATH)
		do
			append_path (a_dir_path)
		end

	append_file_path (a_file_path: EL_FILE_ZPATH)
		require
			current_not_a_file: not is_file
		do
			append_path (a_file_path)
		end

	append_path (path: EL_ZPATH)
		require
			enough_steps: step_count >= path.leading_backstep_count
		local
			backstep_count: INTEGER
		do
			backstep_count := path.leading_backstep_count
			if backstep_count > 0 then
				area_v2.remove_tail (backstep_count.min (step_count))
				append_subpath (path, backstep_count + 1)
			else
				append (path)
			end
		end

	append_step (a_step: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_BUFFER_ROUTINES
		do
			extend (Step_table.to_token (s.copied_general (a_step)))
			internal_hash_code := 0
		end

	expand
		-- expand environment variables in each step
		local
			factory: EL_ITERABLE_SPLIT_FACTORY_ROUTINES; new_tokens: ARRAYED_LIST [INTEGER]
		do
			if attached filled_list as filled and then filled.there_exists (agent has_expansion_variable) then
				create new_tokens.make (step_count)
				across filled as list loop
					if has_expansion_variable (list.item)
						and then attached Execution_environment.item (variable_name (list.item)) as value
					then
						new_tokens.grow (new_tokens.count + value.occurrences (Separator) + 1)
						Step_table.put_tokens (factory.new_split_on_character (value, Separator), new_tokens.area)
					else
						new_tokens.extend (i_th (list.cursor_index))
					end
				end
				area_v2 := new_tokens.area
			end
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

	set_parent (dir_path: EL_DIR_ZPATH)
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

feature {EL_ZPATH} -- Implementation

	append_subpath (path: EL_ZPATH; from_index: INTEGER)
		require
			valid_index: 1 <= from_index and then from_index <= path.step_count
		local
			i: INTEGER
		do
			grow (step_count + path.step_count - from_index + 1)
			from i := from_index until i > path.step_count loop
				extend (path [i])
				i := i + 1
			end
			internal_hash_code := 0
		end

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
			l_parent: ZSTRING; cwd: EL_DIR_ZPATH
		do
			cwd := Directory.current_working.to_string
			if cwd.is_parent_of (Current) then
				l_parent := Variable_cwd; l_parent.append_character (Separator)
				relative_path (cwd).append_to (l_parent)
			else
				l_parent := parent_string
			end
			Result := Debug_template #$ [base, l_parent]
		end

	reset_hash
		do
			internal_hash_code := 0
		end

	remove_tail (n: INTEGER)
		do
			area.remove_tail (n.min (step_count))
			internal_hash_code := 0
		end

feature {NONE} -- Type definitions

	Type_parent: EL_DIR_ZPATH
		require
			never_called: False
		once
			create Result
		end
end