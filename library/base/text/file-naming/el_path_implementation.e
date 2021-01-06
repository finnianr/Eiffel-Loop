note
	description: "Implemention routines for class [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 12:09:20 GMT (Tuesday 5th January 2021)"
	revision: "13"

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

	EL_SHARED_ONCE_STRING_8

	EL_SHARED_ONCE_STRING_32

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
			c: EL_UTF_CONVERTER
		do
			Result := once_empty_string_8
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
			str: STRING_32
		do
			str := once_empty_string_32
			append_to_32 (str)
			create Result.make_from_string (str)
		end

feature -- Basic operations

	append_to (str: ZSTRING)
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
			l_path: ZSTRING; i: INTEGER
		do
			if not a_path.is_empty then
				l_path := temporary_path
				i := l_path.count
				if i > 0 and then l_path [i] /= Separator then
					l_path.append_unicode (Separator.natural_32_code)
				end
				l_path.append (a_path.parent_path)
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

feature {EL_PATH} -- Implementation

	is_absolute: BOOLEAN
		deferred
		end

	has_expansion_variable (a_path: ZSTRING): BOOLEAN
		-- a step contains what might be an expandable variable
		local
			pos_dollor: INTEGER
		do
			pos_dollor := a_path.index_of ('$', 1)
			Result := pos_dollor > 0 and then (pos_dollor = 1 or else a_path [pos_dollor - 1] = Separator)
		end

	relative_temporary_path (a_parent: EL_DIR_PATH): ZSTRING
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

	Back_dir_step: ZSTRING
		once
			Result := "../"
		end

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
			create Result.make_equal (100)
		end

	Single_dot: ZSTRING
		once
			Result := "."
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