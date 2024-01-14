note
	description: "Implemention routines for class [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-14 10:44:47 GMT (Sunday 14th January 2024)"
	revision: "41"

deferred class
	EL_PATH_IMPLEMENTATION

inherit
	HASHABLE undefine is_equal end

	EL_PATH_PROPERTIES

	EL_PATH_BUFFER_ROUTINES

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
			create Result.make (count)
			append_to_32 (Result)
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
			across String_32_scope as scope loop
				if attached scope.best_item (count) as str then
					append_to_32 (str)
					create Result.make_from_string (str)
				end
			end
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

feature -- Basic operations

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
				uri.append_general (part_string (i))
				i := i + 1
			end
			if {PLATFORM}.is_windows then
				from i := old_count + 1 until i > uri.count loop
					if uri [i] = '\' then
						uri.put ('/', i)
					end
					i := i + 1
				end
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

feature {NONE} -- Deferred implementation

	set_parent_path (a_parent: ZSTRING)
		deferred
		end

	set_path (a_path: READABLE_STRING_GENERAL)
		deferred
		end

feature {EL_PATH, STRING_HANDLER} -- Implementation

	append (a_path: EL_PATH)
		require
			relative_path: not is_empty implies not a_path.is_absolute
		local
			l_path: ZSTRING; i, back_step_count: INTEGER
		do
			if not a_path.is_empty then
				l_path := temporary_path
				i := l_path.count
				if i > 0 and then not is_separator (l_path, i) then
					l_path.append_character (Separator)
				end
				back_step_count := leading_back_step_count (a_path.parent_path)
				if back_step_count > 0 then
					from i := 1 until i > back_step_count or else l_path.is_empty loop
						remove_step_right (l_path)
						i := i + 1
					end
					l_path.append_substring (a_path.parent_path, back_step_count * 3 + 1, a_path.parent_path.count)
				else
					l_path.append (a_path.parent_path)
				end
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

	empty_uri_path: like URI_path_string
		do
			Result := URI_path_string; Result.wipe_out
		end

	first_index: INTEGER
		do
			Result := 1
		end

	part_count: INTEGER
		-- count of string components
		-- (5 in the case of URI paths)
		do
			Result := 2
		end

	part_string (index: INTEGER): READABLE_STRING_GENERAL
		require
			valid_index: 1 <= index and index <= part_count
		do
			inspect index
				when 1 then
					Result := parent_path
			else
				Result := base
			end
		end

	replace_separator (separator_old, separator_new: CHARACTER_32)
		local
			l_path: ZSTRING
		do
			l_path := temporary_copy (parent_path)
			l_path.replace_character (separator_old, separator_new)
			set_parent_path (l_path)
		end

feature {EL_PATH} -- Implementation

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

	is_separator (str: ZSTRING; i: INTEGER): BOOLEAN
		-- `True' if `str [i] = Separator'
		do
			Result := str [i] = Separator
		end

	leading_back_step_count (a_path: ZSTRING): INTEGER
		local
			i: INTEGER; occurs: BOOLEAN
		do
			from i := 1; occurs := True until not occurs or else i + 2 > a_path.count loop
				occurs := a_path.same_characters (Back_dir_step, 1, 3, i)
				if occurs then
					Result := Result + 1
				end
				i := i + 3
			end
		end

	normalized_copy (path: READABLE_STRING_GENERAL): ZSTRING
		-- temporary path string normalized for platform
		do
			Result := temporary_copy (path)
			if {PLATFORM}.is_windows and then path.has (Unix_separator) then
				Result.replace_character (Unix_separator, Separator)
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

feature {EL_PATH_IMPLEMENTATION} -- Internal attributes

	internal_hash_code: INTEGER

	parent_path: ZSTRING

end