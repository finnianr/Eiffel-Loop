note
	description: "[
		Implemention routines for class ${EL_PATH} with routines to convert path to other types
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-27 8:49:08 GMT (Friday 27th September 2024)"
	revision: "49"

deferred class
	EL_CONVERTABLE_PATH

inherit
	EL_PATH_PARENT

	EL_PATH_BASE_NAME

feature -- Measurement

	count: INTEGER
		-- character count
		-- (works for uri paths too)
		local
			i: INTEGER
		do
			from i := 1 until i > part_count loop
				Result := Result + part_string (i).count
				i := i + 1
			end
		end

	parent_count: INTEGER
		do
			Result := parent_path.count
		end

	step_count: INTEGER
		do
			Result := parent_path.occurrences (Separator) + 1
		end

	utf_8_byte_count: INTEGER
		-- byte count to store path as UTF-8
		-- (works for uri paths too)
		local
			i: INTEGER
		do
			from i := 1 until i > part_count loop
				if attached part_string (i) as i_th_part then
					if attached {ZSTRING} i_th_part as zstr then
						Result := Result + zstr.utf_8_byte_count
					else
						Result := Result + shared_cursor (i_th_part).utf_8_byte_count
					end
				end
				i := i + 1
			end
		end

feature -- Conversion

	as_string_32: STRING_32

		do
			inspect volume.code
				when 0 then
					create Result.make (count)
			else
				create Result.make (count + 2)
				Result.append_character (volume); Result.append_character (':')
			end
			parent_path.append_to_string_32 (Result); base.append_to_string_32 (Result)
		ensure then
			same_as_to_string: to_string.as_string_32 ~ Result
		end

	to_general: READABLE_STRING_GENERAL
		do
			Result := temporary_path.to_general
		ensure
			same_as_to_string: to_string.same_string_general (Result)
		end

	to_path: PATH
		do
			create Result.make_from_string (as_string_32)
		end

	to_string: ZSTRING
			--
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > part_count loop
				Result.append_string_general (part_string (i))
				i := i + 1
			end
		end

	to_unix, as_unix: ZSTRING
		do
			Result := to_string
			if {PLATFORM}.is_windows then
				Result.replace_character (Windows_separator, Unix_separator)
			end
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
		local
			i: INTEGER
		do
			create Result.make (utf_8_byte_count)
			from i := 1 until i > part_count loop
				if attached part_string (i) as i_th_part then
					if attached {ZSTRING} i_th_part as zstr then
						zstr.append_to_utf_8 (Result)
					else
						shared_cursor (i_th_part).append_to_utf_8 (Result)
					end
				end
				i := i + 1
			end
		end

	to_windows, as_windows: ZSTRING
		do
			Result := to_string
			if not {PLATFORM}.is_windows then
				Result.replace_character (Unix_separator, Windows_separator)
			end
		end

