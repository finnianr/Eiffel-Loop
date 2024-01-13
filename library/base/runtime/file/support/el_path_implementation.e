note
	description: "Implemention routines for class [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-13 17:22:50 GMT (Saturday 13th January 2024)"
	revision: "40"

deferred class
	EL_PATH_IMPLEMENTATION

inherit
	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	EL_ZSTRING_ROUTINES_IMP
		rename
			append_to as string_append_to,
			translate as string_translate,
			wipe_out as string_wipe_out
		export
			{NONE} all
		undefine
			copy, default_create, is_equal, out
		end

	DEBUG_OUTPUT

	STRING_HANDLER

	EL_MODULE_DIRECTORY; EL_MODULE_FILE_SYSTEM; EL_MODULE_FORMAT

	EL_SHARED_STRING_8_BUFFER_SCOPES; EL_SHARED_STRING_32_BUFFER_SCOPES; EL_SHARED_ZSTRING_BUFFER_SCOPES

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

	parent_count: INTEGER
		do
			Result := parent_path.count
		end

	step_count: INTEGER
		do
			Result := parent_path.occurrences (Separator) + 1
		end

feature -- Conversion

	to_general: READABLE_STRING_GENERAL
		do
			Result := temporary_path.to_general
		ensure
			same_as_to_string: to_string.same_string_general (Result)
		end

	as_string_32: STRING_32
		do
			create Result.make (count)
			append_to_32 (Result)
		ensure then
			same_as_to_string: to_string.as_string_32 ~ Result
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

feature -- Status query

	is_empty: BOOLEAN
		deferred
		end

feature {NONE} -- Deferred implementation

	base: ZSTRING
		deferred
		end

	is_absolute: BOOLEAN
		deferred
		end

	parent_path: ZSTRING
		deferred
		end

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

	empty_temp_path: ZSTRING
		-- temporary shared path
		do
			Result := Temp_path
			Result.wipe_out
		end

	has_expansion_variable (a_path: ZSTRING): BOOLEAN
		-- a step contains what might be an expandable variable
		local
			pos_dollor: INTEGER
		do
			pos_dollor := a_path.index_of ('$', 1)
			Result := pos_dollor > 0 and then (pos_dollor = 1 or else is_separator (a_path, pos_dollor - 1))
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
			if Result.count > remove_count and then is_separator (Result, remove_count + 1) then
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

	temporary_copy (path: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := Temp_path
			if Result /= path then
				Result.wipe_out
				Result.append_string_general (path)
			end
		end

	temporary_path: ZSTRING
		-- temporary shared copy of current path
		do
			Result := empty_temp_path
			append_to (Result)
		end

feature {NONE} -- Constants

	Empty_path: ZSTRING
		once
			create Result.make_empty
		end

	Magic_number: INTEGER = 8388593
		-- Greatest prime lower than 2^23
		-- so that this magic number shifted to the left does not exceed 2^31.

	Parent_set: EL_HASH_SET [ZSTRING]
			--
		once
			create Result.make (100)
		end

	Square_brackets: STRING_32
		once
			Result := "[] "
		end

	Temp_path: ZSTRING
		once
			create Result.make_empty
		end

	URI_path_string: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

end