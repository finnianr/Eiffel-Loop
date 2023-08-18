note
	description: "Path name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 13:03:27 GMT (Friday 18th August 2023)"
	revision: "69"

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

	EL_PATH_BASE_NAME

	EL_PATH_IMPLEMENTATION
		undefine
			is_equal, default_create, out, copy
		end

	EL_SHARED_WORD

convert
	to_string: {EL_ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
	steps: {EL_PATH_STEPS}, to_path: {PATH}, to_uri: {EL_URI}

feature {NONE} -- Initialization

	default_create
		do
			parent_path := Empty_path; base := Empty_path
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

	make_from_other (other: EL_PATH)
		do
			base := other.base.twin
			parent_path := other.parent_path
			internal_hash_code := other.internal_hash_code
		ensure
			same_string: same_as (other.to_string)
		end

	make (a_path: READABLE_STRING_GENERAL)
			--
		local
			pos_last_separator: INTEGER; l_path: ZSTRING
		do
			l_path := normalized_copy (a_path)
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

	type_alias: ZSTRING
		-- localized description "file", "directory" or "URI"
		deferred
		end

	expanded_path: like Current
		do
			Result := twin
			Result.expand
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
				Result.prune_tail
			else
				create Result
			end
		end

	parent_string (keep_ref: BOOLEAN): ZSTRING
		do
			if keep_ref then
				create Result.make_from_other (parent_path)
			else
				Result := parent_path
			end
		end

	relative_path (a_parent: EL_DIR_PATH): EL_PATH
		require
			parent_is_parent: a_parent.is_parent_of (Current)
		deferred
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
				from common_path := dir_path.twin until common_path.is_parent_of (Current) loop
					common_path.prune_tail
					back_step_count := back_step_count + 1
				end
				Result := relative_path (common_path)
				if back_step_count > 0 then
					Result.set_parent_path (Back_dir_step.multiplied (back_step_count) + Result.parent_path)
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
				from i := 1 until i > part_count loop
					Result := Result + part_string (i).hash_code
					i := i + 1
				end
				Result := Result.abs
				internal_hash_code := Result
			end
		end

feature -- Status Query

	exists: BOOLEAN
		do
			Result := not is_empty and then File_system.path_exists (Current)
		end

	has_parent: BOOLEAN
		local
			l_count: INTEGER
		do
			l_count := parent_path.count
			if is_absolute then
				Result := not base.is_empty and then l_count >= 1 and then is_separator (parent_path, l_count)
			else
				Result := not parent_path.is_empty and then is_separator (parent_path, l_count)
			end
		end

	has_step (a_step: READABLE_STRING_GENERAL): BOOLEAN
			-- true if path has directory step
		local
			pos_left_separator, pos_right_separator: INTEGER
			step: ZSTRING
		do
			step := as_zstring (a_step)
			pos_left_separator := parent_path.substring_index (step, 1) - 1
			pos_right_separator := pos_left_separator + step.count + 1
			if 0 <= pos_left_separator and pos_right_separator <= parent_path.count then
				if is_separator (parent_path, pos_right_separator) then
					Result := pos_left_separator > 0 implies is_separator (parent_path, pos_left_separator)
				end
			end
		end

	is_absolute: BOOLEAN
		local
			str: ZSTRING
		do
			str := parent_path
			if {PLATFORM}.is_windows then
				Result := starts_with_drive (str)
			else
				Result := not str.is_empty and then is_separator (str, 1)
			end
		end

	is_directory: BOOLEAN
		deferred
		end

	is_empty: BOOLEAN
		do
			Result := parent_path.is_empty and base.is_empty
		end

	is_expandable: BOOLEAN
		-- `True' if `base' or `parent' contain what maybe expandable variables
		do
			Result := has_expansion_variable (parent_path) or else has_expansion_variable (base)
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
			Result :=	across to_string.split (Separator) as list all
								nt.is_valid_step_at (list.item, list.cursor_index)
							end
		end


feature -- Conversion

	escaped: ZSTRING
		-- escaped for use as command line argument
		-- On Unix characters like colon, space etc are prefixed with a backslash
		-- On Windows this results in a quoted string
		do
			Result := File_system.escaped_path (temporary_path)
		end

	out: STRING
		do
			Result := debug_output
		end

	steps: EL_PATH_STEPS
		do
			create Result.make_from_path (Current)
		end

	to_ntfs_compatible (c: CHARACTER): like Current
		-- NT file system compatible path string using `c' to substitue invalid characters
		local
			nt: EL_NT_FILE_SYSTEM_ROUTINES; substitutes: ZSTRING
			step_list: EL_ZSTRING_LIST
		do
			substitutes := n_character_string (c, Invalid_NTFS_characters.count)
			create step_list.make_split (to_string, Separator)
			across step_list as list loop
				if not nt.is_valid_step_at (list.item, list.cursor_index) then
					step_list [list.cursor_index] := list.item.translated (Invalid_NTFS_characters, substitutes)
				end
			end
			Result := new_path (step_list.joined (Separator))
		end

feature -- Element change

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

	expand
		-- expand environment variables in each step
		do
			if is_expandable and then attached steps as l_steps then
				l_steps.expand
				base := l_steps.base
				l_steps.remove_tail (1)
				set_parent_path (l_steps.to_string)
			end
		end

	prune_until (last_step: READABLE_STRING_GENERAL)
		do
			if attached steps as l_steps then
				l_steps.prune_until (last_step)
				set_path (l_steps.to_string)
			end
		end

	prune_tail
		local
			l_path: ZSTRING; index: INTEGER
		do
			l_path := temporary_path
			index := l_path.last_index_of (Separator, l_path.count)
			if index = 1 then
				-- Eg. /etc
				base := parent_path.twin
				set_parent_path (Empty_path)
			elseif index > 0 then
				l_path.keep_head (index - 1)
				set_path (l_path)
			else
				base.wipe_out
			end
		end

	set_parent_path (a_parent: READABLE_STRING_GENERAL)
		local
			l_path: ZSTRING
		do
			if a_parent.is_empty then
				parent_path := Empty_path
			else
				l_path := temporary_copy (a_parent)
				if a_parent [a_parent.count] /= Separator then
					l_path.append_character (Separator)
				end
				Parent_set.put_copy (l_path)
				parent_path := Parent_set.found_item
			end
			internal_hash_code := 0
		end

	set_parent (dir_path: EL_DIR_PATH)
		do
			set_parent_path (dir_path.temporary_path)
		end

	set_path (a_path: READABLE_STRING_GENERAL)
		do
			make (a_path)
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

	wipe_out
		do
			default_create
		ensure
			is_empty: is_empty
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := base.is_equal (other.base) and parent_path.is_equal (other.parent_path)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		local
			other_parent: like parent_path
		do
			other_parent := other.parent_path
			if parent_path ~ other_parent then
				Result := base < other.base
			else
				Result := parent_path < other_parent
			end
		end

	same_as (path: READABLE_STRING_GENERAL): BOOLEAN
		local
			i, start_index: INTEGER; l_path: ZSTRING
			i_th_part: READABLE_STRING_GENERAL
		do
			if path.count = count then
				Result := True
				if path.count > 0 then
					l_path := normalized_copy (path)
					start_index := 1
					from i := 1 until i > part_count or else not Result loop
						i_th_part := part_string (i)
						if l_path.same_substring (i_th_part, start_index, False) then
							start_index := start_index + i_th_part.count
							i := i + 1
						else
							Result := False
						end
					end
				end
			end
		end

feature -- Duplication

	copy (other: like Current)
		do
			make_from_other (other)
		end

feature {EL_PATH} -- Implementation

	reset_hash
		do
			internal_hash_code := 0
		end

	new_path (a_path: ZSTRING): like Current
		deferred
		end

feature {EL_PATH_IMPLEMENTATION} -- Internal attributes

	internal_hash_code: INTEGER

	parent_path: ZSTRING

feature {NONE} -- Type definitions

	Type_parent: EL_DIR_PATH
		require
			never_called: False
		once
		end

invariant
	parent_set_has_parent_path: parent_path /= Empty_path implies Parent_set.has (parent_path)
end