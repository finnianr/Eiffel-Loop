note
	description: "File system path with cached parent strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 7:48:27 GMT (Thursday 22nd August 2024)"
	revision: "79"

deferred class
	EL_PATH

inherit
	EL_CONVERTABLE_PATH
		undefine
			default_create, out, copy
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

convert
	to_string: {EL_ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
	steps: {EL_PATH_STEPS}, to_path: {PATH}, to_uri: {EL_URI}

feature {NONE} -- Initialization

	default_create
		do
			parent_path := Empty_path; base := Empty_path
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

	make_from_path (a_path: PATH)
		do
			make (Path_manager.as_string (a_path))
		end

	make_expanded (a_path: READABLE_STRING_GENERAL)
		do
			make (a_path)
			expand
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
			create Result.make_parent (Current)
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

	with_new_extension (new_extension: READABLE_STRING_GENERAL): like Current
		do
			Result := twin
			if has_dot_extension then
				Result.replace_extension (new_extension)
			else
				Result.add_extension (new_extension)
			end
		end

	without_extension: like Current
		do
			Result := twin
			Result.remove_extension
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
			l_parent_path := empty_temp_path
			l_parent_path.append (parent_path)
			l_parent_path.append (base)
			set_parent_path (l_parent_path)
			base.wipe_out
			base.append_string_general (a_step)
		end

	expand
		-- expand environment variables in each step
		do
			if is_expandable then
				make (Execution_environment.substituted (temporary_path))
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
			inspect index
				when 0 then
					base.wipe_out

				when 1 then
					-- Eg. /etc
					base := parent_path.twin
					set_parent_path (Empty_path)
			else
				l_path.keep_head (index - 1)
				set_path (l_path)
			end
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
			create Result.make (to_string)
		end

	to_ntfs_compatible (c: CHARACTER): like Current
		require
			not_invalid_substitute: not invalid_ntfs_character (c)
		-- NT file system compatible path string using `uc' to substitue invalid characters
		deferred
		end

feature -- Removal

	wipe_out
		do
			default_create
		ensure
			is_empty: is_empty
		end

feature -- Comparison

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

	current_path: EL_PATH
		do
			Result := Current
		end

	new_path (a_path: ZSTRING): like Current
		deferred
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