feature -- Append to other

	append_to (str: EL_APPENDABLE_ZSTRING)
		-- append path to string `str'
		local
			i: INTEGER
		do
			str.grow (str.count + count)
			from i := 1 until i > part_count loop
				str.append_string_general (part_string (i))
				i := i + 1
			end
		end

	append_to_32 (str: STRING_32)
		-- append path to string `str'
		local
			i: INTEGER; i_th_part: READABLE_STRING_GENERAL
		do
			str.grow (str.count + count)
			from i := 1 until i > part_count loop
				i_th_part := part_string (i)
				if attached {ZSTRING} i_th_part as zstr then
					zstr.append_to_string_32 (str)
				else
					str.append_string_general (i_th_part)
				end
				i := i + 1
			end
		end

	append_to_uri (uri: EL_URI_STRING_8)
		local
			i, old_count: INTEGER
		do
			old_count := uri.count
			append_file_prefix (uri)
			from i := 1 until i > part_count loop
				uri.append_general (unix_part_string (i))
				i := i + 1
			end
		end

	append_to_utf_8 (utf_8_out: STRING)
		-- append path to string `str'
		local
			i: INTEGER
		do
			utf_8_out.grow (utf_8_out.count + utf_8_byte_count)
			from i := 1 until i > part_count loop
				if attached part_string (i) as general then
					if attached {ZSTRING} general as zstr then
						zstr.append_to_utf_8 (utf_8_out)
					else
						shared_cursor (general).append_to_utf_8 (utf_8_out)
					end
				end
				i := i + 1
			end
		end

feature {EL_PATH, STRING_HANDLER} -- Implementation

	append (a_path: EL_PATH)
		require
			relative_path: not is_empty implies not a_path.is_absolute
		local
			l_path: ZSTRING
		do
			if a_path.count > 0 then
				l_path := temporary_path
				if l_path.count > 0 and then not l_path.ends_with_character (Separator) then
					l_path.append_character (Separator)
				end
				resolve_back_steps (a_path.parent_path, l_path)
				l_path.append (a_path.base)
				set_path (l_path)
			end
		end

	append_file_prefix (uri: EL_URI_STRING_8)
		do
			if is_absolute then
				uri.append_raw_8 (once "file://")
				if {PLATFORM}.is_windows then
					uri.append_character ('/')
				end
			end
		end

	debug_output: STRING_32
		local
			index: INTEGER; l_base: STRING_32
		do
			-- Cannot use any path routines here because of possible corruption of `Temp_path'
			create Result.make (count + Square_brackets.count)
			Result.append (Square_brackets)
			append_to_32 (Result)
			index := Result.last_index_of (Separator, Result.count)
			if first_index <= index and index < Result.count then
				l_base := Result.substring (index + 1, Result.count)
				Result.keep_head (index - 1)
				Result.insert_string (l_base, 2)
			else
				Result.remove_head (Square_brackets.count)
			end
		end

	empty_uri_path: like URI_path_string
		do
			Result := URI_path_string; Result.wipe_out
		end

	first_index: INTEGER
		do
			Result := 1
		end

	leading_back_step_count (a_path: READABLE_STRING_GENERAL): INTEGER
		-- count of leading steps "../" in `a_path'
		local
			i: INTEGER; occurs: BOOLEAN
		do
			from i := 1; occurs := True until not occurs or else i + 2 > a_path.count loop
				occurs := Back_dir_step.same_characters_general (a_path, i, i + 2, 1)
				if occurs then
					Result := Result + 1
				end
				i := i + 3
			end
		end

	unix_part_string (index: INTEGER): READABLE_STRING_GENERAL
		do
			Result := part_string (index)
			if {PLATFORM}.is_windows and then Result.has (Windows_separator)
				and then attached temporary_copy (Result, 1) as part
			then
				part.replace_character (Windows_separator, Unix_separator)
				Result := part
			end
		end

	relative_temporary_path (a_parent: DIR_PATH): ZSTRING
		local
			remove_count: INTEGER
		do
			Result := temporary_path
			remove_count := a_parent.count
			if Result.count > remove_count and then Result [remove_count + 1] = Separator then
				remove_count := remove_count + 1
			end
			Result.remove_head (remove_count)
		end

	remove_step_right (a_path: ZSTRING)
		require
			has_step:  a_path.ends_with_character (Separator)
		local
			previous_pos: INTEGER
		do
			if a_path.count >= 2 then
				previous_pos := a_path.last_index_of (Separator, a_path.count - 1)
				if previous_pos > 0 then
					a_path.keep_head (previous_pos)
				else
					a_path.wipe_out
				end
			else
				a_path.wipe_out
			end
		end

	replace_separator (separator_old, separator_new: CHARACTER_32)
		local
			l_path: ZSTRING
		do
			l_path := temporary_copy (parent_path, 1)
			l_path.replace_character (separator_old, separator_new)
			set_shared_parent_path (l_path)
		end

	resolve_back_steps (a_parent_path: READABLE_STRING_GENERAL; output_path: ZSTRING)
		-- resolve leading back step strings "../" in `a_parent_path' by substracting steps
		-- from `output_path'
		local
			i, back_step_count: INTEGER
		do
			back_step_count := leading_back_step_count (a_parent_path)
			if back_step_count > 0 then
				from i := 1 until i > back_step_count or else output_path.is_empty loop
					remove_step_right (output_path)
					i := i + 1
				end
				output_path.append_substring_general (a_parent_path, back_step_count * 3 + 1, a_parent_path.count)
			else
				output_path.append_string_general (a_parent_path)
			end
		end

	separator_needed (left: ZSTRING; right: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `left' and `right' path strings need the `Separator' to be joined
		do
			if left.count > 0 and then left [left.count] /= Separator then
				Result := not (right.count > 0 and then right [1] = Separator)
			end
		end

end