note
	description: "Path name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 17:09:47 GMT (Monday 25th May 2020)"
	revision: "39"

deferred class
	EL_PATH

inherit
	HASHABLE
		redefine
			is_equal, default_create, out, copy
		end

	COMPARABLE
		undefine
			is_equal, default_create, out, copy
		end

	EL_PATH_IMPLEMENTATION
		undefine
			is_equal, default_create, out, copy
		end

feature {NONE} -- Initialization

	default_create
		do
			parent_path := Empty_path; base := Empty_path
		end

	make_from_other (other: EL_PATH)
		do
			base := other.base.twin
			parent_path := other.parent_path
			internal_hash_code := other.internal_hash_code
			out_abbreviated := other.out_abbreviated
		ensure
			same_string: to_string ~ other.to_string
		end

	make_from_path (a_path: PATH)
		do
			make (a_path.name)
		end

	make_from_steps (a_steps: ITERABLE [READABLE_STRING_GENERAL])
		local
			l_path: ZSTRING; not_first: BOOLEAN
		do
			l_path := Temp_path; l_path.wipe_out
			across a_steps as step loop
				if not_first then
					l_path.append_character (Separator)
				else
					not_first := True
				end
				l_path.append_string_general (step.item)
			end
			set_path (l_path)
		end

feature -- Initialization

	make, set_path (a_path: READABLE_STRING_GENERAL)
			--
		local
			pos_last_separator: INTEGER l_path: ZSTRING
		do
			l_path := temporary_copy (a_path)
			-- Normalize path
			if not is_uri and then {PLATFORM}.is_windows and then a_path.has (Unix_separator) then
				l_path.replace_character (Unix_separator, Separator)
			end
			if not l_path.is_empty then
				pos_last_separator := l_path.last_index_of (Separator, l_path.count)
				if pos_last_separator = 0 then
					if not is_uri and then {PLATFORM}.is_windows then
						pos_last_separator := l_path.last_index_of (':', l_path.count)
					end
				end
			end
			base := l_path.substring_end (pos_last_separator + 1)
			l_path.keep_head (pos_last_separator)
			set_parent_path (l_path)
		end

feature -- Access

	base: ZSTRING

	base_sans_extension: ZSTRING
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				Result := base.substring (1, index - 1)
			else
				Result := base
			end
		end

	expanded_path: like Current
		do
			Result := twin
			Result.expand
		end

	extension: ZSTRING
			--
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				Result := base.substring_end (index + 1)
			else
				create Result.make_empty
			end
		end

	first_step: ZSTRING
		local
			pos_first_separator, pos_second_separator: INTEGER
		do
			if parent_path.is_empty then
				Result := base
			else
				if is_absolute then
					pos_first_separator := parent_path.index_of (Separator, 1)
					if pos_first_separator = parent_path.count then
						Result := base
					else
						pos_second_separator := parent_path.index_of (Separator, pos_first_separator + 1)
						Result := parent_path.substring (pos_first_separator + 1, pos_second_separator - 1)
					end
				else
					Result := parent_path.substring (1, parent_path.index_of (Separator, 1) - 1)
				end
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
				create Result.make_from_other (Current)
				Result.remove_base
			else
				create Result
			end
		end

	relative_path (a_parent: EL_DIR_PATH): EL_PATH
		require
			parent_is_parent: a_parent.is_parent_of (Current)
		deferred
		end

	to_unix, as_unix: like Current
		do
			Result := twin
			Result.change_to_unix
		end

	to_windows, as_windows: like Current
		do
			Result := twin
			Result.change_to_windows
		end

	translated (originals, substitutions: ZSTRING): like Current
		do
			Result := twin
			Result.translate (originals, substitutions)
		end

	universal_relative_path (dir_path: EL_DIR_PATH): like Current
		-- path steps of `Current' relative to directory `dir_path' using parent notation `..'
		-- if `dir_path' is not a parent of `Current'
		local
			back_step_count: INTEGER; common_path: EL_DIR_PATH
		do
			if dir_path.is_empty then
				Result := Current
			else
				from common_path := dir_path until common_path.is_parent_of (Current) loop
					common_path := common_path.parent
					back_step_count := back_step_count + 1
				end
				Result := relative_path (common_path)
				if back_step_count > 0 then
					Result.set_parent_path (Back_dir_step.multiplied (back_step_count) + Result.parent_path)
				end
			end
		end

	version_interval: INTEGER_INTERVAL
		local
			intervals: like base.substring_intervals
			found: BOOLEAN
		do
			intervals := base.split_intervals (Single_dot)
			from intervals.finish until found or else intervals.before loop
				if base.substring (intervals.item_lower, intervals.item_upper).is_natural then
					found := True
				else
					intervals.back
				end
			end
			if found then
				Result := intervals.item_interval
			else
				Result := 1 |..| 0
			end
		end

	version_number: INTEGER
			-- Returns value of numeric value immediately before extension and separated by dots
			-- Minus one if no version number found

			-- Example: "myfile.02.mp3" returns 2
		local
			number: EL_ZSTRING; interval: like version_interval
		do
			interval := version_interval
			if interval.is_empty then
				Result := -1
			else
				number := base.substring (interval.lower, interval.upper)
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
			i, j, nb: INTEGER; part: ZSTRING
			l_area: like base.area
		do
			Result := internal_hash_code
			if Result = 0 then
				from j := 1 until j > part_count loop
					part := part_string (j)
					l_area := part.area; nb := part.count
					from i := 0 until i = nb loop
						Result := ((Result \\ Magic_number) |<< 8) + l_area.item (i).code
						i := i + 1
					end
					j := j + 1
				end
				internal_hash_code := Result
			end
		end

