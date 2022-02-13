note
	description: "[
		Compressed filesystem path implemented as an [$source ARRAYED_LIST] of shared path-step tokens
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 12:33:34 GMT (Sunday 13th February 2022)"
	revision: "1"

deferred class
	EL_ZPATH

inherit
	ARRAYED_LIST [INTEGER]
		rename
			make as make_tokens,
			count as step_count
		export
			{NONE} all
			{ANY} append, is_equal, step_count, is_empty
			{EL_ZPATH} area, i_th, occurrences, put_front, put_i_th
		redefine
			default_create
		end

	EL_ZPATH_IMPLEMENTATION

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

feature -- Access

	base: ZSTRING
		do
			Result := Shared_base
			Result.wipe_out
			Result.append (internal_base)
		end

	base_sans_extension: ZSTRING
		do
			Result := base_part (1)
		end

	expanded_path: like Current
		do
			Result := twin
			Result.expand
		end

	extension: ZSTRING
		do
			Result := base_part (2)
		end

	first_step: ZSTRING
		local
			pos_first_separator, pos_second_separator: INTEGER
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

	version_interval: EL_SPLIT_ZSTRING_LIST
		-- `Result.item' is last natural number between two dots
		-- if `Result.off' then there is no interval
		do
			create Result.make (base, '.')
			from Result.finish until Result.before or else Result.item.is_natural loop
				Result.back
			end
		end

	version_number: INTEGER
			-- value of numeric value immediately before extension and separated by dots
			-- `-1' if no version number found

			-- Example: "myfile.02.mp3" returns 2
		do
			if attached version_interval as interval then
				if interval.off then
					Result := -1
				elseif attached base.substring (interval.item_start_index, interval.item_end_index) as number then
					number.prune_all_leading ('0')
					if number.is_empty then
						Result := 0
					elseif number.is_integer then
						Result := number.to_integer
					else
						Result := -1
					end
				end
			end
		end

feature -- Status query

	exists: BOOLEAN
		do
			Result := not is_empty and then File_system.path_exists (to_obsolete)
		end

	has_version_number: BOOLEAN
		do
			Result := not version_interval.off
		end

	is_absolute: BOOLEAN
		do
			Result := step_count > 0 and then i_th (1) <= Step_table.last_drive_token
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

	set_version_number (number: like version_number)
		require
			has_version_number: has_version_number
		do
			if step_count > 0 and then attached version_interval as interval and then not interval.off
				and then attached base as l_base
			then
				l_base.replace_substring_general (
					Format.integer_zero (number, interval.item_count), interval.item_start_index, interval.item_end_index
				)
				put_i_th (Step_table.to_token (l_base), step_count)
				internal_hash_code := 0
			end
		ensure
			is_set: version_number = number
		end

feature {EL_ZPATH} -- Implementation

	remove_tail (n: INTEGER)
		do
			area.remove_tail (n.min (step_count))
			internal_hash_code := 0
		end

feature {EL_ZPATH} -- Internal attributes

	internal_hash_code: INTEGER

end