note
	description: "[
		Compressed filesystem path implemented as an [$source ARRAYED_LIST] of shared path-step tokens
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 16:51:12 GMT (Sunday 13th February 2022)"
	revision: "2"

deferred class
	EL_ZPATH

inherit
	ARRAYED_LIST [INTEGER]
		rename
			make as make_tokens,
			count as step_count,
			last as base_token
		export
			{NONE} all
			{ANY} append, is_equal, step_count, is_empty, prunable
			{EL_ZPATH} area, i_th, occurrences, put_front, put_i_th
		redefine
			default_create, wipe_out
		end

	HASHABLE
		undefine
			copy, default_create, is_equal
		end

	EL_ZPATH_BASE_NAME

	DEBUG_OUTPUT
		rename
			debug_output as as_string_32
		undefine
			copy, default_create, is_equal
		end

feature -- Initialization

	default_create
		do
			make_tokens (0)
		end

	make, set_path (a_path: READABLE_STRING_GENERAL)
		local
			factory: EL_ITERABLE_SPLIT_FACTORY_ROUTINES
		do
			make_tokens (a_path.occurrences (Separator) + 1)
			Step_table.put_tokens (factory.new_split_on_character (a_path, Separator), area)
		ensure
			reversible: to_string.same_string (a_path)
		end

	make_from_steps (a_steps: ITERABLE [READABLE_STRING_GENERAL])
		do
			make_tokens (Iterable.count (a_steps))
			Step_table.put_tokens (a_steps, area)
		ensure
			reversible: filled_list ~ create {like filled_list}.make_from_general (a_steps)
		end

	make_parent (other: EL_ZPATH)
		require
			has_parent: other.has_parent
		local
			count: INTEGER
		do
			count := other.step_count - 1
			make_tokens (count)
			area.copy_data (other.area, 0, 0, count)
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

	parent_string (keep_ref: BOOLEAN): ZSTRING
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
			if keep_ref then
				Result := Result.twin
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
						Result.put_front (Step_table.back_dir_token)
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

	append_path (path: EL_ZPATH)
		require
			enough_steps: step_count >= path.leading_backstep_count
		local
			backstep_count: INTEGER
		do
			backstep_count := path.leading_backstep_count
			area_v2.remove_tail (backstep_count.min (step_count))
			append_subpath (path, backstep_count + 1)
		end

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

feature {EL_ZPATH} -- Implementation

	reset_hash
		do
			internal_hash_code := 0
		end

	remove_tail (n: INTEGER)
		do
			area.remove_tail (n.min (step_count))
			internal_hash_code := 0
		end

feature -- Removal

	wipe_out
		do
			Precursor
			internal_hash_code := 0
		end

feature {EL_ZPATH} -- Internal attributes

	internal_hash_code: INTEGER

feature {NONE} -- Type definitions

	Type_parent: EL_DIR_ZPATH
		require
			never_called: False
		once
			create Result
		end
end