feature -- Status Query

	base_matches (name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `name' is same string as `base_sans_extension'
		local
			end_pos: INTEGER
		do
			end_pos := dot_index
			if end_pos > 0 then
				end_pos := end_pos - 1
			else
				end_pos := base.count
			end
			Result := name.same_characters (base, 1, end_pos, 1)
		ensure
			valid_result: Result implies base_sans_extension.same_string (name)
		end

	exists: BOOLEAN
		do
			Result := not is_empty and then File_system.path_exists (Current)
		end

	has_dot_extension: BOOLEAN
		do
			Result := dot_index > 0
		end

	has_extension (a_extension: READABLE_STRING_GENERAL): BOOLEAN
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				Result := base.same_characters (a_extension, 1, a_extension.count, index + 1)
			end
		end

	has_parent: BOOLEAN
		local
			l_count: INTEGER
		do
			l_count := parent_path.count
			if is_absolute then
				Result := not base.is_empty and then l_count >= 1 and then parent_path [l_count] = Separator
			else
				Result := not parent_path.is_empty and then parent_path [l_count] = Separator
			end
		end

	has_step (step: ZSTRING): BOOLEAN
			-- true if path has directory step
		local
			pos_left_separator, pos_right_separator: INTEGER
		do
			pos_left_separator := parent_path.substring_index (step, 1) - 1
			pos_right_separator := pos_left_separator + step.count + 1
			if 0 <= pos_left_separator and pos_right_separator <= parent_path.count then
				if parent_path [pos_right_separator] = Separator then
					Result := pos_left_separator > 0 implies parent_path [pos_left_separator] = Separator
				end
			end
		end

	has_version_number: BOOLEAN
		do
			Result := version_number >= 0
		end

	is_absolute: BOOLEAN
		local
			str: ZSTRING
		do
			str := parent_path
			if {PLATFORM}.is_windows then
				Result := Zstring.starts_with_drive (str)
			else
				Result := not str.is_empty and then str [1] = Separator
			end
		end

	is_directory: BOOLEAN
		deferred
		end

	is_empty: BOOLEAN
		do
			Result := parent_path.is_empty and base.is_empty
		end

	is_file: BOOLEAN
		do
			Result := not is_directory
		end

	is_uri: BOOLEAN
		do
		end

	is_valid_on_ntfs: BOOLEAN
			-- True if path is valid on Windows NT file system
		local
			i: INTEGER; l_characters: like Invalid_ntfs_characters_32
			uc: CHARACTER_32; found: BOOLEAN
		do
			l_characters := Invalid_ntfs_characters_32
			from i := 1 until found or i > l_characters.count loop
				uc := l_characters [i]
				if not ({PLATFORM}.is_unix and uc = '/') then
					found := base.has (uc) or else parent_path.has (uc)
				end
				i := i + 1
			end
			Result := not found
		end

	out_abbreviated: BOOLEAN
		-- is the current directory in 'out string' abbreviated to $CWD

feature -- Status change

	enable_out_abbreviation
		do
			out_abbreviated := True
		end

feature -- Element change

	add_extension (a_extension: READABLE_STRING_GENERAL)
		local
			str: ZSTRING
		do
			create str.make (base.count + a_extension.count + 1)
			str.append (base); str.append_character ('.'); str.append_string_general (a_extension)
			base := str
			internal_hash_code := 0
		end

	append_dir_path (a_dir_path: EL_DIR_PATH)
		do
			append (a_dir_path)
		end

	append_file_path (a_file_path: EL_FILE_PATH)
		require
			current_not_a_file: not is_file
		do
			append (a_file_path)
		end

	append_step (a_step: READABLE_STRING_GENERAL)
		require
			is_step: not a_step.has (Separator)
		local
			l_parent_path: like parent_path
		do
			create l_parent_path.make (parent_path.count + base.count + 1)
			l_parent_path.append (parent_path)
			if not base.is_empty then
				l_parent_path.append (base)
				l_parent_path.append_character (Separator)
			end
			set_parent_path (l_parent_path)
			base.wipe_out
			base.append_string_general (a_step)
		end

	change_to_unix
		do
			if {PLATFORM}.is_windows then
				replace_separator (Windows_separator, Unix_separator)
			end
		end

	change_to_windows
		do
			if not {PLATFORM}.is_windows then
				replace_separator (Unix_separator, Windows_separator)
			end
		end

	expand
			-- expand environment variables in each step
		local
			l_steps: like steps
		do
			if is_potenially_expandable (parent) or else is_potenially_expandable (base) then
				l_steps := steps
				l_steps.expand_variables
				base := l_steps.last.twin
				l_steps.remove_tail (1)
				set_parent_path (l_steps.to_string)
			end
		end

	rename_base (new_name: ZSTRING; preserve_extension: BOOLEAN)
			-- set new base to new_name, preserving extension if preserve_extension is True
		local
			l_extension: like extension
		do
			l_extension := extension
			base.copy (new_name)
			if preserve_extension and then not has_extension (l_extension) then
				add_extension (l_extension)
			end
			internal_hash_code := 0
		end

	replace_extension (a_replacement: READABLE_STRING_GENERAL)
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				base.replace_substring_general (a_replacement, index + 1, base.count)
			end
			internal_hash_code := 0
		end

	set_base (a_base: READABLE_STRING_GENERAL)
		do
			base := Zstring.as_zstring (a_base)
			internal_hash_code := 0
		end

	set_parent_path (a_parent: READABLE_STRING_GENERAL)
		local
			set: like Parent_set; l_path: ZSTRING
		do
			if a_parent.is_empty then
				parent_path := Empty_path
			else
				l_path := temporary_copy (a_parent)
				if a_parent [a_parent.count] /= Separator then
					l_path.append_character (Separator)
				end
				set := Parent_set
				if set.has_key (l_path) then
					parent_path := set.found_item
				else
					parent_path := l_path.twin
					set.extend (parent_path)
				end
			end
			internal_hash_code := 0
		end

	set_version_number (number: like version_number)
		require
			has_version_number: has_version_number
		local
			interval: like version_interval
		do
			interval := version_interval
			base.replace_substring_general (Format.integer_zero (number, interval.count), interval.lower, interval.upper)
			internal_hash_code := 0
		end

	share (other: like Current)
		do
			base := other.base
			parent_path := other.parent_path
			internal_hash_code := other.internal_hash_code
		end

	translate (originals, substitutions: ZSTRING)
		do
			base.translate (originals, substitutions)
			parent_path.translate (originals, substitutions)
			internal_hash_code := 0
		end

feature -- Removal

	remove_extension
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				base.remove_tail (base.count - index + 1)
			end
		end

	wipe_out
		do
			default_create
		ensure
			is_empty: is_empty
		end

feature -- Conversion

	escaped: ZSTRING
		do
			Result := File_system.escaped_path (temporary_path)
		end

	out: STRING
		local
			l_out: like to_string
		do
			l_out := to_string
			if out_abbreviated then
				-- Replaces String.abbreviate_working_directory
				l_out.replace_substring_all (Directory.current_working.to_string, Variable_cwd)
			end
			Result := l_out
		end

	steps: EL_PATH_STEPS
			--
		do
			create Result.make_from_path (Current)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := base.is_equal (other.base) and parent_path.is_equal (other.parent_path)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if parent_path ~ other.parent_path then
				Result := base < other.base
			else
				Result := parent_path < other.parent_path
			end
		end

feature -- Duplication

	copy (other: like Current)
		do
			make_from_other (other)
		end

feature {EL_PATH_IMPLEMENTATION, STRING_HANDLER} -- Internal attributes

	internal_hash_code: INTEGER

	parent_path: ZSTRING

feature {EL_PATH} -- Implementation

	remove_base
		require
			has_parent: has_parent
		local
			pos_separator, pos_last_separator: INTEGER
			l_path: ZSTRING
		do
			pos_last_separator := parent_path.count
			if pos_last_separator = 1 then
				base.wipe_out
				internal_hash_code := 0
			else
				pos_separator := parent_path.last_index_of (Separator, pos_last_separator - 1)
				base := parent_path.substring (pos_separator + 1, pos_last_separator - 1)
				l_path := Temp_path; l_path.wipe_out
				l_path.append_substring (parent_path, 1, pos_separator)
				set_parent_path (l_path)
			end
		end

feature {NONE} -- Type definitions

	Type_parent: EL_DIR_PATH
		require
			never_called: False
		once
		end

invariant
	parent_set_has_parent_path: parent_path /= Empty_path implies Parent_set.has (parent_path)
end
