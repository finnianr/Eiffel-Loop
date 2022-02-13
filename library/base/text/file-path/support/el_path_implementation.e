note
	description: "Implemention routines for class [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 12:20:40 GMT (Sunday 13th February 2022)"
	revision: "24"

deferred class
	EL_PATH_IMPLEMENTATION

inherit
	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	DEBUG_OUTPUT
		rename
			debug_output as as_string_32
		end

	STRING_HANDLER

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_FORMAT

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

	dot_index: INTEGER
		-- index of last dot, 0 if none
		do
			if not base.is_empty then
				Result := base.last_index_of ('.', base.count)
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

	as_string_32: STRING_32
		do
			create Result.make (count)
			append_to_32 (Result)
		ensure then
			same_as_to_string: to_string.as_string_32 ~ Result
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

	to_utf_8: STRING
		local
			i: INTEGER; i_th_part: READABLE_STRING_GENERAL
			c: EL_UTF_CONVERTER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := buffer.empty
			from i := 1 until i > part_count loop
				i_th_part := part_string (i)
				if attached {ZSTRING} i_th_part as zstr then
					zstr.append_to_utf_8 (Result)
				else
					c.utf_32_string_into_utf_8_string_8 (i_th_part, Result)
				end
				i := i + 1
			end
			Result := Result.twin
		end

	to_uri: EL_URI
		local
			uri: like empty_uri_path
		do
			uri := empty_uri_path
			append_to_uri (uri)
			create Result.make (uri)
		end

	to_path: PATH
		local
			str: STRING_32; buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			str := buffer.empty
			append_to_32 (str)
			create Result.make_from_string (str)
		end

	to_unix, as_unix: ZSTRING
		do
			Result := to_string
			if {PLATFORM}.is_windows then
				Result.replace_character (Windows_separator, Unix_separator)
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

feature {NONE} -- Deferred implementation

	base: ZSTRING
		deferred
		end

	parent_path: ZSTRING
		deferred
		end

	set_path (a_path: READABLE_STRING_GENERAL)
		deferred
		end

	set_parent_path (a_parent: READABLE_STRING_GENERAL)
		deferred
		end

feature {EL_PATH, STRING_HANDLER} -- Implementation

	append (a_path: EL_PATH)
		require
			relative_path: not a_path.is_absolute
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

	part_count: INTEGER
		-- count of string components
		-- (5 in the case of URI paths)
		do
			Result := 2
		end

	part_string (index: INTEGER): READABLE_STRING_GENERAL
		require
			valid_index:  1 <= index and index <= part_count
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

	zstring: EL_ZSTRING_ROUTINES
		do
		end

feature {EL_PATH} -- Implementation

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

	is_absolute: BOOLEAN
		deferred
		end

	is_separator (str: ZSTRING; i: INTEGER): BOOLEAN
		-- `True' if `str [i] = Separator'
		do
			Result := str [i] = Separator
		end

	has_expansion_variable (a_path: ZSTRING): BOOLEAN
		-- a step contains what might be an expandable variable
		local
			pos_dollor: INTEGER
		do
			pos_dollor := a_path.index_of ('$', 1)
			Result := pos_dollor > 0 and then (pos_dollor = 1 or else is_separator (a_path, pos_dollor - 1))
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
			has_step:  a_path.count > 0 and then a_path [a_path.count] = Separator
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
			Result := Temp_path
			Result.wipe_out
			append_to (Result)
		end

feature {NONE} -- Constants

	Empty_path: ZSTRING
		once
			create Result.make_empty
		end
		-- Greatest prime lower than 2^23
		-- so that this magic number shifted to the left does not exceed 2^31.

	Forward_slash: ZSTRING
		once
			Result := "/"
		end

	Magic_number: INTEGER = 8388593

	Parent_set: EL_HASH_SET [ZSTRING]
			--
		once
			create Result.make (100)
		end

	Temp_path: ZSTRING
		once
			create Result.make_empty
		end

	URI_path_string: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

end